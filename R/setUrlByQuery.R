#' Set Url By Query
#'
#' Get naver news urls from query.
#'
#' @param query is target keyword.
#' @param targetDate is one date to get news like '2016-01-01'. Default date is yesterday.
#' @param pageNum is one page number to get news like '1'. Default number is 1.
#' @return Get data.frame(query_name, query_for_url, query_url).
#' @export
#' @import RCurl

setUrlByQuery <- function(query = "", targetDate = as.Date("2016-01-01"),  pageNum=1) {

    base_url <- "http://news.naver.com/main/search/search.nhn?query="
    query_for_url <- RCurl::curlEscape(query)
    targetDate <- gsub("-", "", as.character(targetDate))
    urls <- data.frame(query_name = query, query_for_url = query_for_url, query_url = paste0(base_url, query_for_url, "&startDate=", targetDate, "&endDate=", targetDate, "&page=",pageNum),
        stringsAsFactors = F)
    return(urls)

}
