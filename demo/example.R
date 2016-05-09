if (!require("pacman")) install.packages("pacman")
pacman::p_load_gh("mrchypark/N2H4")


# example using category

strDate <- as.Date("2016-01-01")
endDate <- as.Date("2016-01-02")

for (Date in strDate:endDate){

  urls <- setUrlByCategory(select=1,targetDate = as.Date(Date,origin= "1970-01-01"))

  forurlend <- nrow(urls)

  for (loc in 1:forurlend) {
    print(paste0("start ", urls[loc, 2], " / ", urls[loc, 1]))
    urlList <- getUrlListByCategory(urls[loc, 3])
    compList <- c()
    pageNum <- 2
    print("get first page.")

    for (url in urlList[,2]){
      print(url)
      newsData <- getContent(url)
      filenames <- substr(newsData$url,nchar(newsData$url)-9,nchar(newsData$url))
      dir.create("./data",showWarnings = FALSE)
      write.csv(newsData,paste0("./data/",Date,"_",filenames,".csv"),row.names=F)
    }
    while (!identical(urlList, compList)) {
      print(paste0("get ", pageNum, " page."))
      compList <- urlList
      url <- paste0(urls[loc, 3], "&page=", pageNum)
      urlList <- getUrlListByCategory(url)
      pageNum <- pageNum + 1
      for (url in urlList[,2]){
        print(url)
        newsData <- getContent(url)
        filenames <- substr(newsData$url,nchar(newsData$url)-9,nchar(newsData$url))
        dir.create("./data",showWarnings = FALSE)
        write.csv(newsData,paste0("./data/",Date,"_",filenames,".csv"),row.names=F)
      }
    }
  }
}


# example using query
# not stable

strDate <- as.Date("2016-01-01")
endDate <- as.Date("2016-01-02")

for (Date in strDate:endDate){

  urls <- setUrlByQuery(query="대통령",targetDate = as.Date(Date,origin= "1970-01-01"))
  allList <- getAllUrlListByQuery(urls)

  if(!identical(grep("no naver news",allList[,2]),integer(0))){
    allList<-allList[-grep("no naver news",allList[,2]),]
  }

  if(!identical(grep("sports.news.naver.com",allList[,2]),integer(0))){
    allList<-allList[-grep("sports.news.naver.com",allList[,2]),]
  }

  for (url in allList[,2]){
    print(url)
    newsData <- getContent(url)
    filenames <- substr(newsData$url,nchar(newsData$url)-9,nchar(newsData$url))
    dir.create("./data",showWarnings = FALSE)
    write.csv(newsData,paste0("./data/",Date,"_",filenames,".csv"),row.names=F)
  }

}



