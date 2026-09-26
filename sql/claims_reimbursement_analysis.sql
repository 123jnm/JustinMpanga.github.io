-- Healthcare claims reimbursement analysis
-- Source: CDC dataset on reimbursements to providers and facilities for
-- testing, treatment, and vaccine administration of uninsured patients.
--
-- Dialect: PostgreSQL / DuckDB-compatible SQL.
-- Load the CSV as `uninsured_claims` before running these queries.

-- 1. Standardize currency strings once in a staging view. Empty values are
--    treated as zero only after documenting that assumption.
CREATE OR REPLACE VIEW claims_clean AS
SELECT
    NULLIF(TRIM("Provider Name"), '') AS provider_name,
    UPPER(TRIM(State)) AS state,
    INITCAP(TRIM(City)) AS city,
    COALESCE(CAST(REPLACE(REPLACE("Claims Paid for Testing", '$', ''), ',', '') AS DECIMAL(14, 2)), 0) AS testing_paid,
    COALESCE(CAST(REPLACE(REPLACE("Claims Paid for Treatment", '$', ''), ',', '') AS DECIMAL(14, 2)), 0) AS treatment_paid,
    COALESCE(CAST(REPLACE(REPLACE("Claims Paid for Vaccine", '$', ''), ',', '') AS DECIMAL(14, 2)), 0) AS vaccine_paid
FROM uninsured_claims;

-- 2. State-level reimbursement mix for a dashboard KPI table.
CREATE OR REPLACE VIEW state_reimbursement_summary AS
SELECT
    state,
    COUNT(*) AS provider_rows,
    SUM(testing_paid) AS testing_paid,
    SUM(treatment_paid) AS treatment_paid,
    SUM(vaccine_paid) AS vaccine_paid,
    SUM(testing_paid + treatment_paid + vaccine_paid) AS total_reimbursement,
    ROUND(100.0 * SUM(vaccine_paid) / NULLIF(SUM(testing_paid + treatment_paid + vaccine_paid), 0), 2) AS vaccine_share_pct
FROM claims_clean
GROUP BY state;

-- 3. Rank states by total reimbursement and expose the category mix.
SELECT
    state,
    total_reimbursement,
    testing_paid,
    treatment_paid,
    vaccine_paid,
    vaccine_share_pct,
    DENSE_RANK() OVER (ORDER BY total_reimbursement DESC) AS reimbursement_rank
FROM state_reimbursement_summary
ORDER BY reimbursement_rank;

-- 4. Provider concentration: a useful operational-risk metric.
WITH provider_totals AS (
    SELECT
        provider_name,
        state,
        SUM(testing_paid + treatment_paid + vaccine_paid) AS total_reimbursement
    FROM claims_clean
    WHERE provider_name IS NOT NULL
    GROUP BY provider_name, state
), ranked AS (
    SELECT
        *,
        SUM(total_reimbursement) OVER () AS all_provider_reimbursement,
        SUM(total_reimbursement) OVER (
            ORDER BY total_reimbursement DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_reimbursement
    FROM provider_totals
)
SELECT
    provider_name,
    state,
    total_reimbursement,
    ROUND(100.0 * total_reimbursement / NULLIF(all_provider_reimbursement, 0), 2) AS provider_share_pct,
    ROUND(100.0 * cumulative_reimbursement / NULLIF(all_provider_reimbursement, 0), 2) AS cumulative_share_pct
FROM ranked
ORDER BY total_reimbursement DESC
LIMIT 25;

-- 5. Data-quality check: rows where all three payment categories are zero.
SELECT state, COUNT(*) AS zero_value_rows
FROM claims_clean
WHERE testing_paid = 0 AND treatment_paid = 0 AND vaccine_paid = 0
GROUP BY state
ORDER BY zero_value_rows DESC;
