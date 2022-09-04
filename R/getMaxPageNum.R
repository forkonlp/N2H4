#' Get Max Page Number
#'
#' @param turl is target url include sid1, sid2, date like below.
#'             <http://news.naver.com/main/list.nhn?sid2=265&sid1=100&mid=shm&mode=LS2D&date=20161102>
#' @param max is also interval to try max page number is numeric. Default is 100.
#' @return Get numeric
#' @export
#' @importFrom rvest html_node html_text
#' @importFrom httr2 request req_url_query req_method req_perform resp_body_html
#' @examples
#' \dontrun{
#'   getMaxPageNum("https://news.naver.com/main/list.naver?mode=LS2D&mid=shm&sid1=103&sid2=376")
#'   }
getMaxPageNum <- function(turl, max = 100) {
  news_max_page_num(turl, max)
}
news_max_page_num <- function(turl, max = 100) {
  httr2::request(turl) %>%
    httr2::req_url_query(page = max) %>%
    httr2::req_method("GET") %>%
    httr2::req_cache(cache_path()) %>%
    httr2::req_perform() %>%
    httr2::resp_body_html() -> hobj

  noContent <-  rvest::html_node(hobj, "div.no_content")
  if (inherits(noContent, "xml_node")) {
    return("no result")
  }
  ifmax <- rvest::html_node(hobj, "a.next")
  while (inherits(ifmax, "xml_node")) {
    max <- max + max
    httr2::request(turl) %>%
      httr2::req_url_query(page = max) %>%
      httr2::req_method("GET") %>%
      httr2::req_cache(cache_path()) %>%
      httr2::req_perform() %>%
      httr2::resp_body_html() -> hobj
    ifmax <- rvest::html_node(hobj, "a.next")
  }
  rvest::html_node(hobj, "div.paging strong") %>%
    rvest::html_text() %>%
    as.numeric() %>%
    return()
}
