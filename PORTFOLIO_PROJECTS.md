# Healthcare analytics portfolio projects

These projects are designed as a connected portfolio for healthcare data analyst roles. Each one answers a different kind of business or public-health question and makes the limits of the data visible.

## 1. Diabetes burden: statistics and predictive modeling

**Artifacts:** [Python notebook](notebooks/diabetes_burden_models.ipynb), [R notebook](notebooks/diabetes_trend_analysis_R.ipynb), [R script](R/diabetes_trend_analysis.R)

Use the CDC diabetes surveillance extract to produce trend estimates, compare demographic strata, calculate recent change, and benchmark a random forest against a multilayer perceptron. The notebook demonstrates chronological holdout design, one-hot encoding, MAE/RMSE/R2 evaluation, and interpretation of aggregated surveillance data.

**Skills:** Python, pandas, scikit-learn, neural networks, statistical reasoning, visualization, R, ggplot2.

## 2. Uninsured-care reimbursement operations

**Artifacts:** [SQL notebook](notebooks/claims_reimbursement_analysis_SQL.ipynb), [SQL analysis](sql/claims_reimbursement_analysis.sql)

Clean dollar fields, create a state-level reimbursement mart, rank provider concentration, calculate service-category mix, and expose zero-value rows for data-quality review. This is a strong SQL/operations project because it connects window functions and reusable views to concrete program questions.

**Skills:** SQL, ETL, data quality, window functions, KPI design, healthcare operations.

## 3. Tableau and Power BI healthcare dashboard

**Artifact:** [Dashboard specification](dashboard_specs/tableau_powerbi_healthcare_dashboard.md)

Build a two-page dashboard combining reimbursement operations with diabetes burden trends. The specification includes grain-aware modeling, DAX, Tableau calculations, Power Query rules, filters, tooltips, and interpretation guardrails.

**Skills:** Tableau, Power BI, DAX, Power Query, dimensional modeling, data storytelling.

## 4. Existing BRFSS metabolic-risk modeling track

The [CDC BRFSS prevalence dataset](https://data.cdc.gov/Behavioral-Risk-Factors/Behavioral-Risk-Factor-Surveillance-System-BRFSS-P/dttw-5yxu) is an aggregate, stratified prevalence export, not respondent-level data. Download it locally with [the R download script](R/download_brfss_prevalence.R) when needed; do not commit the multi-million-row export. Keep any future respondent-level modeling separate: BRFSS does not contain all laboratory measures required for a clinical metabolic-syndrome diagnosis. Present any proxy as exploratory, account for survey design when analyzing respondent-level data, and evaluate subgroup performance before making health claims.

## Suggested portfolio presentation

For each project, publish four things:

1. A short problem statement tied to a decision.
2. A reproducible code artifact with comments and a data dictionary.
3. One polished visual or dashboard screenshot.
4. A limitations section that explains what the data cannot support.

This combination shows technical range without presenting exploratory models as clinical tools.
