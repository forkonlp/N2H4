#' Get naver news content from links parallelly.
#'
#'
#' @param url is naver news links.
#' @return Get data.frame(url,datetime,press,title,content).
#' @export
#' @import rvest
#' @import doParallel
#' @import stringi
#' @import RCurl
#' @import foreach


getContentParallel <- function(url = url) {

  noNewsInfo<-c()
  rmloc<-c()
  for(i in 1:length(url))
  if (url.exists(url[i])) {

    noNewsInfo <- rbind(noNewsInfo,data.frame(url = url[i], datetime = "page is moved.", edittime = "page is moved.",
                  press = "page is moved.", title = "page is moved.", content = "page is moved.",  stringsAsFactors = F) )
    rmloc<-c(rmloc,i)
  }
  if(identical(rmloc,c())){url<-url[-rmloc]}

  cl<-parallel::makeCluster(parallel::detectCores())
  registerDoParallel(cl)

  newsInfo <- foreach(i = 1:length(url), .packages = c("rvest","stringi")) %dopar% {

    tem <- read_html(url[i])
    title <- tem %>% html_nodes("div.article_info h3") %>% html_text()
    Encoding(title) <- "UTF-8"

    datetime <- tem %>% html_nodes("span.t11") %>% html_text()
    datetime <- as.POSIXlt(datetime)

    if (length(datetime) == 1) {
      edittime <- datetime
    }
    if (length(datetime) == 2) {
      edittime <- datetime[2]
      datetime <- datetime[1]
    }

    press <- tem %>% html_nodes("div.article_header div a img") %>% html_attr("title")
    Encoding(press) <- "UTF-8"

    content <- tem %>% html_nodes("div#articleBodyContents") %>% html_text()
    Encoding(content) <- "UTF-8"
    content <- stri_trim(content)

    newsInfo <- data.frame(url = url[i], datetime = datetime, edittime = edittime, press = press, title = title, content = content, stringsAsFactors = F)
  }
  parallel::stopCluster(cl)
  newsInfo<-do.call(rbind.data.frame, newsInfo)
  newsInfo<-unique(newsInfo)
  if(identical(noNewsInfo,c())){newsInfo<-rbind(noNewsInfo,newsInfo)}
  return(newsInfo)
}
