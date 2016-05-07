#' Get naver news titles and links from target url.
#'
#' @param url is target url naver news.
#' @return Get data.frame(news_title, news_links).
#' @export
#' @import stringi


getUrlList<-function(url=url){

    tem <- read_html(url)
    news_title<-tem %>%
      rvest::html_nodes("dt a") %>%
      rvest::html_text()
    Encoding(news_title)<-"UTF-8"
    rm_target<-tem %>%
      rvest::html_nodes("dt.photo a") %>%
      rvest::html_text()
    Encoding(rm_target)<-"UTF-8"

    news_title <- stri_trim_both(news_title)
    news_title <- news_title[nchar(news_title)>0]

    rm_target <- stri_trim_both(rm_target)
    rm_target <- rm_target[nchar(rm_target)>0]

    if(!identical(paste0(rm_target,collapse=" "),character(0))){
      news_title <- news_title[-grep(rm_target[1],news_title)]
    }

    news_links <- tem %>%
      rvest::html_nodes("dt a") %>%
      rvest::html_attr("href")
    news_links <- unique(news_links)

    news_lists <- data.frame(news_title=news_title,news_links=news_links)
    return(news_lists)

}

