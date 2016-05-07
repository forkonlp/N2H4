#' Get naver news urls from category.
#'
#' There are 6 categories in never news.
#' 1: Politics, 2: Economics, 3: Social, 4: Living / Culture, 5: World, 6: IT / science
#'
#' @param select is target categories. Default is all
#' @param targetDate is one date to get news like "2016-01-01". Default date is yesterday.
#' @return Get data.frame(cate_name, cate_sub, cate_url, last_page_num).
#' @export
#' @import lubridate

setUrlByCategory <- function(select=select,targetDate=today()-1){

  targetDate <- gsub("-","",as.character(targetDate))
  urls <- getCategoryUrl(select=select)
  urls[,3] <- paste0("http://news.naver.com",urls[,3],"&date=",targetDate)
  return(urls)

}

#' Get naver news urls from query.
#'
#' @param query is target keyword.
#' @param targetDate is one date to get news like "2016-01-01". Default date is yesterday.
#' @return Get data.frame(cate_name, cate_sub, cate_url, last_page_num).
#' @export
#' @import lubridate
#' @import RCurl

setUrlQuery <- function(query="",targetDate=today()-1){

  url   <- "http://news.naver.com/main/search/search.nhn?query="
  query <- curlEscape(query)
  url <-paste0(url,query,"&startDate=",targetDate,"&endDate=",targetDate)
  return(url)

}

