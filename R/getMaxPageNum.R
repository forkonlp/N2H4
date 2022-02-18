#' Get Max Page Number
#'
#' @param turl is target url include sid1, sid2, date like below.
#'             <http://news.naver.com/main/list.nhn?sid2=265&sid1=100&mid=shm&mode=LS2D&date=20161102>
#' @param max is also interval to try max page number is numeric. Default is 100.
#' @return Get numeric
#' @export
#' @importFrom rvest read_html html_node html_text
#' @importFrom httr GET content
#' @examples
#' \donttest{
#'   print(cate_list_url_ex)
#'   getMaxPageNum(cate_list_url_ex)
#'   }

getMaxPageNum <- function(turl = url, max = 100) {
  ifmaxUrl <- paste0(turl, "&page=", max)
  hobj <- rvest::read_html(httr::content(httr::GET(ifmaxUrl), "text"))
  noContent <-  rvest::html_node(hobj, "div.no_content")
  if (class(noContent) == "xml_node") {
    return("no result")
  }
  ifmax <- rvest::html_node(hobj, "a.next")
  while (class(ifmax) == "xml_node") {
    max <- max + max
    ifmaxUrl <- paste0(turl, "&page=", max)
    hobj <- rvest::read_html(ifmaxUrl)
    ifmax <- rvest::html_node(hobj, "a.next")
  }
  maxPageNum <- html_node(hobj, "div.paging strong")
  maxPageNum <- html_text(maxPageNum)
  maxPageNum <- as.numeric(maxPageNum)
  return(maxPageNum)
}
