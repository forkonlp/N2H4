#' Get Query page url
#'
#' Get naver news(only not other sites links) titles(are just "dummy" now) and links from target url.
#'
#' @param query requred.
#' @param st Default is news.all.
#' @param q_enc Default is euc-kr.
#' @param r_enc Default is UTF-8.
#' @param r_format Default is xml.
#' @param rp Default is none.
#' @param sm Default is all.basic.
#' @param ic Default is all.
#' @param so Default is datetime.dsc.
#' @param detail Default is 1 means only display title.
#' @param startDate Dfault is 3 days before today.
#' @param endDate Default is today.
#' @param stPaper Default is exist:1.
#' @param pd Default is 1.
#' @param page Default is 1.
#' @param dnaSo Default is rel.dsc.
#' @return Get url.
#' @export

getQueryUrl <- function(query,st="news.all",
                        q_enc="EUC-KR",
                        r_enc="UTF-8",
                        r_format="xml",
                        rp="none",
                        sm="all.basic",
                        ic="all",
                        so="datetime.dsc",
                        startDate=as.Date(Sys.time())-3,
                        endDate=as.Date(Sys.time()),
                        stPaper="exist:1",
                        page=1,
                        detail=1,
                        pd=1,
                        dnaSo="rel.dsc") {
  query <- utils::URLencode(query)
  root <- "http://news.naver.com/main/search/search.nhn?"
  link <- paste0(root,"st=",st,"&q_enc=",q_enc,"&r_enc=",r_enc,
                 "&r_format=",r_format,
                 "&rp=",rp,
                 "&sm=",sm,
                 "&ic=",ic,
                 "&so=",so,
                 "&detail=",detail,
                 "&pd=",pd,
                 "&dnaSo=",dnaSo,
                 "&startDate=",startDate,
                 "&endDate=",endDate,
                 "&stPaper=",stPaper,
                 "&page=",page,
                 "&query=",query)
  return(link)
}
