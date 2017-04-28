#' Set url for crawling
#'
#' Set naver news links with sid, date, etc.
#' sid1, sid2, page can use vectors.
#' sid1, sid2, start Date, end Date is requred.
#'
#' @param sid1_vec is news code in naver news url
#' @param sid2_vec is news code in naver news url.
#' @param strDate target date of start.
#' @param endDate target date of end.
#' @param page_vec pageNum default is NA.
#' @return Get data.frame(sid1,sid2,date,pageNum,pageUrl).
#' @export
#' @import httr

setUrls <- function(sid1_vec, sid2_vec, strDate, endDate, page_vec=NA){
  url_list <- expand.grid(sid1_vec, sid2_vec, strDate:endDate, page_vec, stringsAsFactors=FALSE)
  colnames(url_list) <- c("sid1", "sid2", "date", "pageNum")
  url_list <- apply(url_list, 1, as.list)
  url_list <- sapply(url_list, function(x){
    pageUrl <- parse_url("http://news.naver.com/main/list.nhn")
    if(is.na(x$page)){
      pageUrl$query <- list(sid1=x$sid1, sid2=x$sid2, mid="shm", mode="LS2D", date=x$date)
    } else {
      pageUrl$query <- list(sid1=x$sid1, sid2=x$sid2, mid="shm", mode="LS2D", date=x$date, page=x$pageNum)
    }
    x$pageUrl <- build_url(pageUrl)
    return(x)
  })
  return(as.data.frame(t(url_list)))
}
