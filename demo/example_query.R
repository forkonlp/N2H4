# example using query

strDate <- as.Date("2016-01-01")
endDate <- as.Date("2016-01-02")

for (Date in strDate:endDate){

  urls <- setUrlByQuery(query="work",targetDate = as.Date(Date,origin= "1970-01-01"))
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


