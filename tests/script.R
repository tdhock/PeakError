## I initially tried writing these tests using testthat, but I got
## errors when using the system() and system2() functions (bug in
## testthat).
compute_error.R <- system.file(
  "exec", "compute_error.R",
  mustWork=TRUE,
  package="PeakError")
Rscript <- R.home(file.path("bin", "Rscript"))
exampleData <- system.file("exampleData", package="PeakError", mustWork=TRUE)
peaks.bed <- file.path(exampleData, "peaks.bed")
labels.bed <- file.path(exampleData, "labels.bed")
overlapping.bed <- file.path(exampleData, "overlapping_peaks.bed")

##test_that("compute_error.R correct", {
out.file <- tempfile()
cmd <- paste(Rscript, compute_error.R, peaks.bed, labels.bed, ">", out.file)
status <- system(cmd)
errors <- read.table(out.file, sep="\t", header=TRUE)
stopifnot(all.equal(
  errors$tp,
  c(0, 0, 0, 0,
    0, 1, 1, 1,
    0, 1, 1, 1,
    0, 1, 1, 1,
    0, 0, 1, 1)))
stopifnot(all.equal(
  errors$fp,
  c(0, 0, 0, 0,
    1, 1, 1, 0,
    0, 0, 0, 0,
    1, 1, 0, 0,
    1, 0, 1, 0)))

## summarize_error.R script
summarize_error.R <- system.file(
  "exec", "summarize_error.R",
  mustWork=TRUE,
  package="PeakError")
cmd <- paste(Rscript, summarize_error.R, out.file)
out.vec <- system(cmd, intern=TRUE)
out.txt <- paste(out.vec, collapse="\n")
stopifnot(grepl("incorrect labels", out.txt))
stopifnot(grepl("false positive rate", out.txt))
stopifnot(grepl("false negative rate", out.txt))

##test_that("overlapping_peaks.bed shows error", {
arg.vec <- paste(compute_error.R, overlapping.bed, labels.bed)
out.vec <- system2(Rscript, arg.vec, stderr=TRUE)
out.txt <- paste(out.vec, collapse="\n")
stopifnot(grepl("overlapping peaks", out.txt))
