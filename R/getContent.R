#' Get Content
#'
#' Get naver news content from links.
#'
#' @param turl is naver news link.
#' @param col is what you want to get from news. Defualt is all.
#' @param try_cnt is how many you want to try again if error. Default is 3.
#' @return Get data.frame(url,datetime,edittime,press,title,body).
#' @export
#' @importFrom httr user_agent RETRY content
#' @importFrom rvest html_nodes html_text html_attr


getContent <-
  function(turl,
           col = c("url", "datetime", "edittime", "press", "title", "body"),
           try_cnt = 3) {
    uat <-
      httr::user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>")

    root <- httr::RETRY("GET", turl, uat, times = try_cnt)
    urlcheck <- root$url
    value <- T

    if (identical(grep("^http://(news|finance).naver.com", urlcheck),
                  integer(0)) & value) {
      title <- "page is not news section."
      datetime <- "page is not news section."
      edittime <- "page is not news section."
      press <- "page is not news section."
      body <- "page is not news section."
      value <- F
    }

    html_obj <- httr::content(root)
    chk <-
      rvest::html_nodes(html_obj, "div#main_content div div")
    chk <- rvest::html_attr(chk, "class")
    chk <- chk[1]

    if (is.na(chk)) {
      chk <- "not error"
    }

    if ("error_msg 404" == chk & value) {
      title <- "page is moved."
      datetime <- "page is moved."
      edittime <- "page is moved."
      press <- "page is moved."
      body <- "page is moved."
      value <- F
    }

    if (value) {
      title <- getContentTitle(html_obj)
      datetime <- getContentDatetime(html_obj)[1]
      edittime <- getContentDatetime(html_obj)[2]
      press <- getContentPress(html_obj)
      body <- getContentBody(html_obj)
    }

    newsInfo <-
      data.frame(
        url = turl,
        datetime = datetime,
        edittime = edittime,
        press = press,
        title = title,
        body = body,
        stringsAsFactors = F
      )
    return(newsInfo[, col])
  }

#' Get Content Title
#'
#' Get naver news Title from link.
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param title_node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param title_attr if you want to get attribution text, please write down here.
#' @return Get character title.
#' @export
#' @importFrom rvest html_nodes html_attr html_text

getContentTitle <-
  function(html_obj,
           title_node_info = "div.article_info h3",
           title_attr = "") {
    if (title_attr != "") {
      title <- html_nodes(html_obj, title_node_info)
      title <- html_attr(title, title_attr)
    } else{
      title <- html_nodes(html_obj, title_node_info)
      title <- html_text(title)
    }
    Encoding(title) <- "UTF-8"
    return(title)
  }


#' Get Content datetime
#'
#' Get naver news published datetime from link.
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param datetime_node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param datetime_attr if you want to get attribution text, please write down here.
#' @param getEdittime if TRUE, can get POSIXlt type datetime length 2 means published time and final edited time. if FALSE, get Date length 1.
#' @return Get POSIXlt type datetime.
#' @export
#' @importFrom rvest html_nodes html_attr html_text

getContentDatetime <-
  function(html_obj,
           datetime_node_info = "span.t11",
           datetime_attr = "",
           getEdittime = TRUE) {
    if (datetime_attr != "") {
      datetime <- html_nodes(html_obj, datetime_node_info)
      datetime <- html_attr(datetime, datetime_attr)
    } else{
      datetime <- html_nodes(html_obj, datetime_node_info)
      datetime <- html_text(datetime)
    }
    datetime <- as.POSIXlt(datetime)

    if (getEdittime) {
      if (length(datetime) == 1) {
        edittime <- datetime[1]
      }
      if (length(datetime) == 2) {
        edittime <- datetime[2]
        datetime <- datetime[1]
      }
      datetime <- c(datetime, edittime)
      return(datetime)
    }
    return(datetime)
  }


#' Get Content Press name.
#'
#' Get naver news press name from link.
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param press_node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param press_attr if you want to get attribution text, please write down here. Defalt is "title".
#' @return Get character press.
#' @export
#' @importFrom rvest html_nodes html_attr html_text

getContentPress <-
  function(html_obj,
           press_node_info = "div.article_header div a img",
           press_attr = "title") {
    if (press_attr != "") {
      press <- html_nodes(html_obj, press_node_info)
      press <- html_attr(press, press_attr)
    } else{
      press <- html_nodes(html_obj, press_node_info)
      press <- html_text(press)
    }
    Encoding(press) <- "UTF-8"
    return(press)
  }

#' Get Content body name.
#'
#' Get naver news body from link.
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param body_node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param body_attr if you want to get attribution text, please write down here.
#' @return Get character body content.
#' @export
#' @importFrom rvest html_nodes html_attr html_text

getContentBody <-
  function(html_obj,
           body_node_info = "div#articleBodyContents",
           body_attr = "") {
    if (body_attr != "") {
      body <- html_nodes(html_obj, body_node_info)
      body <- html_attr(body, body_attr)
    } else{
      body <- html_nodes(html_obj, body_node_info)
      body <- html_text(body)
    }
    Encoding(body) <- "UTF-8"

    body <- gsub("\r?\n|\r", " ", body)
    body <-
      gsub("// flash .* function _flash_removeCallback\\(\\) \\{\\} ",
           "",
           body)
    body <- trimws(body)

    return(body)
  }
