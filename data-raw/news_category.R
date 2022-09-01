## code to prepare `news_category` dataset goes here
library(N2H4)

news_category <- getCategory(fresh = TRUE)

usethis::use_data(news_category, overwrite = TRUE, internal = TRUE)
