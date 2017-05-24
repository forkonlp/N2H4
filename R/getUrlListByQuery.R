#' Get Url List By Query
#'
#' Get naver news(only not other sites links) titles and links from target url.
#'
#' @param turl is target url naver news.
#' @return Get data.frame(news_title, news_links).
#' @export
#' @import xml2
#' @import rvest

getUrlListByQuery <- function(turl = url) {

    tem <- read_html(turl)
    news_title <- tem %>% rvest::html_nodes("a.tit") %>% rvest::html_text()

    news_links <- tem %>% rvest::html_nodes("a.go_naver") %>% rvest::html_attr("href")

    if (identical(news_links, character(0))) {
        news_links <- "no naver news"
    }

    #news_lists <- data.frame(news_title = news_title, news_links = news_links, stringsAsFactors = F)
    news_lists <- data.frame(news_title = "dummy", news_links = news_links, stringsAsFactors = F)
    return(news_lists)

}
