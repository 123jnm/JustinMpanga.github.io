# Healthcare access and burden dashboard specification

## Dashboard concept

**Title:** Uninsured care reimbursement and diabetes burden

**Audience:** public-health program leaders, healthcare operations analysts, and grant/reporting teams.

**Decision:** where is reimbursement concentrated, which service category drives it, and how does the broader diabetes burden trend over time?

## Data sources

1. `data/claims_reimbursement.csv` ([CDC/HRSA source](https://data.cdc.gov/d/rksx-33p3))
2. `data/diabetes_indicators.csv` ([CDC source](https://data.cdc.gov/d/c9xs-vhst))
3. Optional context: [CDC BRFSS prevalence dataset](https://data.cdc.gov/Behavioral-Risk-Factors/Behavioral-Risk-Factor-Surveillance-System-BRFSS-P/dttw-5yxu); download locally with `Rscript R/download_brfss_prevalence.R` if needed.

## Tableau build

### Dashboard 1: Reimbursement overview

- KPI cards: total reimbursement, provider rows, testing share, treatment share, vaccine share
- Filled map: total reimbursement by state
- Stacked bar: testing vs treatment vs vaccine by state
- Detail table: provider, city, state, total reimbursement, category shares
- Filters: state, city, provider, payment category

### Dashboard 2: Diabetes trend

- Line chart: diagnosed diabetes estimate by year
- Confidence-band area: lower and upper limits
- Small multiples: age, race, sex, and education strata
- Tooltip: estimate, confidence interval, data source, population definition
- Filters: indicator, year, age, race, sex, education

### Tableau calculated fields

```text
Total Reimbursement =
ZN([Claims Paid for Testing]) +
ZN([Claims Paid for Treatment]) +
ZN([Claims Paid for Vaccine])

Vaccine Share =
IF [Total Reimbursement] = 0 THEN 0
ELSE ZN([Claims Paid for Vaccine]) / [Total Reimbursement]
END
```

## Power BI build

### Recommended model

Create two fact tables, `FactClaims` and `FactDiabetes`, and shared dimensions for `DimState`, `DimYear`, and `DimMeasure`. Do not join claims provider rows directly to diabetes strata; they represent different grains.

### DAX measures

```DAX
Total Reimbursement =
SUM(FactClaims[TestingPaid]) +
SUM(FactClaims[TreatmentPaid]) +
SUM(FactClaims[VaccinePaid])

Vaccine Share =
DIVIDE(SUM(FactClaims[VaccinePaid]), [Total Reimbursement], 0)

Latest Diabetes Estimate =
VAR LatestYear = MAX(FactDiabetes[Year])
RETURN
CALCULATE(
    AVERAGE(FactDiabetes[Estimate]),
    FactDiabetes[Year] = LatestYear
)
```

### Power Query cleaning notes

- Strip dollar signs and commas from payment fields before changing their type.
- Convert blank payments to null first; document whether null means missing or zero.
- Keep `FactClaims` at provider-row grain.
- Keep confidence limits as numeric fields and preserve the source footnote.

## Quality and interpretation guardrails

- Reimbursement totals are not patient counts and should not be used as utilization rates without denominators.
- Diabetes estimates from different strata must not be averaged without a defensible weighting scheme.
- Suppressed values and footnotes need review before publication.
- Add a data freshness label and CDC source links to the published dashboard.
