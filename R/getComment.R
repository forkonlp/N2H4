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
#' @importFrom tibble as_tibble
#' @examples
#' \dontrun{
#'   getComment("https://n.news.naver.com/mnews/article/421/0002484966?sid=100")
#'}

getComment <- function(turl,
                       pageSize = 10,
                       page = 1,
                       sort = c("favorite", "reply", "old", "new", "best"),
                       type = c("df", "list")) {
  turl <-
    httr::GET(turl,
              httr::user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>"))$url

  oid <- get_oid(turl)
  sort <- toupper(sort[1])
  ticket <- "news"
  pool <- "cbox5"
  templateId <- "view_politics"

  if (grepl("http(|s)://(m.|)sports.", turl)) {
    ticket <- "sports"
    pool <- "cbox2"
    templateId <- "view"
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
      "&categoryId=&pageSize=",
      pageSize,
      "&indexSize=10&groupId=&page=",
      page,
      "&initialize=true",
      "&replyPageSize=30&moveTo=&sort=",
      sort
    )

  con <- httr::GET(
    url,
    httr::user_agent("N2H4 using r by chanyub.park mrchypark@gmail.com"),
    httr::add_headers(Referer = turl)
  )
  tt <- httr::content(con, "text")
  tt <- rm_callback(tt)
  dat <- jsonlite::fromJSON(tt)

  if (type[1] == "list") {
    class(dat) <- "list"
  }
  if (type[1] == "df") {
    dat <- dat$result$commentList[[1]]
    dat$snsList <- NULL
    dat <- tibble::as_tibble(dat)
    if (length(dat) == 0) {
      dat <- tibble::tibble()
    }
  }
  return(dat)
}

#' @importFrom httr parse_url
get_oid <- function(turl) {
  turl <- gsub("mnews/", "", turl)
  tem <- strsplit(httr::parse_url(turl)$path, "[/]")[[1]]
  paste0(tem[2], "%2C", tem[3])
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

getAllComment <- function(turl = url, ...) {
  temp <-
    getComment(
      turl,
      pageSize = 10,
      page = 1,
      type = "list"
    )
  numPage <- ceiling(temp$result$pageModel$totalRows / 100)
  comments <-
    lapply(1:numPage, function(x)
      getComment(
        turl = turl,
        pageSize = 100,
        page = x,
        type = "df",
        ...
      ))

  return(do.call(rbind, comments))
}
