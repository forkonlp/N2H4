#' Get Url List By Query
#'
#' Get naver news(only not other sites links) titles(are just "dummy" now) and links from target url.
#'
#' @param url is target url naver news.
#' @return Get data.frame(news_title, news_links).
#' @export
#' @import stringr


getUrlListByQuery <- function(url = url) {

    tem <- read_html(url)
    news_title <- "dummy"

    news_links <- tem %>% rvest::html_nodes("a.go_naver") %>% rvest::html_attr("href")
    news_links <- unique(news_links)

    if (identical(news_links, character(0))) {
        news_links <- "no naver news"
    }

    news_lists <- data.frame(news_title = news_title, news_links = news_links, stringsAsFactors = F)
    return(news_lists)

}
