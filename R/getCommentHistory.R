#' Get Comment History
#'
#' Get naver news comments on user histories.
#'
#' @param turl character. News article on 'Naver' such as
#'             <https://n.news.naver.com/mnews/article/001/0009205077?sid=102>.
#'             News articl url that is not on Naver.com domain will generate an error.
#' @param commentNo Parent Comment No.
#' @param count is a number of comments. Defualt is 10. "all" works to get all comments.
#' @param type type return df or list. Defult is df. df return part of data not all.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @examples
#' \dontrun{
#'   cno <- getComment("https://n.news.naver.com/mnews/article/421/0002484966?sid=100")
#'   getCommentHistory("https://n.news.naver.com/mnews/article/421/0002484966?sid=100",
#'     cno$commnetNo[1])
#'}
getCommentHistory <- function(turl,
                              commentNo,
                              count = 10,
                              type = c("df", "list")) {
  get_comment_history(turl, commentNo, count, type)
}

#' Get All Comment History
#'
#'
#' @param turl character. News article on 'Naver' such as
#'             <https://n.news.naver.com/mnews/article/001/0009205077?sid=102>.
#'             News articl url that is not on Naver.com domain will generate an error.
#' @param commentNo Parent Comment No.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @examples
#' \dontrun{
#'   getAllComment("https://n.news.naver.com/mnews/article/214/0001195110?sid=103")
#'   }

getAllCommentHistory <- function(turl,
                                 commentNo) {
  get_comment_history(turl, commentNo, "all", "df")
}

#' @importFrom purrr when
#' @importFrom httr2 req_perform
get_comment_history <- function(turl,
                                commentNo,
                                count = 10,
                                type = c("df", "list")) {
  . <- .x <- NULL
  type <- match.arg(type)

  count %>%
    purrr::when(. == "all" ~ "all",!is.numeric(.) ~ "error",
                . > 100 ~ "over",
                . <= 100 ~ "base",
                ~ "error") -> count_case

  if (count_case == "error") {
    stop(paste0("count param can accept number or 'all'. your input: ", count))
  }

  turl <- get_real_url(turl)

  count_case %>%
    purrr::when(. == "base" ~ count,
                ~ 100) %>%
    req_build_comment_history(turl, commentNo, ., NULL) %>%
    httr2::req_perform() %>%
    httr2::resp_body_string() %>%
    rm_callback() %>%
    jsonlite::fromJSON() -> dat

  total <- dat$result$pageModel$totalRows
  nextid <- dat$result$morePage$`next`

  if (count_case == "base") {
    return(transform_return(dat, type))
  }

  purrr::when(count_case == "all" ~ total,
              total >= count ~ count,
              total < count ~ {
                warning("Request more than the actual total count, and use actual total count.")
                total
              }) -> tarsize

  res <- list()
  res[[1]] <- transform_return(dat, "df")

  for (i in 2:ceiling(tarsize / 100)) {
    req_build_comment_history(turl, commentNo, 100, nextid) %>%
      httr2::req_perform() %>%
      httr2::resp_body_string() %>%
      rm_callback() %>%
      jsonlite::fromJSON() -> dat
    res[[i]] <- transform_return(dat, "df")
    nextid <- dat$result$morePage$`next`
  }

  return(do.call(rbind, res))
}


