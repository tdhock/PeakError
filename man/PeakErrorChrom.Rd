\name{PeakErrorChrom}
\alias{PeakErrorChrom}
\title{PeakErrorChrom}
\description{Assume p and r come from the same chromosome.}
\usage{PeakErrorChrom(peaks, regions)}
\arguments{
  \item{peaks}{data.frame with columns chromStart, chromEnd. NOTE: chromStart
should be 0-based and chromEnd should be 1-based. EXAMPLE: the
first 100 base of of a chromosome are chromStart=0,
chromEnd=100. The second 100 bases are chromStart=100,
chromEnd=200.}
  \item{regions}{data.frame with columns chromStart, chromEnd.}
}

\value{data.frame with 1 row for each region and error columns.}

\author{Toby Dylan Hocking}





