if (!require("doParallel")) install.packages("doParallel")
if (!require("foreach")) install.packages("foreach")
library(doParallel)
library(foreach)

strDate <- as.Date("2016-01-01")
endDate <- as.Date("2016-01-02")

cl<-parallel::makeCluster(parallel::detectCores())
registerDoParallel(cl)

for (Date in strDate:endDate){

  urls <- setUrlByCategory(select=c(1,2,3,4,6),targetDate = as.Date(Date,origin= "1970-01-01"))

  forurlend <- nrow(urls)

  for (loc in 1:forurlend) {
    print(paste0("start ", urls[loc, 2], " / ", urls[loc, 1]))
    urlList <- getUrlListByCategory(urls[loc, 3])
    compList <- c()
    pageNum <- 2
    print("get first page.")

    newsData <- getContentParallel(urlList[,2])
    filenames <- substr(newsData$url,nchar(newsData$url)-9,nchar(newsData$url))
    dir.create("./data",showWarnings = FALSE)
    tem<-lapply(seq_along(newsData[,1]), function(i) write.csv(newsData[i,],paste0("./data/",Date,"_",filenames[i],".csv"),row.names=F))
    rm(tem)

    while (!identical(urlList, compList)) {
      print(paste0("get ", pageNum, " page."))
      compList <- urlList
      url <- paste0(urls[loc, 3], "&page=", pageNum)
      urlList <- getUrlListByCategory(url)
      pageNum <- pageNum + 1

      newsData <- getContentParallel(urlList[,2])
      filenames <- substr(newsData$url,nchar(newsData$url)-9,nchar(newsData$url))
      dir.create("./data",showWarnings = FALSE)
      tem<-lapply(seq_along(newsData[,1]), function(i) write.csv(newsData[i,],paste0("./data/",Date,"_",filenames[i],".csv"),row.names=F))
      rm(tem)

    }
  }
}
parallel::stopCluster(cl)

