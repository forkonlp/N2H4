FROM rocker/tidyverse
MAINTAINER chanyub park <mrchypark@gmail.com>

RUN sudo apt-get update \
    && Rscript -e 'install.packages(c("curl","selectr"), lib ="/usr/local/lib/R/site-library")' \
    && Rscript -e 'devtools::install_github("forkonlp/N2H4")'
