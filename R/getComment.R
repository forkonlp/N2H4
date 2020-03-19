#' Get Comment
#'
#' Get naver news comments
#' if you want to get data only comment, enter command like below.
#' getComment(url)$result$commentList[[1]]
#'
#' @param turl like <https://news.naver.com/main/read.nhn?mode=LSD&mid=shm&sid1=100&oid=056&aid=0010335895>.
#' @param pageSize is a number of comments per page. defult is 10. max is 100.
#' @param page is defult is 1.
#' @param sort you can select favorite, reply, old, new. favorite is defult.
#' @param type type return df or list. Defult is df. df return part of data not all.
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom httr GET user_agent add_headers content
#' @importFrom jsonlite fromJSON
#' @importFrom tidyr unnest
#' @importFrom tibble as_tibble
#' @examples
#' \donttest{
#'   print(news_url_ex)
#'   getComment(news_url_ex)
#'}

getComment <- function(turl = url,
                       pageSize = 10,
                       page = 1,
                       sort = c("favorite", "reply", "old", "new", "best"),
                       type = c("df", "list")) {
  sort <- sort[1]
  tem <- strsplit(turl, "[=&]")[[1]]
  ticket <- "news"
  pool <- "cbox5"
  oid <- tem[grep("oid", tem) + 1]
  aid <- tem[grep("aid", tem) + 1]
  templateId <- "view_politics"
  useAltSort <- "&useAltSort=true"

  if (grepl("http(|s)://(m.|)sports.", turl)) {
    ticket <- "sports"
    pool <- "cbox2"
    templateId <- "view"
    useAltSort <- ""
  }

  url <-
    paste0(
      "https://apis.naver.com/commentBox/cbox/web_naver_list_jsonp.json?",
      "ticket=",
      ticket,
      "&templateId=",
      templateId,
      "&pool=",
      pool,
      "&lang=ko&country=KR&objectId=news",
      oid,
      "%2C",
      aid,
      "&categoryId=&pageSize=",
      pageSize,
      "&indexSize=10&groupId=&page=",
      page,
      "&initialize=true",
      useAltSort,
      "&replyPageSize=30&moveTo=&sort=",
      sort
    )

  con <- httr::GET(
    url,
    httr::user_agent("N2H4 using r by chanyub.park mrchypark@gmail.com"),
    httr::add_headers(Referer = turl)
  )
  tt <- httr::content(con, "text")

  tt <- gsub("_callback", "", tt)
  tt <- gsub("\\(", "[", tt)
  tt <- gsub("\\)", "]", tt)
  tt <- gsub(";", "", tt)
  tt <- gsub("\n", "", tt)

  dat <- jsonlite::fromJSON(tt)
  if (type[1] == "df") {
    dat <- dat$result$commentList[[1]]
    dat$snsList <- NULL
    if (length(dat) != 0) {
      dat <- tidyr::unnest(dat)
      dat <- tibble::as_tibble(dat)
    } else {
      dat <- tibble::tibble()
    }
  }
  return(dat)
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
#' @importFrom dplyr bind_rows
#' @export
#' @examples
#' \donttest{
#'   print(news_url_ex)
#'   getAllComment(news_url_ex)
#'   }

getAllComment <- function(turl = url, ...) {
  temp        <-
    getComment(
      turl,
      pageSize = 1,
      page = 1,
      sort = "favorite",
      type = "list"
    )
  numPage     <- ceiling(temp$result$pageModel$totalRows / 100)
  comments    <-
    lapply(1:numPage, function(x)
      getComment(
        turl = turl,
        pageSize = 100,
        page = x,
        type = "df",
        ...
      ))

  comments <- dplyr::bind_rows(comments)

  return(comments)
}
