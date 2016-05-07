#' Get naver news titles and links from target url.
#'
#'
#'
#' @param url is data.frame generated from setUrl function.
#' @return Get data.frame(news_title, news_links).
#' @export
#' @import stringi

getAllUrlList <- function(urls=urls){

  forurlend <- nrow(urls)
  AllurlList<-c()
  for(loc in 1:forurlend){
    print(paste0("start ",urls[loc,2]," / ",urls[loc,1]))
    urlList <- getUrlList(urls[loc,3])
    compList <- c()
    AllurlList <- rbind(AllurlList,urlList)
    pageNum <- 2
    print("get first page.")
    while(!identical(urlList,compList)){
      print(paste0("get ",pageNum," page."))
      compList <- urlList
      url <- paste0(urls[loc,3],"&page=",pageNum)
      urlList <- getUrlList(url)
      AllurlList <- unique(rbind(AllurlList,urlList))
      pageNum <- pageNum+1
    }
  }
  return(AllurlList)
}
