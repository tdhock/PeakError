Peaks <- function
### Represent a data.frame that represents a list of peaks.
(chrom=factor(),
### character or factor with chrom name for example "chr22"
 chromStart=integer(),
### numeric, first base of peak.
 chromEnd=integer()
### numeric, base after peak.
 ){
  if(is.character(chrom)){
    chrom <- as.factor(chrom)
  }
  stopifnot(is.factor(chrom))
  stopifnot(is.numeric(chromStart))
  stopifnot(is.numeric(chromEnd))
  data.frame(chrom,
             chromStart=as.integer(chromStart),
             chromEnd=as.integer(chromEnd))
### data.frame with columns chrom, chromStart, chromEnd.
}
