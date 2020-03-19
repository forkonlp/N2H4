#' Get Query news trend by date.
#'
#' Get number of query volume in naver news. Params depend on getQueryUrl function.
#'
#' @param query requred.
#' @param startDate requred form YYYY-MM-DD.
#' @param endDate requred form YYYY-MM-DD.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_text
#' @examples
#' \donttest{
#'   getNewsTrend("endgame", "2019-03-03", "2019-03-04")
#'   }

getNewsTrend <-
  function(query, startDate, endDate) {

    result <- c()
    tdate <-
      as.Date(as.Date(startDate):as.Date(endDate), origin = "1970-01-01")
    turl <-
      N2H4::getQueryUrl(
        query,
        startDate = tdate,
        endDate = tdate
      )
    result$date <- tdate
    result$cnt <-
      sapply(turl, function(x)
        trimws(rvest::html_text(
          rvest::html_nodes(xml2::read_html(x), "div.title_desc span")
        )))
    names(result$cnt) <- NULL
    result$cnt <-
      sapply(result$cnt, function(x)
        ifelse(identical(x, character(0)), "/0", x))
    tem <- strsplit(result$cnt, "/")
    result$cnt <- sapply(tem, function(x)
      x[2])
    result$cnt <- as.numeric(gsub("[^0-9]", "", result$cnt))
    result <- as.data.frame(result)
    result <- tibble::as_tibble(result)
    return(result)
  }
