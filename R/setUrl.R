#' Get naver news urls from category.
#'
#' There are 6 categories in never news.
#' 1: Politics, 2: Economics, 3: Social, 4: Living / Culture, 5: World, 6: IT / science
#'
#' @param select is target categories. Default is all
#' @param targetDate is one date to get news like "2016-01-01". Default date is yesterday.
#' @return Get data.frame(cate_name, cate_sub, cate_url).
#' @export
#' @import lubridate

setUrlByCategory <- function(select=c(1,2,3,4,5,6),targetDate=today()-1){

  targetDate <- gsub("-","",as.character(targetDate))
  urls <- getCategoryUrl(select=select)
  urls[,3] <- paste0("http://news.naver.com",urls[,3],"&date=",targetDate)
  return(urls)

}

#' Get naver news urls from query.
#'
#' @param query is target keyword.
#' @param targetDate is one date to get news like "2016-01-01". Default date is yesterday.
#' @return Get data.frame(query_name, query_for_url, query_url).
#' @export
#' @import lubridate
#' @import RCurl

setUrlByQuery <- function(query="",targetDate=today()-1){

  base_url   <- "http://news.naver.com/main/search/search.nhn?query="
  query_for_url  <- curlEscape(query)
  urls        <- data.frame(query_name=query,query_for_url=query_for_url,query_url=paste0(base_url,query,"&startDate=",targetDate,"&endDate=",targetDate))
  return(urls)

}

