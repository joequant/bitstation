#!/bin/bash
# Setup and configure website to use giving configuration

set -v
echo "Running r installation"

export PATH=/usr/lib64/R/bin:/usr/lib/R/bin:$PATH
source $rootfsDir/tmp/proxy.sh

echo "Generating new modules"
R -e "install.packages(c('stringi', 'magrittr', 'devtools', 'crayon', 'pbdZMQ', 'reticulate', 'shiny', 'Quandl','knitr', 'rzmq', 'rmarkdown', 'IRkernel', 'formatR', 'styler'), repos='http://cran.r-project.org/', dependencies=TRUE)"
#/usr/bin/R -e 'options(repos=c(CRAN = "http://cran.r-project.org/")); library(devtools) ; devtools::install_github("rstudio/rmarkdown")'
#/usr/bin/R -e 'options(repos=c(CRAN = "http://cran.r-project.org/")); library(devtools) ; install_github("IRkernel/repr"); devtools::install_github("IRKernel/IRdisplay"); devtools::install_github("IRKernel/IRkernel")'

pump --shutdown
