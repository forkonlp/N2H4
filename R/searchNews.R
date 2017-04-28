#' Search Naver News
#'
#' Search Naver News using Naver news search API
#'
#'
#'
#' @param client_id character. provided by Naver after registering application here : 'https://developers.naver.com'
#' @param client_secret character.Refers to 'client_secret' provided by naver when you register application.
#' @param term character. Search keyword
#' @param start integer. Default value is 1 and max possible value is 1000. Xth number of article to start extracting from.
#' @param display integer, Default value is 10, max possible value is 100. The number of articles to extract.
#' @param sort character. sort search result by 'sim':similarity or 'date':date.
#' @return Get data.frame.
#' @export
#' @import httr



searchNews=function(client_id,client_secret,term,start=1,display=10,sort=c("sim","date"))
{
  sort=sort[1]
  news_api="https://openapi.naver.com/v1/search/news.json"

  encoded.term=URLencode(iconv(term,localeToCharset()[1],"UTF-8"))
  term2=paste("?query=",encoded.term,sep="")
  display2=paste("display=",display,sep="")
  start2=paste("start=",start,sep="")
  sort2=paste("sort=",sort,sep="")
  query=paste(term2,display2,start2,sort2,sep="&")

  request=try(httr::GET(paste(news_api,query,sep=""),httr::add_headers("X-Naver-Client-Id"=client_id, "X-Naver-Client-Secret"=client_secret)))
  if(!inherits(request,'try-error'))
  {
    request.content=httr::content(request,"parsed",encoding="UTF-8")
  }
  content.df=do.call(rbind.data.frame,request.content$items)

  if(display!=1)
  {
    content.df=data.frame(sapply(content.df,as.character),stringsAsFactors = FALSE)
    content.df$title=as.character(sapply(content.df$title,html2text))
    content.df$description=as.character(sapply(content.df$description,html2text))
  } else {
    content.df=data.frame(as.list(sapply(content.df,html2text)),stringsAsFactors = FALSE)
  }
  return(content.df)
}


#' Change html formatted text to plain text
#'
#'
#'
#' @param x character to be converted from html format to plain text
#' @return
#' @export
#' @import XML
html2text=function(x)
{
  xmlValue(getNodeSet(htmlParse(x, asText = TRUE,encoding="UTF-8"), "//p|//body")[[1]])
}
