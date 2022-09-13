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

req_build_comment_history <-
  function(turl, commentNo, pageSize, nextid) {
    direction <- "next"
    if (is.null(nextid)) {
      direction <- NULL
    }

    httr2::request("https://apis.naver.com/") %>%
      httr2::req_url_path_append("commentBox") %>%
      httr2::req_url_path_append("cbox") %>%
      httr2::req_url_path_append("web_naver_list_per_user_jsonp.json") %>%
      httr2::req_url_query(ticket = "news") %>%
      httr2::req_url_query(pool = "cbox5") %>%
      httr2::req_url_query(lang = "ko") %>%
      httr2::req_url_query(country = "KR") %>%
      httr2::req_url_query(sort = "new") %>%
      # 지운 댓글 데이터 포함 여부
      httr2::req_url_query(includeAllStatus = "true") %>%
      httr2::req_url_query(objectId = get_oid(turl)) %>%
      httr2::req_url_query(pageSize = pageSize) %>%
      httr2::req_url_query(commentNo = commentNo) %>%
      # 이 부분이 있어야 다음 페이지 데이터를 제공함
      httr2::req_url_query(pageType = "more") %>%
      httr2::req_url_query(moreParam.direction = direction) %>%
      httr2::req_url_query(moreParam.next = nextid) %>%
      httr2::req_user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>") %>%
      httr2::req_headers(Referer = turl) %>%
      httr2::req_method("GET")
  }

#' @importFrom httr2 request req_user_agent req_method req_perform
get_real_url <- function(turl) {
  . <- NULL
  httr2::request(turl) %>%
    httr2::req_user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>") %>%
    httr2::req_method("HEAD")
    httr2::req_perform() %>%
    .$url
}
