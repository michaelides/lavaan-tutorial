# -----------------------------------------------------------------------------
# data-raw/build-csv-mirror.R
#
# One-off script regenerating the CSV mirror of the SPSS teaching dataset
# ps_data_reduced.sav. Re-run only when the SPSS source changes.
#
# Per Q5a-i we ship BOTH the .sav (native SPSS, what students will have) and
# a .csv (for students who cannot open .sav outside SPSS).
#
# Run from the project root:  Rscript data-raw/build-csv-mirror.R
# -----------------------------------------------------------------------------

suppressPackageStartupMessages({
  library(haven)
})

# Resolve paths relative to the project root (this script lives in data-raw/).
# `Rscript data-raw/build-csv-mirror.R` from root sets getwd() == root.
project_root <- tryCatch(
  normalizePath(getwd()),
  error = function(e) normalizePath(".")
)
sav_path <- file.path(project_root, "data", "ps_data_reduced.sav")
csv_path <- file.path(project_root, "data", "ps_data_reduced.csv")

stopifnot(file.exists(sav_path))

message("Reading: ", sav_path)
ps <- haven::read_sav(sav_path)

# haven reads SPSS user-missing codes as `NA` natively (no extra step needed).
# Convert to a plain data.frame so subsequent base-R code is straightforward.
ps <- as.data.frame(ps)

# Strip haven label attributes (labelled doubles are noisy in CSV re-importers
# such as base::read.csv()).
for (col in names(ps)) {
  attr(ps[[col]], "labels") <- NULL
  attr(ps[[col]], "label")  <- NULL
}

message("Writing: ", csv_path)
write.csv(ps, csv_path, row.names = FALSE)

message("\nDone. dim = ", paste(dim(ps), collapse = " x "),
        " (", nrow(ps), " rows, ", ncol(ps), " columns)")
