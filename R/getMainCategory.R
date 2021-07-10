#' Get News Main Categories
#'
#' Get naver news main category names and ids recently.
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom rvest html_nodes html_attr html_text
#' @importFrom httr GET content user_agent
#' @examples
#' \donttest{
#'   getMainCategory()
#'   }

getMainCategory <- function() {
  root   <- "http://news.naver.com/"

  uat <-
    httr::user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>")
  src <- httr::GET(root, uat)
  hobj <- httr::content(src)

  titles <- rvest::html_nodes(hobj, "div.lnb_menu ul li a")
  titles <- rvest::html_text(titles)

  links <- rvest::html_nodes(hobj, "div.lnb_menu ul li a")
  links <- rvest::html_attr(links, "href")

  titles <-
    titles[grep("^\\/main\\/main.naver\\?mode=LSD&mid=shm&sid1=1", links)]
  titles <- trimws(titles)
  links <-
    links[grep("^\\/main\\/main.naver\\?mode=LSD&mid=shm&sid1=1", links)]

  sid1 <- sapply(strsplit(links, "="), function(x) x[4])

  urls <-
    tibble::tibble(cate_name = titles,
               sid1 = sid1)
  return(urls)

}
