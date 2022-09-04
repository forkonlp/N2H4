#' Get Content
#'
#' Get naver news content from links.
#'
#' @param turl is naver news link.
#' @param col is what you want to get from news. Defualt is all.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom httr2 request req_user_agent req_method req_perform resp_body_html
#' @importFrom rvest html_nodes html_text html_attr
#' @examples
#' \dontrun{
#'   news_content_("https://n.news.naver.com/mnews/article/214/0001195110?sid=103")
#'   }
getContent <-   function(turl,
                         col = c("url",
                                 "original_url",
                                 "section",
                                 "datetime",
                                 "edittime",
                                 "press",
                                 "title",
                                 "body",
                                 "value")) {
  news_content(turl, col)
}

news_content <-
  function(turl,
           col = c("url",
                   "original_url",
                   "section",
                   "datetime",
                   "edittime",
                   "press",
                   "title",
                   "body",
                   "value")) {

    httr2::request(turl) %>%
      httr2::req_user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>") %>%
      httr2::req_method("GET") %>%
      httr2::req_cache(cache_path()) %>%
      httr2::req_perform() -> root

    html_obj <- httr2::resp_body_html(root)
    urlcheck <- root$url
    value <- T
    if (identical(grep("^https?://n.news.naver.com",
                       urlcheck),
                  integer(0))) {
      original_url <- "page is not news section."
      title <- "page is not news section."
      datetime <- "page is not news section."
      edittime <- "page is not news section."
      press <- "page is not news section."
      body <- "page is not news section."
      section <- "page is not news section."
      value <- F
    } else {
      # TODO: 이거 동작하는지 확인해야 함.
      chk <- rvest::html_nodes(html_obj, "div#main_content div div")
      chk <- rvest::html_attr(chk, "class")
      chk <- chk[1]
      if (is.na(chk)) {
        chk <- "not error"
      }
      if ("error_msg 404" == chk & value) {
        original_url <- "page is moved."
        title <- "page is moved."
        datetime <- "page is moved."
        edittime <- "page is moved."
        press <- "page is moved."
        body <- "page is moved."
        section <- "page is moved."
        value <- F
      }
    }
    if (value) {
      original_url <- news_content_original_url(html_obj)
      title <- news_content_title(html_obj)
      datetime <- news_content_datetime(html_obj)
      edittime <- news_content_edit_datetime(html_obj)
      press <- news_content_press(html_obj)
      body <- news_content_body(html_obj)
      section <- news_content_section(turl)
    }

    if (length(edittime) == 0) {
      edittime <- NA
    }
    newsInfo <- tibble::tibble(
      url = turl,
      original_url = original_url,
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

news_content_title <-
  function(html_obj,
           title_node_info = "h2.media_end_head_headline",
           title_attr = "") {
    node <- rvest::html_nodes(html_obj, title_node_info)
    title <- rvest::html_text(node)
    if (title_attr != "") {
      title <- rvest::html_attr(node, title_attr)
    }
    return(title)
  }


news_content_datetime <-
  function(html_obj,
           datetime_node_info = "span._ARTICLE_DATE_TIME",
           datetime_attr = "data-date-time") {
    node <- rvest::html_nodes(html_obj, datetime_node_info)
    datetime <- rvest::html_text(node)
    if (datetime_attr != "") {
      datetime <- rvest::html_attr(node, datetime_attr)
    }
    as.POSIXct(datetime, tz = "Asia/Seoul")
  }

news_content_edit_datetime <-
  function(html_obj,
           datetime_node_info = "span._ARTICLE_MODIFY_DATE_TIME",
           datetime_attr = "data-modify-date-time") {
    node <- rvest::html_nodes(html_obj, datetime_node_info)
    datetime <- rvest::html_text(node)
    if (datetime_attr != "") {
      datetime <- rvest::html_attr(node, datetime_attr)
    }
    as.POSIXct(datetime, tz = "Asia/Seoul")
  }

news_content_press <-
  function(html_obj,
           press_node_info = "div.media_end_head_top a img",
           press_attr = "title") {
    node <- rvest::html_nodes(html_obj, press_node_info)
    press <- rvest::html_text(node)
    if (press_attr != "") {
      press <- rvest::html_attr(node, press_attr)
    }
    return(press[1])
  }

news_content_body <-
  function(html_obj,
           body_node_info = "div#dic_area",
           body_attr = "") {
    node <- rvest::html_nodes(html_obj, body_node_info)
    body <- rvest::html_text(node)
    if (body_attr != "") {
      body <- rvest::html_attr(node, body_attr)
    }
    body <- trimws(gsub("\r?\n|\r|\t|\n", " ", body))
    return(body)
  }

news_content_original_url <-   function(html_obj,
                             origin_url_node_info = "a.media_end_head_origin_link",
                             origin_url_attr = "href") {
  node <- rvest::html_nodes(html_obj, origin_url_node_info)
  body <- rvest::html_text(node)
  if (origin_url_attr != "") {
    body <- rvest::html_attr(node, origin_url_attr)
  }
  body <- trimws(gsub("\r?\n|\r|\t|\n", " ", body))
  return(body)
}

#' @importFrom httr2 url_parse
news_content_section <- function(turl) {
  if (is.null(httr2::url_parse(turl)$query$sid)) {
    return(NA)
  }
  return(httr2::url_parse(turl)$query$sid)
}

