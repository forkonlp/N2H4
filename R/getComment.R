#' Get Comment
#'
#' Get naver news comments.
#' if you want to get data only comment, enter command like below.
#' getComment(url)$result$commentList[[1]]
#'
#' @param turl like <https://n.news.naver.com/mnews/article/023/0003712918>.
#' @param count is a number of comments. Defualt is 10. "all" works to get all comments.
#' @param type type return df or list. Defualt is df. df return part of data not all.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @examples
#' \dontrun{
#'   getComment("https://n.news.naver.com/mnews/article/421/0002484966?sid=100")
#'}
#
getComment <- function(turl,
                       count = 10,
                       type = c("df", "list")) {
  get_comment(turl, count, type)
}

#' Get All Comment
#'
#' Get all comments from the provided news article url on naver
#'
#' Works just like getComment, but this function executed in a fashion
#'   where it finds and extracts all comments from the given url.
#'
#' @param turl character. News article on 'Naver' such as
#' <https://n.news.naver.com/mnews/article/023/0003712918>.
#' News article url that is not on Naver.com domain will generate an error.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @examples
#' \dontrun{
#'   getAllComment("https://n.news.naver.com/mnews/article/214/0001195110")
#'   }
getAllComment <- function(turl) {
  get_comment(turl, "all", "df")
}

#' @importFrom httr2 req_perform resp_body_string
#' @importFrom jsonlite fromJSON
get_comment <- function(turl,
                        count = 10,
                        type = c("df", "list")) {
  . <- NULL
  type <- match.arg(type)

  if (count == "all") {
    count_case <- "all"
  } else if (!is.numeric(count)) {
    count_case <- "error"
  } else if (count > 100) {
    count_case <- "over"
  } else if (count <= 100) {
    count_case <- "base"
  } else {
    count_case <- "error"
  }

  if (count_case == "error") {
    stop(paste0("count param can accept number or 'all'. your input: ", count))
  }

  turl <- get_real_url(turl)

  result <- 100
  if (count_case == "base") {
    result <- count
  }

  result %>%
    req_build_comment(turl, ., NULL) %>%
    httr2::req_perform() %>%
    httr2::resp_body_string() %>%
    rm_callback() %>%
    jsonlite::fromJSON() -> dat

  total <- dat$result$pageModel$totalRows
  nextid <- dat$result$morePage$`next`

  if (count_case == "base") {
    return(transform_return(dat, type))
  }

  if(count_case == "all") {
    tarsize <- total
  } else if(total >= count) {
    tarsize <- count
  } else if(total < count) {
    warning("Request more than the actual total count, and use actual total count.")
    tarsize <- total
  }

  res <- list()
  res[[1]] <- transform_return(dat, "df")

  for (i in 2:ceiling(tarsize / 100)) {
    req_build_comment(turl, 100, nextid) %>%
      httr2::req_perform() %>%
      httr2::resp_body_string() %>%
      rm_callback() %>%
      jsonlite::fromJSON() -> dat
    res[[i]] <- transform_return(dat, "df")
    nextid <- dat$result$morePage$`next`
  }

  return(do.call(rbind, res))
}

