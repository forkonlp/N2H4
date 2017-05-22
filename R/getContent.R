#' Get Content
#'
#' Get naver news content from links.
#'
#' @param url is naver news link.
#' @param col is what you want to get from news. Defualt is all.
#' @param async async crawling if it is TRUE. Defualt is FALSE.
#' @return Get data.frame(url,datetime,press,title,body).
#' @export
#' @import curl
#' @import RCurl
#' @import xml2
#' @import rvest
#' @import stringi

getContent <- function(url, col=c("url","datetime","press","title","body"), async=FALSE) {

  if(!identical(url,character(0))){
    if (RCurl::url.exists(url)&
       "error_msg 404"!=(read_html(url)%>%html_nodes("div#main_content div div")%>%html_attr("class"))[1]
        ) {
      urlcheck<-curl::curl_fetch_memory(url)$url
      if(!identical(grep("news.naver.com",urlcheck),integer(0))){

          html_obj <- read_html(url)
          title<-getContentTitle(html_obj)
          datetime<-getContentDatetime(html_obj)[1]
          edittime<-getContentDatetime(html_obj)[2]
          press<-getContentPress(html_obj)
          body<-getContentBody(html_obj)

          newsInfo <- data.frame(url = url, datetime = datetime, edittime = edittime, press = press, title = title, body = body, stringsAsFactors = F)

      } else {
        newsInfo <- data.frame(url = url, datetime = "page is not news section.",
                               edittime = "page is not news section.",
                               press = "page is not news section.",
                               title = "page is not news section.",
                               body = "page is not news section.",
                               stringsAsFactors = F)
      }
      return(newsInfo[,col])
    } else {

        newsInfo <- data.frame(url = url, datetime = "page is moved.",
                               edittime = "page is moved.",
                               press = "page is moved.",
                               title = "page is moved.",
                               body = "page is moved.",
            stringsAsFactors = F)

    }
    return(newsInfo[,col])
  } else { print("no news links")

    newsInfo <- data.frame(url = "no news links",
                           datetime = "no news links",
                           edittime = "no news links",
                           press = "no news links",
                           title = "no news links",
                           body = "no news links",
                           stringsAsFactors = F)
    return(newsInfo[,col])
  }
}



#' Get Content Title
#'
#' Get naver news Title from link.
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param attr if you want to get attribution text, please write down here.
#' @return Get character title.
#' @export
#' @import xml2
#' @import rvest

getContentTitle<-function(html_obj, node_info="div.article_info h3", attr=""){
  if(attr!=""){title <- html_obj %>% html_nodes(node_info) %>% html_attr(attr)}else{
  title <- html_obj %>% html_nodes(node_info) %>% html_text()}
  Encoding(title) <- "UTF-8"
  return(title)
}


#' Get Content datetime
#'
#' Get naver news published datetime from link.
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param attr if you want to get attribution text, please write down here.
#' @param getEdittime if TRUE, can get POSIXlt type datetime length 2 means published time and final edited time. if FALSE, get Date length 1.
#' @return Get POSIXlt type datetime.
#' @export
#' @import xml2
#' @import rvest

getContentDatetime<-function(html_obj, node_info="span.t11", attr="", getEdittime=TRUE){
  if(attr!=""){datetime <- html_obj %>% html_nodes(node_info) %>% html_attr(attr)}else{
    datetime <- html_obj %>% html_nodes(node_info) %>% html_text()}
  datetime <- as.POSIXlt(datetime)

  if(getEdittime){
    if (length(datetime) == 1) {
      edittime <- datetime[1]
    }
    if (length(datetime) == 2) {
      edittime <- datetime[2]
      datetime <- datetime[1]
    }
    datetime<-c(datetime,edittime)
    return(datetime)
  }
  return(datetime)
}


#' Get Content Press name.
#'
#' Get naver news press name from link.
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param attr if you want to get attribution text, please write down here. Defalt is "title".
#' @return Get character press.
#' @export
#' @import xml2
#' @import rvest

getContentPress<-function(html_obj, node_info="div.article_header div a img", attr="title"){
  if(attr!=""){press <- html_obj %>% html_nodes(node_info) %>% html_attr(attr)}else{
    press <- html_obj %>% html_nodes(node_info) %>% html_text()}
  Encoding(press) <- "UTF-8"
  return(press)
}



#' Get Content body name.
#'
#' Get naver news body from link.
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param attr if you want to get attribution text, please write down here.
#' @return Get character body content.
#' @export
#' @import xml2
#' @import rvest
#' @import stringi

getContentBody<-function(html_obj, node_info="div#articleBodyContents", attr=""){
  if(attr!=""){body <- html_obj %>% html_nodes(node_info) %>% html_attr(attr)}else{
    body <- html_obj %>% html_nodes(node_info) %>% html_text()}
  Encoding(body) <- "UTF-8"
  body <- stri_trim_both(body)
  body <- gsub("\r?\n|\r", " ", body)
  return(body)
}




#
# tem<-getUrlListByCategory("http://news.naver.com/main/list.nhn?mode=LS2D&mid=shm&sid1=101&sid2=258")
#
# pool <- new_pool()
#
# data <- list()
# success <- function(res){
#   cat("Request done! Status:", res$status, "\n")
#   res$content<-iconv(rawToChar(res$content),from="CP949",to="UTF-8")
#   data <<- c(data, list(res))
# }
# failure <- function(msg){
#   cat("Oh noes! Request failed!", msg, "\n")
# }
#
# sapply(tem$links, function(x) curl_fetch_multi(x,success,failure))
#
# multi_run()
# str(data)

