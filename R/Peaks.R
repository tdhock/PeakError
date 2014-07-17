Peaks <- function(chrom=factor(), chromStart=integer(), chromEnd=integer()){
  if(is.character(chrom)){
    chrom <- as.factor(chrom)
  }
  stopifnot(is.factor(chrom))
  stopifnot(is.numeric(chromStart))
  stopifnot(is.numeric(chromEnd))
  data.frame(chrom,
             chromStart=as.integer(chromStart),
             chromEnd=as.integer(chromEnd))
}
