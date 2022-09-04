#' News Category
#'
#' @param fresh get data from online. Default is FALSE using cached built-in data.
#' @export
getCategory <- function(fresh = FALSE) {
  news_category(fresh)
}

news_category <- function(fresh = FALSE) {
  if (!fresh) {
    return(news_category_data)
  }
  mcate <- getMainCategory()
  cate <- list()
  for (i in seq_along(mcate$sid1)) {
    cate[[i]] <- cbind(
      cate_name = mcate$cate_name[i],
      sid1 = mcate$sid1[i],
      getSubCategory(sid1 = mcate$sid1[i])
    )
  }
  return(tibble::as_tibble(do.call(rbind, cate)))
}

#' Get News Main Categories
#'
#' Get naver news main category names and ids recently.
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom rvest html_nodes html_attr html_text
#' @importFrom httr2 request req_user_agent req_headers req_method req_perform resp_body_html
#' @examples
#' \dontrun{
#'   getMainCategory()
#'   }

getMainCategory <- function() {
  httr2::request("https://news.naver.com/") %>%
    httr2::req_user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>") %>%
    httr2::req_headers("Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9") %>%
    httr2::req_method("GET") %>%
    httr2::req_cache(cache_path()) %>%
    httr2::req_perform() %>%
    httr2::resp_body_html() -> hobj

  hobj %>%
    rvest::html_nodes(".Nlist_item a") %>%
    rvest::html_text() -> titles

  hobj %>%
    rvest::html_nodes(".Nlist_item a") %>%
    rvest::html_attr("href") -> links

  titles <-
    titles[grep("\\/main\\/main.naver\\?mode=LSD&mid=shm&sid1=1", links)]
  titles <- trimws(titles)
  links <-
    links[grep("\\/main\\/main.naver\\?mode=LSD&mid=shm&sid1=1", links)]

  sid1 <- sapply(strsplit(links, "="),
                 function(x) {
                   x[4]
                 })

  urls <-
    tibble::tibble(cate_name = titles,
                   sid1 = sid1)
  return(urls)
}


#' Get News Sub Categories
#'
#' Get naver news sub category names and urls recently.
#'
#' @param sid1 Main category id in naver news url. Only 1 value is passible. Default is 100 means Politics.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom rvest html_nodes html_attr html_text
#' @importFrom httr2 request req_url_path req_url_query req_user_agent req_perform resp_body_html
#' @examples
#' \dontrun{
#'   getSubCategory(100)
#'   getSubCategory(100, FALSE)
#'   }
getSubCategory <- function(sid1 = 100) {
  httr2::request("http://news.naver.com") %>%
    httr2::req_url_path("main/main.naver") %>%
    httr2::req_url_query(mode = "LSD") %>%
    httr2::req_url_query(mid = "shm") %>%
    httr2::req_url_query(sid1 = sid1) %>%
    httr2::req_user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>") %>%
    httr2::req_cache(cache_path()) %>%
    httr2::req_perform() %>%
    httr2::resp_body_html() -> hobj

  hobj %>%
    rvest::html_nodes("div.snb ul.nav li a") %>%
    rvest::html_text() %>%
    trimws() -> titles

  links <- rvest::html_nodes(hobj, "div.snb ul.nav li a")
  links <- rvest::html_attr(links, "href")
  links <- paste0("http://news.naver.com", links)

  urls <-
    tibble::tibble(sub_cate_name = titles,
                   url = links)
  urls <- urls[grep("sid2=", urls$url),]
  sid2 <- sapply(strsplit(urls$url, "="), function(x) {
    x[5]
  })
  urls <-
    tibble::tibble(sub_cate_name = urls$sub_cate_name,
                   sid2 = sid2)
  return(urls)
}
