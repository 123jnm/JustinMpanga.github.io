# This is the top-serotype export, not the discontinued HHS-region extract.
dataset_url <- "https://data.cdc.gov/api/views/ch83-ush6/rows.csv?accessType=DOWNLOAD"
output_path <- file.path("data", "beam_top_30_serotypes.csv")

# Keep the downloaded source in the local staging directory.
dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)

download.file(
  url = dataset_url,
  destfile = output_path,
  method = "libcurl",
  mode = "wb"
)

message("Downloaded CDC BEAM top 30 serotypes data to ", output_path)