dataset_url <- "https://data.cdc.gov/api/views/dttw-5yxu/rows.csv?accessType=DOWNLOAD"
output_path <- file.path("data", "brfss_prevalence.csv")

dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)

download.file(
  url = dataset_url,
  destfile = output_path,
  method = "libcurl",
  mode = "wb"
)

message("Downloaded CDC BRFSS prevalence data to ", output_path)