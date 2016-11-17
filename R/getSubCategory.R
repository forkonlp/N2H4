#' Get News Sub Categories
#'
#' Get naver news sub category names and urls recently.
#'
#' @param sid1 Main category id in naver news url. Only 1 value is passible. Default is 100 means Politics.
#' @param onlySid2 sid2 is sub category id. some sub categories don't have id. If TRUE, functions return data.frame(chr:sub_cate_naem, char:sid2). Defaults is False.
#' @return Get data.frame(chr:sub_cate_name, chr:urls).
#' @export
#' @import xml2
#' @import rvest
#' @import stringr

getSubCategory <- function(sid1=100, onlySid2=FALSE) {

  print("This function use internet. If get error, please check the internet.")
  home <- paste0("http://news.naver.com/main/main.nhn?mode=LSD&mid=shm&sid1=",sid1)
  tem <- read_html(home)
  titles <- tem %>% html_nodes("div.snb ul.nav li a") %>% html_text()
  titles<-str_trim(titles)
  links <- tem %>% html_nodes("div.snb ul.nav li a") %>% html_attr("href")
  links <- paste0("http://news.naver.com",links)
  urls<-data.frame(sub_cate_name=titles,urls=links,stringsAsFactors = F)
  return(urls)

}


