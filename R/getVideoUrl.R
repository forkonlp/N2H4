#' Get video clip download url in news
#'
#' Get naver news video url
#'
#' @param turl like <https://news.naver.com/main/read.nhn?mode=LSD&mid=shm&sid1=100&oid=056&aid=0010335895>.
#' @return Get character url.
#' @export
#' @examples
#'  \donttest{
#'   print(video_url_ex)
#'   getVideoUrl(video_url_ex)
#'   }

getVideoUrl <- function(turl = url) {

  ulist <- getVideoInfo(turl)
  tarv <- ulist$videos$list[[1]]$source
  return(tarv)

}

getVideoSubtitleUrl <- function(turl = url) {

  ulist <- getVideoInfo(turl)
  tars <- ulist$captions$list[[1]]$source
  return(tars)

}

# getVideoSubtitleUrl("https://news.naver.com/main/read.nhn?mode=LSD&mid=tvh&oid=052&aid=0001385191&sid1=293") %>%
#   GET() %>%
#   content() %>%
#   rawToChar() %>%
#   {Encoding(.)<-"UTF-8";.}

#' @importFrom rvest html_nodes html_attr html_text
#' @importFrom httr GET content add_headers user_agent
getVideoInfo <- function(turl = url){
  uat <-
    httr::user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>")
  src <- httr::GET(turl, uat)
  src <- httr::content(src)
  src <- rvest::html_nodes(src, "iframe")
  src <- rvest::html_attr(src, "_src")
  src <- src[!is.na(src)]

  tar <- paste0("http://news.naver.com", src)
  turl <- "http://news.naver.com/"
  tem <- httr::GET(tar, uat, httr::add_headers(Referer = turl))
  tem <- httr::content(tem, "parsed")
  src <- rvest::html_nodes(tem, "script")
  src <- rvest::html_text(src)
  src <- src[nchar(src) > 0]

  cod <- strsplit(x = src, split = "'")
  bky <- cod[[1]][4]
  key <- cod[[1]][8]

  url   <-
    paste0("http://play.rmcnmv.naver.com/vod/play/v2.0/",
           bky,
           "?key=",
           key)
  tem   <- httr::GET(url, uat)
  ulist <- httr::content(tem, "parsed")
  return(ulist)
}
