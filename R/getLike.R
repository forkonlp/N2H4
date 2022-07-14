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
#' \dontrun{
#'   getLike("https://n.news.naver.com/mnews/article/214/0001195110?sid=103")
#'}

getLike <- function(turl = url) {
  tem <- strsplit(urltools::path(turl), "[/]")[[1]]
  oid <- tem[3]
  aid <- tem[4]
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
