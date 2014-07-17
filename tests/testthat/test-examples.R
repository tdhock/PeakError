context("Examples")

test_that("1 peakStart region examples correct", {
  chrom <- "chr5"
  regions <-
    data.frame(chrom, chromStart=10, chromEnd=20, annotation="peakStart")
  expect_tp_fp <- function(peaks, tp, fp){
    err <- PeakError(peaks, regions)
    expect_equal(err$tp, tp)
    expect_equal(err$fp, fp)
  }
  expect_tp_fp(Peaks(chrom, 15, 25), 1, 0)
  expect_tp_fp(Peaks(), 0, 0)
  expect_tp_fp(Peaks(chrom, 12, 15), 1, 0)
  expect_tp_fp(Peaks(chrom, c(12, 18), c(15, 25)), 1, 1)
  expect_tp_fp(Peaks(chrom, c(5, 15), c(12, 18)), 1, 1)
  expect_tp_fp(Peaks(chrom, 5, 12), 0, 1)
  expect_tp_fp(Peaks(chrom, 5, 25), 0, 1)
})
