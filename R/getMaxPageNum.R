#' Get Max Page Number
#'
#' @param turl is target url include sid1, sid2, date like below.
#'             'http://news.naver.com/main/list.nhn?sid2=265&sid1=100&mid=shm&mode=LS2D&date=20161102'
#' @param max is also interval to try max page number is numeric. Default is 100.
#' @param search if TRUE, get max page number in news search page ordered date.
#' @return Get numeric
#' @export
#' @import xml2
#' @import rvest

getMaxPageNum <- function(turl=url, max=100, search=F) {

  if(!search){
    ifmaxUrl <- paste0(turl,"&page=",max)
    tem <- read_html(ifmaxUrl)
    noContent <- tem %>% html_node("div.no_content")
    if (class(noContent)=="xml_node"){
      return("no result")
    }
    ifmax <- tem %>% html_node("a.next")
    while(class(ifmax)=="xml_node"){
      max <- max + max
      ifmaxUrl <- paste0(turl,"&page=",max)
      tem <- read_html(ifmaxUrl)
      ifmax <- tem %>% html_node("a.next")
    }
    maxPageNum<-tem %>% html_node("div.paging strong") %>% html_text %>% as.numeric
    return(maxPageNum)
  }
  if(search){

    maxnumstring <-
      read_html(turl) %>%
      html_nodes("div.section_head div.title_desc span") %>%
      html_text

    maxnumstring<-strsplit(maxnumstring,"/")[[1]][2]
    maxnumstring<-gsub("[^0-9]","",maxnumstring)
    maxnumstring<-as.numeric(maxnumstring)

    if(maxnumstring>4000){
      print("naver search page return max 4000 results. please set date range.")
      return(400)
    }

    if(maxnumstring%%10==0){
      ifmaxUrl<-paste0(turl,"&start=",maxnumstring)
    } else {
      ifmaxUrl<-paste0(turl,"&start=",maxnumstring%/%10*10+1)
    }
    tem <- read_html(ifmaxUrl)
    maxPageNum<-tem %>% html_node("div.paging strong") %>% html_text %>% as.numeric
    return(maxPageNum)
  }
}

