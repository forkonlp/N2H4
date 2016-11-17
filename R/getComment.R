#' Get Comment
#'
#' Get naver news comments
#' if you want to get data only comment, enter commend like below.
#' getComment(url)$result$commentList[[1]]
#'
#' @param turl like 'http://news.naver.com/main/read.nhn?mode=LSD&mid=shm&sid1=100&oid=056&aid=0010335895'.
#' @param pageSize is number of comment. defult is 10.
#' @param page is defult is 1.
#' @param sort you can select favorite, reply, old, new. favorite is defult.
#' @return Get data.frame.
#' @export
#' @import httr
#' @import jsonlite
#' @import stringr

getComment <- function(turl = url, pageSize = 10, page = 1, sort = c("favorite", "reply", "old", "new")) {

    sort <- sort[1]
    tem <- stringr::str_split(turl, "[=&]")[[1]]
    oid <- tem[grep("oid", tem) + 1]
    aid <- tem[grep("aid", tem) + 1]

    url <- paste0("https://apis.naver.com/commentBox/cbox/web_naver_list_jsonp.json?ticket=news&templateId=view_politics&pool=cbox5&lang=ko&country=KR&objectId=news",
        oid, "%2C", aid, "&categoryId=&pageSize=", pageSize, "&indexSize=10&groupId=&page=", page, "&initialize=true&useAltSort=true&replyPageSize=30&moveTo=&sort=",
        sort)
    con <- httr::GET(url, httr::add_headers(Referer = turl))
    tt <- httr::content(con, "text")

    tt <- gsub("_callback", "", tt)
    tt <- gsub("\\(", "[", tt)
    tt <- gsub("\\)", "]", tt)
    tt <- gsub(";", "", tt)
    tt <- gsub("\n", "", tt)

    data <- jsonlite::fromJSON(tt)
    print(paste0("success : ", data$success))
    return(data)

}
