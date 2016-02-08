#!/usr/bin/env Rscript

exampleData <- system.file("exampleData", package="PeakError")
arg.vec <- file.path(exampleData, c("peaks.bed", "labels.bed"))

arg.vec <- commandArgs(trailingOnly=TRUE)

if(length(arg.vec) != 2){
  stop("Usage: compute_error.R peaks.bed labels.bed > errors.bed")
}
peaks.bed <- arg.vec[1]
labels.bed <- arg.vec[2]

peak.classes <- c(
  chrom="character",
  chromStart="integer",
  chromEnd="integer")
peaks <- read.table(
  peaks.bed,
  colClasses=peak.classes,
  col.names=names(peak.classes))

labels.classes <- c(
  chrom="character",
  chromStart="integer",
  chromEnd="integer",
  annotation="character")
labels <- read.table(
  labels.bed,
  colClasses=labels.classes,
  col.names=names(labels.classes))

library(PeakError)
errors <- PeakError(peaks, labels)
write.table(errors, sep="\t", quote=FALSE, row.names=FALSE)
