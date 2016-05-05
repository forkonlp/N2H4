#' Get naver news sub_category names and urls recently.
#'
#' No pram needed.
#' Main category urls are written manually like blow.
#' cate_code<-c(100,101,102,103,104,105)
#'
#' @return Get data.frame(cate_name, cate_url).
#' @export
#' @import xml2
#' @import rvest

getCategoryUrl<-function(){

  home <- "http://news.naver.com/"
  tem <- readLines(home,warn=F)
  tem <- tem[grep("class=\"m[2-8] nclick",tem)]
  cate_names<-xml2::read_html(paste0(tem,collapse=" ")) %>%
    rvest::html_nodes("a") %>%
    rvest::html_text()
  Encoding(cate_names)<-"UTF-8"
  cate_code<-data.frame(cate_name=cate_names,code=c(100,101,102,103,104,105))
  url  <- "http://news.naver.com/main/main.nhn?mode=LSD&mid=shm&sid1="
  urls <- data.frame(cate_name=NA,cate_sub=NA,cate_url=NA)
  urls <- urls[-1,]
  for (code in 1:nrow(cate_code)){

    category_url<-paste0(url,cate_code[code,2])
    tem <- readLines(category_url,warn=F)
    tem <- tem[grep("class=\"snb_s",tem)]
    if(!identical(grep("snb_s17",tem),integer(0))){
      tem <- tem[-grep("snb_s17",tem)]
    }
    tem <- tem[-length(tem)]
    cate_names<-xml2::read_html(paste0(tem,collapse=" ")) %>%
      rvest::html_nodes("a") %>%
      rvest::html_text()
    Encoding(cate_names)<-"UTF-8"
    cate_urls<-xml2::read_html(paste0(tem,collapse=" ")) %>%
      rvest::html_nodes("a") %>%
      rvest::html_attr("href")

    urls<-rbind(urls,data.frame(cate_name=cate_code[code,1],cate_sub=cate_names,cate_url=cate_urls))
  }
  return(urls)
}

