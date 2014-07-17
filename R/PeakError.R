PeakError <- function(peaks, regions){
  peak.list <- split(peaks, peaks$chrom)
  region.list <- split(regions, regions$chrom, drop=TRUE)
  ann2code <- c(noPeaks=0, peakStart=1, peakEnd=2)
  error.list <- list()
  for(chrom in names(region.list)){
    p <- peak.list[[chrom]]
    if(is.null(p)){
      p <- data.frame(chromStart=integer(), chromEnd=integer())
    }
    p <- p[order(p$chromStart), ]
    r <- region.list[[chrom]]
    r <- r[order(r$chromStart), ]
    code <- ann2code[as.character(r$annotation)]
    if(any(is.na(code))){
      print(table(r$annotation))
      stop("annotations must be one of: noPeaks, peakStart, peakEnd")
    }
    result <- 
      .C("PeakError_interface",
         peak.chromStart=as.integer(p$chromStart),
         peak.chromEnd=as.integer(p$chromEnd),
         peak.count=as.integer(nrow(p)),
         chromStart=as.integer(r$chromStart),
         chromEnd=as.integer(r$chromEnd),
         annotation=as.integer(code),
         region.count=as.integer(nrow(r)),
         tp=integer(nrow(r)),
         fp=integer(nrow(r)),
         possible.tp=integer(nrow(r)),
         possible.fp=integer(nrow(r)),
         package="PeakError")
    error.list[[chrom]] <- with(result, {
      data.frame(chrom, chromStart, chromEnd, annotation,
                 tp, possible.tp, fp, possible.fp)
    })
  }
  err.regions <- do.call(rbind, error.list)
  rownames(err.regions) <- NULL
  err.regions
}
