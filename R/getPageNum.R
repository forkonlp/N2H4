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

getPageNum <- function(url){

  tem <- readLines(url,warn=F)
  tem <- tem[grep("a href=\"http://news.naver.com/main/read.nhn?",tem)]
  tmp <- c(1)
  pageNum <-1

  while(paste0(tem,collapse=" ")!=paste0(tmp,collapse=" ")){
    targetUrl<-paste0(url,"&page=",pageNum)
    tem <- tmp
    tmp <- readLines(targetUrl,warn=F)
    tmp <- tmp[grep("a href=\"http://news.naver.com/main/read.nhn?",tmp)]
    pageNum <- pageNum + 1
  }

  return(pageNum-1)
}
