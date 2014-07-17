\name{PeakError}
\alias{PeakError}
\title{PeakError}
\description{Compute true and false positive peak calls, with respect to a
database of annotated regions.}
\usage{PeakError(peaks, regions)}
\arguments{
  \item{peaks}{data.frame with columns chrom, chromStart, chromEnd.}
  \item{regions}{data.frame with columns chrom, chromStart, chromEnd, annotation.}
}

\value{data.frame for each region with additional counts of true
positives (tp, possible.tp), false positives (fp, possible.fp,
fp.status), and false negatives (fn, fn.status).}

\author{Toby Dylan Hocking}




\examples{
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
}
