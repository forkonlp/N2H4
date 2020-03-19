#' Get News Sub Categories
#'
#' Get naver news sub category names and urls recently.
#'
#' @param sid1 Main category id in naver news url. Only 1 value is passible. Default is 100 means Politics.
#' @param onlySid2 sid2 is sub category id. some sub categories don't have id. If TRUE, functions return data.frame(chr:sub_cate_naem, char:sid2). Defaults is TRUE.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom rvest html_nodes html_attr html_text
#' @importFrom httr GET content user_agent
#' @examples
#' \donttest{
#'   getSubCategory(100)
#'   getSubCategory(100, FALSE)
#'   }
getSubCategory <- function(sid1 = 100, onlySid2 = TRUE) {
  root <-
    paste0("http://news.naver.com/main/main.nhn?mode=LSD&mid=shm&sid1=",
           sid1)
  uat <-
    httr::user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>")
  src <- httr::GET(root, uat)
  hobj <- httr::content(src)
  titles <- rvest::html_nodes(hobj, "div.snb ul.nav li a")
  titles <- rvest::html_text(titles)
  titles <- trimws(titles)

  links <- rvest::html_nodes(hobj, "div.snb ul.nav li a")
  links <- rvest::html_attr(links, "href")
  links <- paste0("http://news.naver.com", links)

  urls <-
    tibble::tibble(
      sub_cate_name = titles,
      url = links
    )
  if (onlySid2 == FALSE)  {
    return(urls)
  }
  else{
    urls <- urls[grep("sid2=", urls$url),]
    sid2 <- sapply(strsplit(urls$url, "="), function(x)
      x[5])
    urls <-
      tibble::tibble(
        sub_cate_name = urls$sub_cate_name,
        sid2 = sid2
      )
    return(urls)
  }

}
