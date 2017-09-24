#' Get News Main Categories
#'
#' Get naver news main category names and ids recently.
#'
#' @return Get data.frame(chr:cate_name, chr:sid1).
#' @export
#' @import xml2
#' @import rvest
#' @import stringr

getMainCategory <- function() {

  print("This function use internet. If get error, please check the internet.")
  root   <- read_html("http://news.naver.com/")
  titles <-
    root %>%
    html_nodes("div.lnb_menu ul li a") %>%
    html_text()
  links  <- root %>%
    html_nodes("div.lnb_menu ul li a") %>%
    html_attr("href")
  titles <- titles[grep("^\\/main\\/main.nhn\\?mode=LSD&mid=shm&sid1=1",links)]
  titles <- str_trim(titles)
  links  <- links[grep("^\\/main\\/main.nhn\\?mode=LSD&mid=shm&sid1=1",links)]
  sid1   <- str_sub(links,-3,-1)
  urls   <- data.frame(cate_name=titles
                       , sid1=sid1
                       , stringsAsFactors = F
                       )
  return(urls)

}


