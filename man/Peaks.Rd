\name{Peaks}
\alias{Peaks}
\title{Peaks}
\description{Make a data.frame that represents a list of peaks.}
\usage{Peaks(chrom = factor(), 
    base.before = integer(), 
    last.base = integer())}
\arguments{
  \item{chrom}{character or factor with \code{chrom} name for example "chr22"}
  \item{base.before}{integer, base before peak.}
  \item{last.base}{integer, last base of peak.}
}

\value{data.frame with columns \code{chrom}, chromStart, chromEnd.}

\author{Toby Dylan Hocking}





