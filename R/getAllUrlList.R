#' Get naver news titles and links from target url.
#'
#'
#'
#' @param urls is data.frame generated from setUrl function.
#' @return Get data.frame(news_title, news_links).
#' @export
#' @import stringi

getAllUrlListByCategory <- function(urls = urls) {
    
    forurlend <- nrow(urls)
    AllurlList <- c()
    for (loc in 1:forurlend) {
        print(paste0("start ", urls[loc, 2], " / ", urls[loc, 1]))
        urlList <- getUrlListByCategory(urls[loc, 3])
        compList <- c()
        AllurlList <- rbind(AllurlList, urlList)
        pageNum <- 2
        print("get first page.")
        while (!identical(urlList, compList)) {
            print(paste0("get ", pageNum, " page."))
            compList <- urlList
            url <- paste0(urls[loc, 3], "&page=", pageNum)
            urlList <- getUrlListByCategory(url)
            AllurlList <- unique(rbind(AllurlList, urlList))
            pageNum <- pageNum + 1
        }
    }
    return(AllurlList)
}


#' Get naver news titles and links from target url.
#'
#'
#'
#' @param urls is data.frame generated from setUrl function.
#' @return Get data.frame(news_title, news_links).
#' @export
#' @import stringi

getAllUrlListByQuery <- function(urls = urls) {
    
    AllurlList <- c()
    print(paste0("start ", urls[1, 1]))
    urlList <- getUrlListByQuery(urls[1, 3])
    compList <- c()
    AllurlList <- rbind(AllurlList, urlList)
    pageNum <- 2
    print("get first page.")
    while (!identical(urlList, compList)) {
        print(paste0("get ", pageNum, " page."))
        compList <- urlList
        url <- paste0(urls[1, 3], "&page=", pageNum)
        urlList <- getUrlListByQuery(url)
        AllurlList <- unique(rbind(AllurlList, urlList))
        pageNum <- pageNum + 1
    }
    return(AllurlList)
}
