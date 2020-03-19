#' Set url for crawling
#'
#' Set naver news links with sid, date, etc.
#' sid1, sid2, page can use vectors.
#' sid1, sid2, start Date, end Date is requred.
#'
#' @param sid1_vec is news code in naver news url
#' @param sid2_vec is news code in naver news url.
#' @param strDate target date of start.
#' @param endDate target date of end.
#' @param page_vec pageNum default is NA.
#' @param return_type list or data.frame. default is list.
#' @return Get data.frame(sid1,sid2,date,pageNum,pageUrl) or list(sid1,sid2,date,pageNum,pageUrl)
#' @export
#' @importFrom httr build_url parse_url
#' @examples
#'  \donttest{
#'   setUrls(105, 227, "20180101", "20180102")
#'   }

setUrls <-
  function(sid1_vec,
           sid2_vec,
           strDate,
           endDate,
           page_vec = NA,
           return_type = c("list", "df")) {
    return_type <- return_type[1]
    # Generate date lists from strDate to endDate
    strDate_POSIX <- strptime(strDate, format = "%Y%m%d")
    diff_day <-
      as.numeric(
        strptime(endDate, format = "%Y%m%d", tz = "") - strptime(strDate, format =
                                                                   "%Y%m%d", tz = "")
      )
    date_list <-
      as.numeric(strftime(seq(
        strDate_POSIX, by = "day", length.out = diff_day
      ), format = "%Y%m%d"))

    # Generate url lists for query
    url_list <-
      expand.grid(sid1_vec, sid2_vec, date_list, page_vec, stringsAsFactors =
                    FALSE)
    colnames(url_list) <- c("sid1", "sid2", "date", "pageNum")
    url_list <- apply(url_list, 1, as.list)
    if (return_type == "list") {
      url_list <- lapply(url_list, function(x) {
        pageUrl <- httr::parse_url("http://news.naver.com/main/list.nhn")
        if (is.na(x$page)) {
          pageUrl$query <-
            list(
              sid1 = x$sid1,
              sid2 = x$sid2,
              mid = "shm",
              mode = "LS2D",
              date = x$date
            )
        } else {
          pageUrl$query <-
            list(
              sid1 = x$sid1,
              sid2 = x$sid2,
              mid = "shm",
              mode = "LS2D",
              date = x$date,
              page = x$pageNum
            )
        }
        x$pageUrl <- httr::build_url(pageUrl)
        return(x)
      })
      return(url_list)
    }

    if (return_type == "df") {
      url_list <- sapply(url_list, function(x) {
        pageUrl <- httr::parse_url("http://news.naver.com/main/list.nhn")
        if (is.na(x$page)) {
          pageUrl$query <-
            list(
              sid1 = x$sid1,
              sid2 = x$sid2,
              mid = "shm",
              mode = "LS2D",
              date = x$date
            )
        } else {
          pageUrl$query <-
            list(
              sid1 = x$sid1,
              sid2 = x$sid2,
              mid = "shm",
              mode = "LS2D",
              date = x$date,
              page = x$pageNum
            )
        }
        x$pageUrl <- httr::build_url(pageUrl)
        return(x)
      })
      return(as.data.frame(t(url_list)))
    }
  }
