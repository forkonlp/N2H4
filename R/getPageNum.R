getPageNum <- function(url){

  tem     <- readLines(url,warn=F)
  getNext <- xml2::read_html(paste0(tem,collapse=" ")) %>%
    rvest::html_nodes("a.next") %>%
    rvest::html_attr("href")
  while(!identical(getNext,character(0))){
    url<-paste0("http://news.naver.com/main/list.nhn",getNext)
    tem     <- readLines(url,warn=F)
    getNext <- xml2::read_html(paste0(tem,collapse=" ")) %>%
      rvest::html_nodes("a.next") %>%
      rvest::html_attr("href")
  }

  tem <- readLines(url,warn=F)
  tem <- tem[grep("page=",tem)]
  tem <- tem[length(tem)]
  pageNum <- xml2::read_html(paste0(tem,collapse=" ")) %>%
    rvest::html_nodes("a") %>%
    rvest::html_text()
  pageNum <- as.numeric(pageNum)
  return(pageNum)
}
