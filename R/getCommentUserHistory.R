getCommentUserHistory <- function() {

 url <- "https://apis.naver.com/commentBox/cbox/web_naver_list_per_user_jsonp.json?ticket=news&templateId=view_society_m1&pool=cbox5&lang=ko&country=KR&objectId=news119%2C0002633261&categoryId=&pageSize=10&indexSize=10&groupId=&listType=user&pageType=more&page=1&sort=NEW&commentNo=767429991443988618&targetUserInKey=&includeAllStatus=true"

 turl <- "https://n.news.naver.com/article/119/0002633261"

 con <- httr::GET(
   url,
   httr::user_agent("N2H4 using r by chanyub.park mrchypark@gmail.com"),
   httr::add_headers(Referer = turl)
 )
 tt <- httr::content(con, "text")
 tt <- rm_callback(tt)
 dat <- jsonlite::fromJSON(tt)
 dat$result$count

 }


