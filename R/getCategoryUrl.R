#' Get naver news sub_category names and urls recently.
#'
#' Main category urls are written manually like blow.
#' cate_code<-c(100,101,102,103,104,105)
#' There are 6 categories in never news.
#' 1: Politics, 2: Economics, 3: Social, 4: Living / Culture, 5: World, 6: IT / science
#'
#' @param select from 1 to 6 numeric values which mean categories.
#' @return Get data.frame(cate_name, cate_sub, cate_url).
#' @export
#' @import xml2
#' @import rvest

getCategoryUrl <- function(select = c(1, 2, 3, 4, 5, 6)) {

#     home <- "http://news.naver.com/"
#     tem <- readLines(home, warn = F)
#     tem <- tem[grep("class=\"m[3-8] nclick", tem)]
#     cate_names <- xml2::read_html(paste0(tem, collapse = " ")) %>% rvest::html_nodes("a") %>% rvest::html_text()
#     Encoding(cate_names) <- "UTF-8"
#     cate_code <- data.frame(cate_name = cate_names, code = c(100, 101, 102, 103, 104, 105))
#     url <- "http://news.naver.com/main/main.nhn?mode=LSD&mid=shm&sid1="
#     urls <- data.frame(cate_name = NA, cate_sub = NA, cate_url = NA)
#     urls <- urls[-1, ]
#
#     cate_code <- cate_code[select, ]
#
#     for (code in 1:nrow(cate_code)) {
#
#         category_url <- paste0(url, cate_code[code, 2])
#         tem <- readLines(category_url, warn = F)
#         tem <- tem[grep("class=\"snb_s", tem)]
#         if (!identical(grep("snb_s17", tem), integer(0))) {
#             tem <- tem[-grep("snb_s17", tem)]
#         }
#         tem <- tem[-length(tem)]
#         cate_names <- xml2::read_html(paste0(tem, collapse = " ")) %>% rvest::html_nodes("a") %>% rvest::html_text()
#         Encoding(cate_names) <- "UTF-8"
#         cate_urls <- xml2::read_html(paste0(tem, collapse = " ")) %>% rvest::html_nodes("a") %>% rvest::html_attr("href")
#
#         urls <- rbind(urls, data.frame(cate_name = cate_code[code, 1], cate_sub = cate_names, cate_url = cate_urls))
#     }
    urls<-system.file("urls", "catedata.csv", package = "N2H4")
    urls<-urls[urls$select %in% select,c(2,3,4)]
    return(urls)
}

