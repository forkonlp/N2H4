#' Get Query page url
#'
#' Get naver news query page url without pageNum.
#'
#' @param query requred.
#' @param startDate Dfault is 3 days before today.
#' @param endDate Default is today.
#' @return url.
#' @export
#' @examples
#' \donttest{
#'   getQueryUrl("endgame")
#'   }

getQueryUrl <- function(query,
                        startDate=as.Date(Sys.time()) - 3,
                        endDate=as.Date(Sys.time())
                        ) {
  if (Encoding(query) != "UTF-8") {
    query <- iconv(query, to = "UTF-8")
  }

  ds_str <- gsub("-",".",as.character(startDate))
  ds_end <- gsub("-",".",as.character(endDate))

  from <- gsub("-","",as.character(startDate))
  to <- gsub("-","",as.character(endDate))

  query <- utils::URLencode(query)
  root <- "https://search.naver.com/search.naver?"
  link <-
    paste0(
      root,
      "where=news&query=",
      query,
      "&sm=tab_opt&sort=1&photo=0&field=0&reporter_article=&pd=3&ds=",
      ds_str,
      "&de=",
      ds_end,
      "&docid=&nso=so%3Add%2Cp%3Afrom",
      from,
      "to",
      to,
      "%2Ca%3Aall&mynews=0&refresh_start=0&related=0"
    )
  return(link)
}
