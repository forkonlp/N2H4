% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getCategory.R
\name{getSubCategory}
\alias{getSubCategory}
\title{Get News Sub Categories}
\usage{
getSubCategory(sid1 = 100)
}
\arguments{
\item{sid1}{Main category id in naver news url. Only 1 value is passible. Default is 100 means Politics.}
}
\value{
a [tibble][tibble::tibble-package]
}
\description{
Get naver news sub category names and urls recently.
}
\examples{
\dontrun{
  getSubCategory(100)
  getSubCategory(100, FALSE)
  }
}
