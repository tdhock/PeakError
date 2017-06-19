PeakError: compute the label error rate of peak calling models

[[https://travis-ci.org/tdhock/PeakError][https://travis-ci.org/tdhock/PeakError.png?branch=master]]

After constructing a database of labels that indicate specific samples
and genomic regions with and without peaks in a ChIP-seq experiment,
you can compute the label error rate of a peak calling model using this
package. This is useful for
- training peak calling model parameters: choose the parameter values
  that minimize the number of incorrect labels.
- testing different peak calling models: compute the label error rate of two
  or more different peak models. The one with the lowest label error rate
  is the most accurate in your data.

For more details, please read our paper "Optimizing ChIP-seq peak
detectors using visual labels and supervised machine learning" by
Hocking et al,
Bioinformatics 2017. https://www.ncbi.nlm.nih.gov/pubmed/27797775

** R installation

#+BEGIN_SRC R
if(!require(devtools))install.packages("devtools")
devtools::install_github("tdhock/PeakError")
#+END_SRC

** R usage

#+BEGIN_SRC R
library(PeakError)
example(PeakError)
#+END_SRC

** Command line usage

The [[file:inst/exampleData/][exampleData]] directory contains command line scripts for computing
the PeakError for peaks and labels defined in bed files:

#+BEGIN_SRC shell-script
cd $(Rscript -e 'cat(system.file("exampleData", package="PeakError"))')
Rscript PeakError_compute.R peaks.bed labels.bed > errors.tsv
Rscript PeakError_summarize.R errors.tsv
#+END_SRC

On my system I got the following output:

#+BEGIN_SRC 
thocking@silene:~/R$ cd $(Rscript -e 'cat(system.file("exampleData", package="PeakError"))')
thocking@silene:~/lib/R/library/PeakError/exampleData$ Rscript PeakError_compute.R peaks.bed labels.bed > errors.tsv
read 28 peaks
read 20 labels
Loading required package: PeakError
computed errors for 20 labels
thocking@silene:~/lib/R/library/PeakError/exampleData$ Rscript PeakError_summarize.R errors.tsv

  noPeaks   peakEnd     peaks peakStart 
        5         5         5         5 
11 / 20 incorrect labels = 55.000000% error rate
7 false positives / 15 possible = 46.666667% false positive rate
4 false negatives / 15 possible = 26.666667% false negative rate
thocking@silene:~/lib/R/library/PeakError/exampleData$ 
#+END_SRC
