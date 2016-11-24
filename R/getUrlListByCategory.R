#' Get Url List By Category
#'
#' Get naver news titless and links from target url.
#'
#' @param turl is target url naver news.
#' @param  col is what you want to get from news. Defualt is all.
#' @return Get data.frame(titles, links).
#' @export
#' @import xml2
#' @import rvest
#' @import stringr

getUrlListByCategory <- function(turl = url, col=c("titles", "links")) {

    tem <- read_html(turl)
    titles <- tem %>% rvest::html_nodes("dt a") %>% rvest::html_text()
    Encoding(titles) <- "UTF-8"
    rm_target <- tem %>% rvest::html_nodes("dt.photo a") %>% rvest::html_text()
    Encoding(rm_target) <- "UTF-8"
    links <- tem %>% rvest::html_nodes("dt a") %>% rvest::html_attr("href")

    news_lists <- data.frame(titles = titles, links = links, stringsAsFactors = F)

    news_lists$titles <- str_trim(news_lists$titles, side="both")
    news_lists <- news_lists[nchar(news_lists$titles) > 0,]

    rm_target <- str_trim(rm_target, side="both")
    rm_target <- rm_target[nchar(rm_target) > 0]

    if (!identical(paste0(rm_target, collapse = " "), "")) {
      news_lists <- news_lists[-grep(rm_target[1], news_lists$titles),]
    }

    return(news_lists[,col])

}
