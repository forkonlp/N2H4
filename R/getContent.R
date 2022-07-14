#' Get Content
#'
#' Get naver news content from links.
#'
#' @param turl is naver news link.
#' @param col is what you want to get from news. Defualt is all.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom httr GET user_agent content
#' @importFrom rvest html_nodes html_text html_attr
#' @examples
#' \dontrun{
#'   getContent("https://n.news.naver.com/mnews/article/214/0001195110?sid=103")
#'   }

getContent <-
  function(turl,
           col = c("url",
                   "section",
                   "datetime",
                   "edittime",
                   "press",
                   "title",
                   "body",
                   "value")) {
    uat <-
      httr::user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>")
    root <- httr::GET(turl, uat)
    urlcheck <- root$url
    value <- T
    if (identical(grep("^https?://n.news.naver.com",
                       urlcheck),
                  integer(0)) & value) {
      title <- "page is not news section."
      datetime <- "page is not news section."
      edittime <- "page is not news section."
      press <- "page is not news section."
      body <- "page is not news section."
      section <- "page is not news section."
      value <- F
    }
    html_obj <- httr::content(root)
    chk <- rvest::html_nodes(html_obj, "div#main_content div div")
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
      section <- "page is moved."
      value <- F
    }
    if (value) {
      title <- getContentTitle(html_obj)
      datetime <- getContentDatetime(html_obj)
      edittime <- getContentEditDatetime(html_obj)
      press <- getContentPress(html_obj)
      body <- getContentBody(html_obj)
      section <- getSection(turl)
    }

    if (length(edittime) == 0) {
      edittime <- NA
    }
    newsInfo <- tibble::tibble(
      url = turl,
      datetime = datetime,
      edittime = edittime,
      press = press,
      title = title,
      body = body,
      section = section,
      value = value
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
#' @examples
#' \dontrun{
#'   hobj <- rvest::read_html("https://n.news.naver.com/mnews/article/214/0001195110?sid=103")
#'   getContentTitle(hobj)
#'   }

getContentTitle <-
  function(html_obj,
           title_node_info = "h2.media_end_head_headline",
           title_attr = "") {
    if (title_attr != "") {
      title <- rvest::html_nodes(html_obj, title_node_info)
      title <- rvest::html_attr(title, title_attr)
    } else{
      title <- rvest::html_nodes(html_obj, title_node_info)
      title <- rvest::html_text(title)
    }
    return(title)
  }


#' Get Content datetime
#'
#' Get naver news published datetime from link.
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param datetime_node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param datetime_attr if you want to get attribution text, please write down here.
#' @return Get POSIXlt type datetime.
#' @export
#' @importFrom rvest html_nodes html_attr html_text
#' @examples
#' \dontrun{
#'   hobj <- rvest::read_html("https://n.news.naver.com/mnews/article/214/0001195110?sid=103")
#'   getContentDatetime(hobj)
#'   }

getContentDatetime <-
  function(html_obj,
           datetime_node_info = "span._ARTICLE_DATE_TIME",
           datetime_attr = "data-date-time") {
    if (datetime_attr != "") {
      datetime <- rvest::html_nodes(html_obj, datetime_node_info)
      datetime <- rvest::html_attr(datetime, datetime_attr)
    } else{
      datetime <- rvest::html_nodes(html_obj, datetime_node_info)
      datetime <- rvest::html_text(datetime)
    }
    as.POSIXct(datetime, tz = "Asia/Seoul")
  }

#' Get Content Edit datetime
#'
#' Get naver news edited datetime from link.
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param datetime_node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param datetime_attr if you want to get attribution text, please write down here.
#' @return Get POSIXlt type datetime.
#' @export
#' @importFrom rvest html_nodes html_attr html_text
#' @examples
#' \dontrun{
#'   hobj <- rvest::read_html("https://n.news.naver.com/mnews/article/214/0001195110?sid=103")
#'   getContentEditDatetime(hobj)
#'   }

getContentEditDatetime <-
  function(html_obj,
           datetime_node_info = "span._ARTICLE_MODIFY_DATE_TIME",
           datetime_attr = "data-modify-date-time") {
    if (datetime_attr != "") {
      datetime <- rvest::html_nodes(html_obj, datetime_node_info)
      datetime <- rvest::html_attr(datetime, datetime_attr)
    } else{
      datetime <- rvest::html_nodes(html_obj, datetime_node_info)
      datetime <- rvest::html_text(datetime)
    }
    as.POSIXct(datetime, tz = "Asia/Seoul")
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
#' @examples
#' \dontrun{
#'   hobj <- rvest::read_html("https://n.news.naver.com/mnews/article/214/0001195110?sid=103")
#'   getContentPress(hobj)
#'   }

getContentPress <-
  function(html_obj,
           press_node_info = "div.media_end_head_top a img",
           press_attr = "title") {
    if (press_attr != "") {
      press <- rvest::html_nodes(html_obj, press_node_info)
      press <- rvest::html_attr(press, press_attr)
    } else{
      press <- rvest::html_nodes(html_obj, press_node_info)
      press <- rvest::html_text(press)
    }
    return(press[1])
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
#' @examples
#' \dontrun{
#'   hobj <- rvest::read_html("https://n.news.naver.com/mnews/article/214/0001195110?sid=103")
#'   getContentBody(hobj)
#'   }

getContentBody <-
  function(html_obj,
           body_node_info = "div#dic_area",
           body_attr = "") {
    if (body_attr != "") {
      body <- rvest::html_nodes(html_obj, body_node_info)
      body <- rvest::html_attr(body, body_attr)
    } else{
      body <- rvest::html_nodes(html_obj, body_node_info)
      body <- rvest::html_text(body)
    }

    body <- gsub("\r?\n|\r|\t|\n", " ", body)
    body <- trimws(body)

    return(body)
  }

#' @importFrom urltools param_get
getSection <- function(turl) {
  return(urltools::param_get(turl, "sid")$sid)
}
