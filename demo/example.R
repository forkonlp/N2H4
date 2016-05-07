# example using category

strDate <- as.Date("2016-01-01")
endDate <- as.Date("2016-01-02")

for (Date in strDate:endDate){

  urls <- setUrlByCategory(select=1,targetDate = as.Date(Date,origin= "1970-01-01"))
  allList <- getAllUrlList(urls)

  for (url in allList[,2]){
    newsData <- getContent(url)

  }

}




# example using query

strDate <- "2016-01-01"
endDate <- "2016-01-02"


urls <- setUrlByQuery(query="대통령")
