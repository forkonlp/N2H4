FROM rocker/r-base:latest
MAINTAINER chanyub park <mrchypark@gmail.com>

RUN apt-get update \
    && apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev \
    && Rscript -e 'source("https://install-github.me/forkonlp/N2H4")'
