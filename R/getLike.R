#' Get like Count
#'
#' Get naver news like Count
#'
#' @param turl like <https://news.naver.com/main/read.nhn?mode=LSD&mid=shm&sid1=100&oid=056&aid=0010335895>.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom httr GET user_agent add_headers content
#' @importFrom tibble tibble
#' @examples
#' \donttest{
#'   print(news_url_ex)
#'   getLike(news_url_ex)
#'}

getLike <- function(turl = url) {
  tem <- strsplit(turl, "[=&]")[[1]]
  oid <- tem[grep("oid", tem) + 1]
  aid <- tem[grep("aid", tem) + 1]
  url <- paste0(
    "https://news.like.naver.com/v1/search/contents?suppress_response_codes=true&q=NEWS[ne_",
    oid,
    "_",
    aid,
    "]"
  )

  con <- httr::GET(url,
                   httr::user_agent("N2H4 using r by chanyub.park mrchypark@gmail.com"),
                   httr::add_headers(Referer = turl))
  tt <- httr::content(con)
  tt <- tt$contents[[1]]$reactions
  cate <- sapply(tt, function(x) x$reactionType)
  cnt <- sapply(tt, function(x) x$count)
  dat <- tibble::tibble(cate, cnt)
  return(dat)
}
