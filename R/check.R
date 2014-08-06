### Check for a valid data.frame with chrom names.
checkChrom <- function(df){
  stopifnot(is.data.frame(df))
  stopifnot(is.factor(df$chrom) || is.character(df$chrom))
}

### Check for a valid data.frame with chromStart, chromEnd.
checkPositions <- function(df){
  stopifnot(is.data.frame(df))
  for(col.name in c("chromStart", "chromEnd")){
    x <- df[, col.name]
    stopifnot(is.numeric(x))
    stopifnot(x >= 0)
  }
  stopifnot(df$chromStart < df$chromEnd)
}
