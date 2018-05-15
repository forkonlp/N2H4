#' Get Url List By Query
#'
#' Get naver news(only not other sites links) titles and links from target url.
#'
#' @param turl is target url naver news.
#' @return Get data.frame(news_title, news_links).
#' @export
#' @importFrom rvest html_nodes html_attr
#' @importFrom httr GET content user_agent

getUrlListByQuery <- function(turl = url) {
  uat <-
    httr::user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>")
  src <- httr::GET(turl, uat)
  hobj <- httr::content(src)

  news_links <-
    rvest::html_nodes(hobj, "dd.txt_inline a._sp_each_url")
  news_links <- rvest::html_attr(news_links, "href")

  # news_title <- tem %>% rvest::html_nodes("a.tit") %>% rvest::html_text()

  if (identical(news_links, character(0))) {
    news_links <- "no naver news"
  }

  # news_lists <- data.frame(news_title = news_title, news_links = news_links, stringsAsFactors = F)
  news_lists <-
    data.frame(
      news_title = "help to improve",
      news_links = news_links,
      stringsAsFactors = F
    )
  return(news_lists)

}
