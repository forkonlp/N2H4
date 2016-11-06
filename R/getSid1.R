#' Get Main Category
#'
#' Get naver news main category names and urls recently.
#' There are 7 categories in never news.
#' 1: Politics, 2: Economics, 3: Social, 4: Living / Culture, 5: World, 6: IT / science, 7: Opinion
#'
#' @return Get data.frame(chr:cate_name, chr:sid1).
#' @export
#' @import xml2
#' @import rvest
#' @import stringr

getSid1 <- function() {

  home <- "http://news.naver.com/"
  titles <- read_html(home) %>% html_nodes("a") %>% html_text()
  links <- read_html(home) %>% html_nodes("a") %>% html_attr("href")
  titles<-titles[grep("^\\/main\\/main.nhn\\?mode=LSD&mid=shm&sid1=1",links)]
  titles<-str_trim(titles)
  links<-links[grep("^\\/main\\/main.nhn\\?mode=LSD&mid=shm&sid1=1",links)]
  sid1<-str_sub(links,-3,-1)
  urls<-data.frame(cate_name=titles,sid1=sid1,stringsAsFactors = F)
  return(urls)

}


