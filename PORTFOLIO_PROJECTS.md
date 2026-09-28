# Healthcare analytics portfolio projects

I built these projects around practical public-health and healthcare operations questions. Each one follows a reproducible path from source data to findings, with the limits of those findings made clear.

**Shared workflow:** The [ETL procedures and lineage guide](ETL_PIPELINES.md) follows each dataset through acquisition, staging, cleaning, validation, transformation, and publication.

## 1. Diabetes burden: statistics and predictive modeling

**Artifacts:** [Python notebook](notebooks/diabetes_burden_models.ipynb), [R analysis script](R/diabetes_trend_analysis.R), [CDC ETL script](R/download_cdc_datasets.R)

I start with the CDC USDSS extract, check its year, estimate, and confidence-limit fields, then focus on diagnosed-diabetes percentages for comparable national strata. Age-adjusted values anchor the trend; annual changes, subgroup tables, and a confidence-band chart make the variation visible. In this snapshot, the estimate moves from 6.5% in 2015 to 6.6% in 2024, with noticeable movement in between. I also compare a random forest and an MLP using a chronological holdout. The forest's MAE is 1.055 and RMSE is 1.725, but those scores describe estimates for population strata, not individual patients.

**Skills:** Python, pandas, scikit-learn, neural networks, statistical reasoning, visualization, R, ggplot2.

## 2. Uninsured-care reimbursement operations

**Artifacts:** [SQL notebook](notebooks/claims_reimbursement_analysis_SQL.ipynb), [SQL analysis](sql/claims_reimbursement_analysis.sql), [CDC ETL script](R/download_cdc_datasets.R)

The claims workflow loads the CDC/HRSA provider extract into DuckDB at provider/city/state grain. After trimming text fields and typing payment amounts, I check for missing, negative, and all-zero values before building cleaned and state-level views. Window functions show service mix and provider concentration. In this snapshot, Texas leads with about $3.16 billion, followed by California at $2.48 billion; the largest provider/state pair is Curative Labs Inc. in DC at about $646 million. These rankings show where reported payments concentrate, not patient volume or why one state received more. I reconcile row counts and payment totals before publishing.

**Skills:** SQL, ETL, data quality, window functions, KPI design, healthcare operations.

## 3. Tableau and Power BI healthcare dashboard

**Artifacts:** [Dashboard specification](dashboard_specs/tableau_powerbi_healthcare_dashboard.md), [ETL and lineage guide](ETL_PIPELINES.md)

Claims and diabetes stay in separate fact tables because their row grains and measures differ. The [dashboard specification](dashboard_specs/tableau_powerbi_healthcare_dashboard.md) shows how I connect compatible dimensions, expose source freshness, and turn the analyses into a decision-support view with DAX, Tableau calculations, filters, and tooltips.

**Skills:** Tableau, Power BI, DAX, Power Query, dimensional modeling, data storytelling.

## 4. Existing BRFSS metabolic-risk modeling track

I keep the [CDC BRFSS prevalence dataset](https://data.cdc.gov/Behavioral-Risk-Factors/Behavioral-Risk-Factor-Surveillance-System-BRFSS-P/dttw-5yxu) as a separate exploratory track. It contains aggregate prevalence estimates, not respondent-level records, so the multi-million-row export stays local through [the R download script](R/download_brfss_prevalence.R). It also lacks laboratory measures required to diagnose metabolic syndrome. Any future respondent-level BRFSS analysis would need to account for survey design and check subgroup performance before making health claims.

## Suggested portfolio presentation

For each project, I aim to include four things:

1. A clear question tied to a decision.
2. Reproducible code, useful comments, and a data dictionary.
3. A polished visual or dashboard that shows the evidence.
4. A limitations section that explains what the data cannot support.

Together, these pieces show how I move from raw data to a defensible story without presenting exploratory models as clinical tools.
