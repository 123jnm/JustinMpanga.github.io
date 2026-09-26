data_dir <- "data"
dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)

dataset_ids <- c(
  claims_reimbursement = "rksx-33p3",
  covid_excess_deaths = "xkkf-xrst",
  diabetes_indicators = "c9xs-vhst"
)

download_dataset <- function(dataset_id, output_path) {
  dataset_url <- sprintf(
    "https://data.cdc.gov/api/views/%s/rows.csv?accessType=DOWNLOAD",
    dataset_id
  )
  download.file(
    url = dataset_url,
    destfile = output_path,
    method = "libcurl",
    mode = "wb"
  )
}

for (dataset_name in names(dataset_ids)) {
  download_dataset(
    dataset_ids[[dataset_name]],
    file.path(data_dir, paste0(dataset_name, ".csv"))
  )
}

lyme_sources <- c(
  "1992-2007" = "e2a5-s9pr",
  "2008-2021" = "abzs-b3gw",
  "2022-2023" = "9mtj-y2ba"
)

lyme_tables <- lapply(names(lyme_sources), function(period) {
  source_path <- file.path(data_dir, paste0("lyme_", gsub("-", "_", period), ".csv"))
  download_dataset(lyme_sources[[period]], source_path)
  data <- read.csv(source_path, check.names = FALSE, stringsAsFactors = FALSE)
  names(data) <- trimws(names(data))
  data$Surveillance_Period <- period
  data
})

expected_columns <- names(lyme_tables[[1]])
if (!all(vapply(lyme_tables, function(data) {
  setequal(names(data), expected_columns)
}, logical(1)))) {
  stop("CDC Lyme source schemas do not match; refusing to combine them.")
}

lyme_tables <- lapply(lyme_tables, function(data) {
  data[, expected_columns, drop = FALSE]
})
lyme_combined <- do.call(rbind, lyme_tables)
write.csv(
  lyme_combined,
  file.path(data_dir, "lyme_line_list.csv"),
  row.names = FALSE,
  na = ""
)

message("Downloaded CDC datasets and combined ", nrow(lyme_combined), " Lyme records.")