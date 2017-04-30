#' Get Content
#'
#' Get naver news content from links.
#'
#' @param url is naver news link.
#' @param col is what you want to get from news. Defualt is all.
#' @return Get data.frame(url,datetime,press,title,content).
#' @export
#' @import RCurl
#' @import xml2
#' @import rvest
#' @import stringr

getContent <- function(url = url, col=c("url","datetime","press","title","content")) {

  if(!identical(url,character(0))){
    if (RCurl::url.exists(url)&
       "error_msg 404"!=(read_html(url)%>%html_nodes("div#main_content div div")%>%html_attr("class"))[1]
        ) {

        tem <- read_html(url)
        title <- tem %>% html_nodes("div.article_info h3") %>% html_text()
        Encoding(title) <- "UTF-8"

        datetime <- tem %>% html_nodes("span.t11") %>% html_text()
        datetime <- as.POSIXlt(datetime)

        if (length(datetime) == 1) {
            edittime <- datetime[1]
        }
        if (length(datetime) == 2) {
            edittime <- datetime[2]
            datetime <- datetime[1]
        }

        press <- tem %>% html_nodes("div.article_header div a img") %>% html_attr("title")
        Encoding(press) <- "UTF-8"

        content <- tem %>% html_nodes("div#articleBodyContents") %>% html_text()
        Encoding(content) <- "UTF-8"
        content <- str_trim(content,side="both")
        content <- gsub("\r?\n|\r", " ", content)
        content <- strsplit(content,"back\\(\\) \\{\\} ")[[1]][2]

        newsInfo <- data.frame(url = url, datetime = datetime, edittime = edittime, press = press, title = title, content = content, stringsAsFactors = F)

    } else {

        newsInfo <- data.frame(url = url, datetime = "page is moved.", edittime = "page is moved.", press = "page is moved.", title = "page is moved.", content = "page is moved.",
            stringsAsFactors = F)

    }
    return(newsInfo[,col])
  } else { print("no news links")

    newsInfo <- data.frame(url = "no news links", datetime = "no news links", edittime = "no news links", press = "no news links", title = "no news links", content = "no news links",
                           stringsAsFactors = F)
    return(newsInfo[,col])
    }
}
