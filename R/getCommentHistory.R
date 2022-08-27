#' Get Comment History
#'
#' Get naver news comments on user histories.
#'
#' @param turl character. News article on 'Naver' such as
#'             <https://n.news.naver.com/mnews/article/001/0009205077?sid=102>.
#'             News articl url that is not on Naver.com domain will generate an error.
#' @param commentNo Parent Comment No.
#' @param pageSize is a number of comments per page. defult is 10. max is 100.
#' @param page is defult is 1.
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
getCommentHistory <- function(turl,
                              commentNo,
                              pageSize = 10,
                              page = 1,
                              type = c("df", "list")) {
  turl <-
    httr::GET(turl,
              httr::user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>"))$url

  objectId <- get_oid(turl)

  url <- paste0(
    "https://apis.naver.com/commentBox/cbox/web_naver_list_per_user_jsonp.json?ticket=news&templateId=view_society_m1&pool=cbox5&lang=ko&country=KR&objectId=",
    objectId,
    "&categoryId=&pageSize=",
    pageSize,
    "&indexSize=10&groupId=&listType=user&pageType=more&page=",
    page,
    "1&sort=NEW&commentNo=",
    commentNo,
    "&targetUserInKey=&includeAllStatus=true"
  )

  con <- httr::GET(
    url,
    httr::user_agent("N2H4 using r by chanyub.park mrchypark@gmail.com"),
    httr::add_headers(Referer = turl)
  )
  tt <- httr::content(con, "text")
  tt <- rm_callback(tt)
  dat <- jsonlite::fromJSON(tt)
  dat$result$count

  if (type[1] == "list") {
    class(dat) <- "list"
  }
  if (type[1] == "df") {
    dat <- dat$result$commentList[[1]]
    dat <- tibble::as_tibble(dat)
    if (length(dat) == 0) {
      dat <- tibble::tibble()
    }
  }
  return(dat)
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
  temp <-
    getCommentHistory(turl,
                      commentNo,
                      pageSize = 10,
                      page = 1,
                      type = "list")
  numPage <- ceiling(temp$result$pageModel$totalRows / 100)
  comments <-
    lapply(1:numPage, function(x)
      getCommentHistory(
        turl = turl,
        commentNo = commentNo,
        pageSize = 100,
        page = x,
        type = "df"
      ))

  return(do.call(rbind, comments))
}
