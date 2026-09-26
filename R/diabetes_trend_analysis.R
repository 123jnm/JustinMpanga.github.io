# Diabetes trend analysis in R
# -----------------------------
# This script turns the CDC diabetes indicator extract into a reproducible
# public-health trend report. It uses base R only so it runs on a fresh R
# installation without requiring tidyverse or other package downloads.

input_path <- file.path('data', 'diabetes_indicators.csv')
output_dir <- 'outputs'
dir.create(output_dir, showWarnings = FALSE)

parse_numeric <- function(values) {
  suppressWarnings(as.numeric(gsub('[^0-9.-]', '', as.character(values))))
}

diabetes <- read.csv(input_path, check.names = FALSE, stringsAsFactors = FALSE)
diabetes$Year <- as.integer(diabetes$Year)
diabetes$Estimate <- parse_numeric(diabetes$Estimate)
diabetes$`Lower Limit` <- parse_numeric(diabetes$`Lower Limit`)
diabetes$`Upper Limit` <- parse_numeric(diabetes$`Upper Limit`)
diabetes <- diabetes[!is.na(diabetes$Year) & !is.na(diabetes$Estimate), ]

# Filter to one comparable measure before calculating trends. Combining
# percentages, counts, and rates would create a misleading time series.
diagnosed <- diabetes[
  grepl('Diagnosed Diabetes', diabetes$Indicator, ignore.case = TRUE) &
    diabetes$Unit == 'Percentage',
]

national <- diagnosed[
  diagnosed$Population == 'All Ages' &
    diagnosed$Age %in% c('Age-Adjusted', 'Crude') &
    diagnosed$Race == 'All' & diagnosed$Sex == 'All' &
    diagnosed$Education == 'All',
]
if (nrow(national) == 0) {
  stop('No national diagnosed-diabetes rows were found; inspect the dataset labels.')
}

# Prefer age-adjusted estimates for a fair time comparison. Fall back to crude
# values only when an age-adjusted estimate is unavailable for a year.
national$age_priority <- ifelse(national$Age == 'Age-Adjusted', 0, 1)
national <- national[order(national$Year, national$age_priority), ]
national <- national[!duplicated(national$Year), ]
national <- national[order(national$Year), ]
national$annual_change <- c(NA, diff(national$Estimate))
national$percent_change <- c(NA, 100 * diff(national$Estimate) /
  head(national$Estimate, -1))
names(national)[names(national) == 'Lower Limit'] <- 'Lower_Limit'
names(national)[names(national) == 'Upper Limit'] <- 'Upper_Limit'

write.csv(national, file.path(output_dir, 'national_diabetes_trend.csv'),
          row.names = FALSE)

png(file.path(output_dir, 'diabetes_trend.png'), width = 1600, height = 800, res = 160)
plot(national$Year, national$Estimate, type = 'n',
     main = 'Diagnosed diabetes percentage over time',
     sub = 'CDC United States Diabetes Surveillance System',
     xlab = 'Year', ylab = 'Estimated percentage')
polygon(c(national$Year, rev(national$Year)),
        c(national$Lower_Limit, rev(national$Upper_Limit)),
        col = adjustcolor('#f28f3b', alpha.f = 0.18), border = NA)
lines(national$Year, national$Estimate, col = '#2d6a4f', lwd = 3)
points(national$Year, national$Estimate, col = '#2d6a4f', pch = 19)
dev.off()

# Recent cross-sectional comparison. This is descriptive, not causal: strata
# may differ in age composition, access, and measurement quality.
latest_year <- max(diagnosed$Year, na.rm = TRUE)
latest <- diagnosed[
  diagnosed$Year == latest_year & diagnosed$Population == 'All Ages',
]
latest$stratum <- paste(latest$Age, latest$Race, latest$Sex,
                        latest$Education, sep = ' | ')
latest <- latest[order(-latest$Estimate), ]
latest <- latest[!duplicated(paste(latest$stratum, latest$Estimate)), ]
latest <- head(latest, 20)
names(latest)[names(latest) == 'Lower Limit'] <- 'Lower_Limit'
names(latest)[names(latest) == 'Upper Limit'] <- 'Upper_Limit'

write.csv(latest, file.path(output_dir, 'latest_high_burden_strata.csv'),
          row.names = FALSE)
print(tail(national, 10))
print(latest[, c('stratum', 'Estimate', 'Lower_Limit', 'Upper_Limit')])
