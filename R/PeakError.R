PeakError <- structure(function
### Compute true and false positive peak calls, with respect to a
### database of annotated regions.
(peaks,
 regions
 ){
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
    unknown <- r$annotation[is.na(code)]
    if(length(unknown)){
      u <- paste(unique(unknown), collapse=", ")
      stop("unknown annotation (", u,
           ") annotations must be one of: noPeaks, peakStart, peakEnd")
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
      data.frame(chrom, chromStart, chromEnd, annotation=r$annotation,
                 tp, possible.tp, fp, possible.fp)
    })
  }
  err <- do.call(rbind, error.list)
  rownames(err) <- NULL
  err$fp.status <- ifelse(err$fp, "false positive", "correct")
  err$fn <- with(err, possible.tp-tp)
  err$fn.status <- ifelse(err$fn, "false negative", "correct")
  err
}, ex=function(){
  peaks <- rbind(Peaks("chr2", 5, 65),
                 Peaks("chr3", c(23, 38), c(26, 55)),
                 Peaks("chr4", c(32, 38), c(35, 55)),
                 Peaks("chr5", 26, 55),
                 Peaks("chr6", 38, 65))
  regions <- NULL
  for(chr in 1:6){
    regions <- rbind(regions, {
      data.frame(chrom=paste0("chr", chr),
                 chromStart=c(10, 30, 50),
                 chromEnd=c(20, 40, 60),
                 annotation=c("noPeaks", "peakStart", "peakEnd"))
    })
  }
  err <- PeakError(peaks, regions)
  ann.colors <-
    c(noPeaks="#f6f4bf",
      peakStart="#ffafaf",
      peakEnd="#ff4c4c")
  library(ggplot2)
  ggplot()+
    geom_rect(aes(xmin=chromStart-1/2, xmax=chromEnd-1/2,
                  ymin=-1, ymax=1,
                  fill=annotation,
                  size=fn.status,
                  linetype=fp.status),
              data=err, color="black")+
    scale_y_continuous("", breaks=NULL)+
    scale_linetype_manual(values=c("false positive"="dotted", correct="solid"))+
    scale_size_manual(values=c("false negative"=3, correct=1/2))+
    scale_fill_manual(values=ann.colors, breaks=names(ann.colors))+
    facet_grid(chrom ~ .)+
    theme_bw()+
    guides(fill=guide_legend(order=1),
           linetype=guide_legend(order=2, override.aes=list(fill="white")),
           size=guide_legend(order=3, override.aes=list(fill="white")))+
    theme(panel.margin=grid::unit(0, "cm"))+
    geom_segment(aes(chromStart-1/2, 0, xend=chromEnd-1/2, yend=0),
                 data=peaks, color="deepskyblue", size=2)
})
