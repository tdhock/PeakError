context("script")

test_that("compute_error.R correct", {
  compute_error.R <- system.file("exec", "compute_error.R", package="PeakError")
  Rscript <- R.home(file.path("bin", "Rscript"))
  exampleData <- system.file("exampleData", package="PeakError")
  peaks.bed <- file.path(exampleData, "peaks.bed")
  labels.bed <- file.path(exampleData, "labels.bed")
  errors.bed <- tempfile()
  cmd <- paste(Rscript, compute_error.R, peaks.bed, labels.bed, ">", errors.bed)
  system(cmd)
  errors <- read.table(errors.bed, sep="\t", header=TRUE)
  expect_equal(errors$tp,
               c(0, 0, 0, 0,
                 0, 1, 1, 1,
                 0, 1, 1, 1,
                 0, 1, 1, 1,
                 0, 0, 1, 1))
  expect_equal(errors$fp,
               c(0, 0, 0, 0,
                 1, 1, 1, 0,
                 0, 0, 0, 0,
                 1, 1, 0, 0,
                 1, 0, 1, 0))
})
