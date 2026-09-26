# Justin Mpanga

Healthcare data analyst portfolio focused on turning public-health and healthcare operations data into reproducible analysis, useful dashboards, and carefully evaluated models.

## Projects

- [Portfolio project catalog](PORTFOLIO_PROJECTS.md)
- [Diabetes burden Python notebook](notebooks/diabetes_burden_models.ipynb)
- [Diabetes trend R notebook](notebooks/diabetes_trend_analysis_R.ipynb)
- [Diabetes trend analysis in R](R/diabetes_trend_analysis.R)
- [Claims reimbursement SQL notebook](notebooks/claims_reimbursement_analysis_SQL.ipynb)
- [Uninsured-care reimbursement SQL analysis](sql/claims_reimbursement_analysis.sql)
- [Tableau and Power BI dashboard specification](dashboard_specs/tableau_powerbi_healthcare_dashboard.md)

## Data sources

Dataset exports are downloaded from the CDC open-data catalog into `data/` and excluded from Git. From the repository root, run `Rscript R/download_cdc_datasets.R` to download the uninsured-care reimbursement, COVID-19 excess-deaths, and national diabetes-indicator datasets, plus the three CDC Lyme line-list periods combined into `data/lyme_line_list.csv`.

The Lyme output includes a `Surveillance_Period` column identifying the source period. CDC uses different Lyme surveillance case definitions beginning in 2008 and 2022; do not interpret the full combined series as methodologically uniform.

To download the BRFSS prevalence export locally (over 3 million rows), run `Rscript R/download_brfss_prevalence.R` from the repository root. The output is saved under `data/` and excluded from Git.

To download the [CDC BEAM Dashboard top 30 serotypes dataset](https://data.cdc.gov/Foodborne-Waterborne-and-Related-Diseases/BEAM-Dashboard-Top-30-Most-Common-Serotypes/ch83-ush6), run `Rscript R/download_beam_dashboard.R` from the repository root. The output is saved as `data/beam_top_30_serotypes.csv` and excluded from Git. This replaces the previous HHS-region extract; the CDC source reports top serotypes and does not have the same regional breakdown.

