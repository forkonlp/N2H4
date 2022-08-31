#' Get Comment
#'
#' Get naver news comments
#' if you want to get data only comment, enter command like below.
#' getComment(url)$result$commentList[[1]]
#'
#' @param turl like <https://n.news.naver.com/mnews/article/023/0003712918>.
#' @param count is a number of comments. Defualt is 10. "all" works to get all comments.
#' @param type type return df or list. Defualt is df. df return part of data not all.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom httr GET user_agent add_headers content
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @examples
#' \dontrun{
#'   getComment("https://n.news.naver.com/mnews/article/421/0002484966?sid=100")
#'}
#
# getComment <- function(turl,
#                        count = 10,
#                        type = c("df", "list")) {
#
#   turl <- get_real_url(turl)
#
#   reqs <- build_comment_urls(turl, count)
#
#
#     httr2::req_perform() %>%
#     httr2::resp_body_string() %>%
#     rm_callback() %>%
#     jsonlite::fromJSON() -> dat
#
#   if (type[1] == "list") {
#     class(dat) <- "list"
#   }
#   if (type[1] == "df") {
#     dat <- dat$result$commentList[[1]]
#     dat$snsList <- NULL
#     dat <- tibble::as_tibble(dat)
#     if (length(dat) == 0) {
#       dat <- tibble::tibble()
#     }
#   }
#   return(dat)
# }

get_real_url <- function(turl) {
  httr2::request(turl) %>%
    httr2::req_user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>") %>%
    httr2::req_method("HEAD") %>%
    httr2::req_perform() %>%
    .$url
}

basic_comment_req <- function(turl, page, pageSize, nextid) {
  oid <- paste0("news", get_oid(turl))
  ticket <- "news"
  pool <- "cbox5"
  templateId <- "view_politics"

  if (grepl("http(|s)://(m.|)sports.", turl)) {
    ticket <- "sports"
    pool <- "cbox2"
    templateId <- "view"
  }

  direction <- "next"
  if (is.null(nextid)) {
    direction <- NULL
  }

  # moreParam.direction=next&moreParam.prev=05u1vh5j8y1ud&moreParam.next=05u0xbppvtqz9

  httr2::request("https://apis.naver.com/") %>%
    httr2::req_url_path_append("commentBox") %>%
    httr2::req_url_path_append("cbox") %>%
    httr2::req_url_path_append("web_naver_list_jsonp.json") %>%
    httr2::req_url_query(ticket = ticket) %>%
    httr2::req_url_query(templateId = templateId) %>%
    httr2::req_url_query(pool = pool) %>%
    httr2::req_url_query(lang = "ko") %>%
    httr2::req_url_query(country = "KR") %>%
    httr2::req_url_query(sort = "new") %>%
    # 지운 댓글 데이터 포함 여부
    httr2::req_url_query(includeAllStatus = "true") %>%
    httr2::req_url_query(objectId = oid) %>%
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

#' @importFrom httr parse_url
get_oid <- function(turl) {
  turl <- gsub("mnews/", "", turl)
  tem <- strsplit(httr::parse_url(turl)$path, "[/]")[[1]]
  paste0(tem[2], ",", tem[3])
}

rm_callback <- function(text) {
  text <- gsub("_callback", "", text)
  text <- gsub("\\(", "[", text)
  text <- gsub("\\)", "]", text)
  text <- gsub(";", "", text)
  text <- gsub("\n", "", text)
}


#' Get All Comment
#'
#' Get all comments from the provided news article url on naver
#'
#' Works just like getComment, but this function executed in a fashion where it finds and extracts all comments from the given url.
#'
#' @param turl character. News article on 'Naver' such as <http://news.naver.com/main/read.nhn?mode=LSD&mid=shm&sid1=100&oid=056&aid=0010335895>. News articl url that is not on Naver.com domain will generate an error.
#' @param ... parameter in getComment function.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @examples
#' \dontrun{
#'   getAllComment("https://n.news.naver.com/mnews/article/214/0001195110?sid=103")
#'   }

getAllComment <- function(turl, ...) {
  temp <-
    getComment(turl,
               pageSize = 10,
               page = 1,
               type = "list")
  numPage <- ceiling(temp$result$pageModel$totalRows / 100)
  comments <-
    lapply(1:numPage, function(x) {
      getComment(
        turl = turl,
        pageSize = 100,
        page = x,
        type = "df"
      )
    })

  return(do.call(rbind, comments))
}



get_comment <- function(turl,
                        count = 10,
                        type = c("df", "list")) {
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

  # url 동작용 버전 확인
  turl <- get_real_url(turl)
  # 첫 시도용 req 생성
  count_case %>%
    purrr::when(. == "base" ~ count,
                ~ 100) %>%
    basic_comment_req(turl, 1, ., NULL) %>%
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
    basic_comment_req(turl, .x, 100, nextid) %>%
      httr2::req_perform() %>%
      httr2::resp_body_string() %>%
      rm_callback() %>%
      jsonlite::fromJSON() -> dat
    res[[i]] <- transform_return(dat, "df")
    nextid <- dat$result$morePage$`next`
  }

  return(do.call(rbind, res) )
}

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
