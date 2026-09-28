# Justin Mpanga

I turn public-health and healthcare operations data into reproducible analyses, useful dashboards, and carefully evaluated models. Each project follows the data from source through cleaning and transformation to a question the results can help answer.

## Projects

- [Portfolio project catalog](PORTFOLIO_PROJECTS.md)
- [ETL procedures and data lineage](ETL_PIPELINES.md)
- [Diabetes burden Python notebook](notebooks/diabetes_burden_models.ipynb)
- [Diabetes trend analysis in R](R/diabetes_trend_analysis.R)
- [Claims reimbursement SQL notebook](notebooks/claims_reimbursement_analysis_SQL.ipynb)
- [Uninsured-care reimbursement SQL analysis](sql/claims_reimbursement_analysis.sql)
- [Tableau and Power BI dashboard specification](dashboard_specs/tableau_powerbi_healthcare_dashboard.md)

## Data sources

CDC exports live in the local, Git-ignored `data/` folder. The [ETL and data lineage guide](ETL_PIPELINES.md) records their source IDs, refresh steps, transformations, validation checks, outputs, and limitations.

To refresh the claims, excess-death, diabetes, and Lyme data, run `Rscript R/download_cdc_datasets.R`. It appends the three Lyme periods to `data/lyme_line_list.csv` and adds a `Surveillance_Period` column to preserve each row's source era. The separate BEAM and BRFSS exports can be refreshed with `Rscript R/download_beam_dashboard.R` and `Rscript R/download_brfss_prevalence.R`.

