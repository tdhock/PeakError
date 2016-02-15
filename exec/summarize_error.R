#!/usr/bin/env Rscript

exampleData <- system.file("exampleData", package="PeakError")
arg.vec <- file.path(exampleData, c("peaks.bed", "labels.bed"))

arg.vec <- commandArgs(trailingOnly=TRUE)

if(length(arg.vec) < 1){
  stop("Usage: summarize_error.R errors1.bed [...]")
}

error.list <- list()
for(errors.bed.i in seq_along(arg.vec)){
  errors.bed <- arg.vec[[errors.bed.i]]
  error.list[[errors.bed.i]] <- read.table(errors.bed, sep="\t", header=TRUE)
}
error <- do.call(rbind, error.list)
regions <- nrow(error)
fp <- sum(error$fp)
possible.fp <- sum(error$possible.fp)
fn <- sum(error$fn)
possible.fn <- sum(error$possible.tp)
errors <- fp+fn
table(error$annotation)
cat(sprintf("%d / %d incorrect labels = %f%% error rate
%d false positives / %d possible = %f%% false positive rate
%d false negatives / %d possible = %f%% false negative rate
", errors, regions, 100*errors/regions,
            fp, possible.fp, 100*fp/possible.fp,
            fn, possible.fn, 100*fn/possible.fn))
