getCommentUserHistory <- function(turl,
                                  commentNo,
                                  pageSize = 10,
                                  page = 1,
                                  type = c("df", "list")) {
  turl <-
    httr::GET(turl,
              httr::user_agent("N2H4 by chanyub.park <mrchypark@gmail.com>"))$url
  tem <- strsplit(urltools::path(turl), "[/]")[[1]]

  oid <- tem[2]
  aid <- tem[3]

  objectId <- paste0("news", oid, "%2C", aid)

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
