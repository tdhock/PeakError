Peaks <- function
### Make a data.frame that represents a list of peaks.
(chrom=factor(),
### character or factor with chrom name for example "chr22"
 base.before=integer(),
### integer, base before peak.
 last.base=integer()
### integer, last base of peak.
 ){
  if(is.character(chrom)){
    chrom <- as.factor(chrom)
  }
  stopifnot(is.factor(chrom))
  stopifnot(is.numeric(base.before))
  stopifnot(is.numeric(last.base))
  data.frame(chrom,
             chromStart=as.integer(base.before),
             chromEnd=as.integer(last.base))
### data.frame with columns chrom, chromStart, chromEnd.
}
