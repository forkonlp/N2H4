#' Get video clip download url in news
#'
#' Get naver news video url
#'
#' @param turl like 'http://news.naver.com/main/read.nhn?mode=LSD&mid=shm&sid1=100&oid=056&aid=0010335895'.
#' @return Get character url.
#' @export
#' @import selectr
#' @import rvest
#' @import httr

getVideoUrl <- function(turl = url) {

  src <- turl %>% read_html %>% html_nodes("iframe") %>% html_attr("_src")
  src <- src[!is.na(src)]

  tar <- paste0("http://news.naver.com",src)
  turl <- "http://news.naver.com/"
  tem<-GET(tar,httr::add_headers(Referer = turl))
  tem<-content(tem,"parsed")
  tem <- as.character(tem)
  src <- tem %>% read_html %>% html_nodes("script") %>% html_text
  src <- src[nchar(src)>0]

  cod<-strsplit(x = src,split = "'")
  bky <- cod[[1]][4]
  key <- cod[[1]][8]

  url   <- paste0("http://play.rmcnmv.naver.com/vod/play/v2.0/",bky,"?key=",key)
  tem   <- GET(url)
  ulist <- content(tem,"parsed")

  tarv <-ulist$videos$list[[1]]$source
  return(tarv)

}






