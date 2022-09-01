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

#' @importFrom purrr when
#' @importFrom httr2 req_perform resp_body_string
#' @importFrom jsonlite fromJSON
get_comment <- function(turl,
                        count = 10,
                        type = c("df", "list")) {
  . <- NULL
  type <- match.arg(type)

  count %>%
    purrr::when(. == "all" ~ "all",
                !is.numeric(.) ~ "error",
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

  purrr::when(count_case == "all" ~ total,
              total >= count ~ count,
              total < count ~ {
                warning("Request more than the actual total count, and use actual total count.")
                total
              }) -> tarsize

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

#' @importFrom httr2 request req_user_agent req_method req_perform
get_real_url <- function(turl) {
  . <- NULL
  httr2::request(turl) %>%
    httr2::req_user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>") %>%
    httr2::req_method("HEAD") %>%
    httr2::req_perform() %>%
    .$url
}

#' @importFrom httr2 request req_url_path_append req_url_query req_user_agent req_headers req_method
req_build_comment <- function(turl, pageSize, nextid) {

  direction <- "next"
  if (is.null(nextid)) {
    direction <- NULL
  }

  httr2::request("https://apis.naver.com/") %>%
    httr2::req_url_path_append("commentBox") %>%
    httr2::req_url_path_append("cbox") %>%
    httr2::req_url_path_append("web_naver_list_jsonp.json") %>%
    httr2::req_url_query(ticket = "news") %>%
    httr2::req_url_query(pool = "cbox5") %>%
    httr2::req_url_query(lang = "ko") %>%
    httr2::req_url_query(country = "KR") %>%
    httr2::req_url_query(sort = "new") %>%
    # 지운 댓글 데이터 포함 여부
    httr2::req_url_query(includeAllStatus = "true") %>%
    httr2::req_url_query(objectId = paste0("news", get_oid(turl))) %>%
    httr2::req_url_query(pageSize = pageSize) %>%
    # 이 부분이 있어야 다음 페이지 데이터를 제공함
    httr2::req_url_query(pageType = "more") %>%
    httr2::req_url_query(moreParam.direction = direction) %>%
    # httr2::req_url_query(moreParam.prev = morePage$prev) %>%
    httr2::req_url_query(moreParam.next = nextid) %>%
    httr2::req_user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>") %>%
    httr2::req_headers(Referer = turl) %>%
    httr2::req_method("GET")
}

#' @importFrom httr2 url_parse
get_oid <- function(turl) {
  turl <- gsub("mnews/", "", turl)
  tem <- strsplit(httr2::url_parse(turl)$path, "[/]")[[1]]
  paste0(tem[3], ",", tem[4])
}

rm_callback <- function(text) {
  text <- gsub("_callback", "", text)
  text <- gsub("\\(", "[", text)
  text <- gsub("\\)", "]", text)
  text <- gsub(";", "", text)
  text <- gsub("\n", "", text)
}

#' @importFrom tibble as_tibble
transform_return <- function(dat, type) {
  class(dat) <- "list"
  if (type == "df") {
    dat <- dat$result$commentList[[1]]
    dat$snsList <- NULL
    dat <- tibble::as_tibble(dat)
    if (length(dat) == 0) {
      dat <- tibble::tibble()
    }
  }
  return(dat)
}
