#' Get Url List By Category
#'
#' Get naver news titles and links from target url.
#'
#' @param turl is target url naver news.
#' @param  col is what you want to get from news. Defualt is all.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom rvest html_nodes html_attr html_text
#' @importFrom httr GET content user_agent
#' @examples
#'  \donttest{
#'   print(cate_list_url_ex)
#'   getUrlListByCategory(cate_list_url_ex)
#'   }

getUrlListByCategory <-
  function(turl = url,
           col = c("titles", "links")) {
    uat <-
      httr::user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>")
    src <- httr::GET(turl, uat)
    hobj <- httr::content(src)

    titles <- rvest::html_nodes(hobj, "dt a")
    titles <- rvest::html_text(titles)
    Encoding(titles) <- "UTF-8"

    rm_target <- rvest::html_nodes(hobj, "dt.photo a")
    rm_target <- rvest::html_text(rm_target)
    Encoding(rm_target) <- "UTF-8"

    links <- rvest::html_nodes(hobj, "dt a")
    links <- rvest::html_attr(links, "href")

    news_lists <-
      tibble::tibble(titles = titles,
                 links = links)

    news_lists$titles <- trimws(news_lists$titles)
    news_lists <- news_lists[nchar(news_lists$titles) > 0, ]

    rm_target <- trimws(rm_target)
    rm_target <- rm_target[nchar(rm_target) > 0]

    if (!identical(paste0(rm_target, collapse = " "), "")) {
      news_lists <- news_lists[-grep(rm_target[1], news_lists$titles), ]
    }

    return(news_lists[, col])

  }
