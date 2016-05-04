#' @export
getCategoryUrl<-function(){
  
  cate_code<-c(100,101,102,103,104,105)
  url  <- "http://news.naver.com/main/main.nhn?mode=LSD&mid=shm&sid1="
  urls <- data.frame(cate_name=NA,cate_url=NA)
  urls <- urls[-1,]
  for (code in cate_code){
    
    category_url<-paste0(url,code)
    tem <- readLines(category_url,warn=F)
    tem <- tem[grep("class=\"snb_s",tem)]
    if(!identical(grep("snb_s17",tem),integer(0))){
      tem <- tem[-grep("snb_s17",tem)]
    }
    tem <- tem[-length(tem)]
    cate_names<-rvest::read_html(paste0(tem,collapse=" ")) %>%
      rvest::html_nodes("a") %>%
      rvest::html_text()
    Encoding(cate_names)<-"UTF-8"
    cate_urls<-rvest::read_html(paste0(tem,collapse=" ")) %>%
      rvest::html_nodes("a") %>%
      rvest::html_attr("href")

    urls<-rbind(urls,data.frame(cate_name=cate_names,cate_url=cate_urls))
  }
  return(urls)
  
}