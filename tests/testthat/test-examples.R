context("Examples")

## chr1 has 249250621 bases -- we should test if we can compute near
## this limit.
expect_tp_fp <- function(regions, peaks, tp, fp){
  err <- PeakError(peaks, regions)
  expect_equal(err$tp, tp)
  expect_equal(err$fp, fp)
  big <- 249250000L
  peaks$chromStart <- peaks$chromStart + big
  peaks$chromEnd <- peaks$chromEnd + big
  regions$chromEnd <- regions$chromEnd + big
  regions$chromStart <- regions$chromStart + big
  err <- PeakError(peaks, regions)
  expect_equal(err$tp, tp)
  expect_equal(err$fp, fp)
}

test_that("1 peakStart region examples correct", {
  regions <-
    data.frame(chrom="chr5", chromStart=10, chromEnd=20, annotation="peakStart")
  expect_tp_fp(regions, Peaks("chr5", 15, 25), 1, 0)
  expect_tp_fp(regions, Peaks(), 0, 0)
  expect_tp_fp(regions, Peaks("chr5", 20, 30), 0, 0)
  expect_tp_fp(regions, Peaks("chr12", 12, 15), 0, 0)
  expect_tp_fp(regions, Peaks("chr5", 12, 15), 1, 0)
  expect_tp_fp(regions, Peaks("chr5", c(12, 18), c(15, 25)), 1, 1)
  expect_tp_fp(regions, Peaks("chr5", c(5, 15), c(12, 18)), 1, 1)
  expect_tp_fp(regions, Peaks("chr5", 5, 12), 0, 1)
  expect_tp_fp(regions, Peaks("chr5", 5, 25), 0, 1)
})

test_that("1 peakEnd region examples correct", {
  regions <-
    data.frame(chrom="chr5", chromStart=10, chromEnd=20, annotation="peakEnd")
  expect_tp_fp(regions, Peaks("chr5", 15, 25), 0, 1)
  expect_tp_fp(regions, Peaks(), 0, 0)
  expect_tp_fp(regions, Peaks("chr5", 20, 30), 0, 0)
  expect_tp_fp(regions, Peaks("chr12", 12, 15), 0, 0)
  expect_tp_fp(regions, Peaks("chr5", 12, 15), 1, 0)
  expect_tp_fp(regions, Peaks("chr5", c(12, 18), c(15, 25)), 1, 1)
  expect_tp_fp(regions, Peaks("chr5", c(5, 15), c(12, 18)), 1, 1)
  expect_tp_fp(regions, Peaks("chr5", 5, 12), 1, 0)
  expect_tp_fp(regions, Peaks("chr5", 5, 25), 0, 1)
})

test_that("1 noPeaks region examples correct", {
  regions <-
    data.frame(chrom="chr5", chromStart=10, chromEnd=20, annotation="noPeaks")
  expect_tp_fp(regions, Peaks("chr5", 15, 25), 0, 1)
  expect_tp_fp(regions, Peaks(), 0, 0)
  expect_tp_fp(regions, Peaks("chr5", 20, 30), 0, 0)
  expect_tp_fp(regions, Peaks("chr12", 12, 15), 0, 0)
  expect_tp_fp(regions, Peaks("chr5", 12, 15), 0, 1)
  expect_tp_fp(regions, Peaks("chr5", c(12, 18), c(15, 25)), 0, 1)
  expect_tp_fp(regions, Peaks("chr5", c(5, 15), c(12, 18)), 0, 1)
  expect_tp_fp(regions, Peaks("chr5", 5, 12), 0, 1)
  expect_tp_fp(regions, Peaks("chr5", 5, 25), 0, 1)
})
