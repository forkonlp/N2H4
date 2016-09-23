#' Get naver news titles and links from target url.
#'
#' @param url is target url naver news.
#' @return Get data.frame(news_title, news_links).
#' @export
#' @import stringi

url<-"http://news.naver.com/main/list.nhn?sid2=260&sid1=101&mid=shm&mode=LS2D&date=20110422&page=11"

getUrlListByCategory <- function(url = url) {

    tem <- read_html(url)
    news_title <- tem %>% rvest::html_nodes("dt a") %>% rvest::html_text()
    Encoding(news_title) <- "UTF-8"
    rm_target <- tem %>% rvest::html_nodes("dt.photo a") %>% rvest::html_text()
    Encoding(rm_target) <- "UTF-8"
    news_links <- tem %>% rvest::html_nodes("dt a") %>% rvest::html_attr("href")

    news_lists <- data.frame(news_title = news_title, news_links = news_links, stringsAsFactors = F)

    news_lists$news_title <- stri_trim_both(news_lists$news_title)
    news_lists <- news_lists[nchar(news_lists$news_title) > 0,]

    rm_target <- stri_trim_both(rm_target)
    rm_target <- rm_target[nchar(rm_target) > 0]

    if (!identical(paste0(rm_target, collapse = " "), "")) {
      news_lists <- news_lists[-grep(rm_target[1], news_lists$news_title),]
    }

    return(news_lists)

}
