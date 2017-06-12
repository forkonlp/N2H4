#' Get Query news trend by date.
#'
#' Get number of query volume in naver news. Params depend on getQueryUrl function.
#'
#' @param query requred.
#' @param startDate requred form YYYY-MM-DD.
#' @param endDate requred form YYYY-MM-DD.
#' @param onlyPaper Default is False means all count of internet news.
#' @param ... depend on getQueryUrl function.
#' @return Get data.frame(date, cnt).
#' @export
#' @import xml2
#' @import rvest
#' @import stringr

getNewsTrend <- function(query, startDate, endDate, onlyPaper=FALSE, ...){
  if (onlyPaper==F){stPaper<-""}
  if (onlyPaper==T){stPaper<-"exist:1"}
  result <- c()
  tdate <- as.Date(as.Date(startDate):as.Date(endDate),origin="1970-01-01")
  turl <- getQueryUrl(query, startDate=tdate,endDate=tdate,stPaper=stPaper, ...)
  result$date<-tdate
  result$cnt<-sapply(turl, function(x) str_trim(html_text(html_nodes(read_html(x),"span.result_num"))))
  names(result$cnt)<-NULL
  result$cnt<-sapply(result$cnt, function(x) ifelse(identical(x,character(0)),"/0",x) )
  tem<-strsplit(result$cnt,"/")
  result$cnt <- sapply(tem, function(x) x[2])
  result$cnt <- as.numeric(gsub("[^0-9]","",result$cnt))
  result<-as.data.frame(result)
  return(result)
}
