PeakErrorChrom <- function
### Assume p and r come from the same chromosome.
(p,
### data.frame of peaks.
 r
### data.frame of regions.
 ){
  p <- p[order(p$chromStart), ]
  r <- r[order(r$chromStart), ]
  if(is.null(r$annotation)){
    stop("need annotation column in regions")
  }
  ann2code <- c(noPeaks=0, peakStart=1, peakEnd=2, peaks=3)
  code <- ann2code[as.character(r$annotation)]
  unknown <- r$annotation[is.na(code)]
  if(length(unknown)){
    u <- paste(unique(unknown), collapse=", ")
    stop("unknown annotation (", u,
         ") annotations must be one of: ",
         paste(names(ann2code), collapse=", "))
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
  err <- with(result, {
    data.frame(chromStart, chromEnd, annotation=r$annotation,
               tp, possible.tp, fp, possible.fp)
  })
  err$fp.status <- ifelse(err$fp, "false positive", "correct")
  err$fn <- with(err, possible.tp-tp)
  err$fn.status <- ifelse(err$fn, "false negative", "correct")
  err$status <- with(err, ifelse(fn, "false negative",
                                 ifelse(fp, "false positive", "correct")))
  err
### data.frame of error.
}

PeakError <- structure(function
### Compute true and false positive peak calls, with respect to a
### database of annotated regions.
(peaks,
### data.frame with columns chrom, chromStart, chromEnd.
 regions
### data.frame with columns chrom, chromStart, chromEnd, annotation.
 ){
  stopifnot(is.data.frame(peaks))
  stopifnot(is.data.frame(regions))
  peak.list <- split(peaks, peaks$chrom)
  region.list <- split(regions, regions$chrom, drop=TRUE)
  error.list <- list()
  for(chrom in names(region.list)){
    p <- peak.list[[chrom]]
    if(is.null(p)){
      p <- data.frame(chromStart=integer(), chromEnd=integer())
    }
    r <- region.list[[chrom]]
    result <- PeakErrorChrom(p, r)
    error.list[[chrom]] <- data.frame(chrom, result)
  }
  err <- do.call(rbind, error.list)
  rownames(err) <- NULL
  err
### data.frame for each region with additional counts of true
### positives (tp, possible.tp), false positives (fp, possible.fp,
### fp.status), and false negatives (fn, fn.status).
}, ex=function(){
  x <- seq(5, 85, by=5)
  peaks <- rbind(Peaks("chr2", x, x+3),
                 Peaks("chr3", c(25, 38, 57), c(33, 54, 75)),
                 Peaks("chr4", c(5, 32, 38, 65), c(15, 35, 55, 85)),
                 Peaks("chr5", c(12, 26, 56, 75), c(16, 54, 59, 85)))
  regions <- NULL
  for(chr in 1:5){
    regions <- rbind(regions, {
      data.frame(chrom=paste0("chr", chr),
                 chromStart=c(10, 30, 50, 70),
                 chromEnd=c(20, 40, 60, 80),
                 annotation=c("noPeaks", "peakStart", "peakEnd", "peaks"))
    })
  }
  err <- PeakError(peaks, regions)
  ann.colors <-
    c(noPeaks="#f6f4bf",
      peakStart="#ffafaf",
      peakEnd="#ff4c4c",
      peaks="#a445ee")
  library(ggplot2)
  ggplot()+
    geom_rect(aes(xmin=chromStart-1/2, xmax=chromEnd-1/2,
                  ymin=-1, ymax=1,
                  fill=annotation,
                  linetype=fn.status,
                  size=fp.status),
              data=err, color="black")+
    scale_y_continuous("", breaks=NULL)+
    scale_linetype_manual(values=c("false negative"="dotted", correct="solid"))+
    scale_size_manual(values=c("false positive"=3, correct=1))+
    scale_fill_manual(values=ann.colors, breaks=names(ann.colors))+
    facet_grid(chrom ~ .)+
    theme_bw()+
    guides(fill=guide_legend(order=1),
           linetype=guide_legend(order=2, override.aes=list(fill="white")),
           size=guide_legend(order=3, override.aes=list(fill="white")))+
    theme(panel.margin=grid::unit(0, "cm"))+
    geom_segment(aes(chromStart-1/2, 0, xend=chromEnd-1/2, yend=0),
                 data=peaks, color="deepskyblue", size=2)+
    xlab("position on chromosome")
})

