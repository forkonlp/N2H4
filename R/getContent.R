#' Get naver news content from links.
#'
#'
#' @param url is naver news link.
#' @return Get data.frame(cate_name, cate_sub, cate_url).
#' @export
#' @import rvest

getContent<-function(url=url){

  tem <- read_html(url)
  title <- tem %>%
    html_nodes("div.article_info h3") %>%
    html_text()
  Encoding(title)<-"UTF-8"

}
