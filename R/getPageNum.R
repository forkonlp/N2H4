#' Get urls last page number.
#'
#' Main category urls are written manually like blow.
#' cate_code<-c(100,101,102,103,104,105)
#' @param target urls getting function getCategoryUrl()
#' @return Get page number to end
#' @export
#' @import xml2
#' @import rvest
#'
#'
getPageNum <- function(url){

  tem     <- readLines(url,warn=F)
  getNext <- xml2::read_html(paste0(tem,collapse=" ")) %>%
    rvest::html_nodes("a.next") %>%
    rvest::html_attr("href")
  while(!identical(getNext,character(0))){
    url<-paste0("http://news.naver.com/main/list.nhn",getNext)
    tem     <- readLines(url,warn=F)
    getNext <- xml2::read_html(paste0(tem,collapse=" ")) %>%
      rvest::html_nodes("a.next") %>%
      rvest::html_attr("href")
  }

  tem <- readLines(url,warn=F)
  tem <- tem[grep("page=",tem)]
  tem <- tem[length(tem)]
  pageNum <- xml2::read_html(paste0(tem,collapse=" ")) %>%
    rvest::html_nodes("a") %>%
    rvest::html_text()
  pageNum <- as.numeric(pageNum)
  return(pageNum)
}
