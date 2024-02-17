context("function test")

test_that("help functions", {
  url  <-
    "https://n.news.naver.com/mnews/article/001/0009205077?sid=102"
  oid <- get_oid(url)
  expect_equal(oid, "001,0009205077")
  url  <-
    "https://n.news.naver.com/article/028/0002603835"
  oid <- get_oid(url)
  expect_equal(oid, "028,0002603835")
})

test_that("getComment", {
  skip_on_cran()
  url  <-
    "https://n.news.naver.com/mnews/article/001/0009205077?sid=102"
  test <- getComment(url, type = "list")
  test <- test$result$commentList[[1]]
  expect_equal(test$contents, "test")
  url  <-
    "https://n.news.naver.com/mnews/article/015/0002303155?sid=100"
  test <- getComment(url, type = "list")
  test <- test$result$commentList[[1]]
  expect_equal(test$contents, c("test", "test2", "test"))
})

test_that("getAllComment", {
  skip_on_cran()
  url  <-
    "https://n.news.naver.com/mnews/article/015/0002303155?sid=100"
  test <- getAllComment(url)
  expect_equal(test$contents, c("test", "test2", "test"))
})


test_that("getCommentHistory", {
  skip_on_cran()
  url  <-
    "https://n.news.naver.com/mnews/article/001/0009205077?sid=102"
  test <- getComment(url, type = "df")
  dat <- getCommentHistory(url, test$commentNo)
  expect_equal(dat$contents, c("test", "test2","test","test"))
})

test_that("getAllCommentHistory", {
  skip_on_cran()
  url  <-
    "https://n.news.naver.com/mnews/article/001/0009205077?sid=102"
  test <- getComment(url)
  dat <- getAllCommentHistory(url, test$commentNo)
  expect_equal(dat$contents, c("test", "test2","test","test"))
})


test_that("getContent", {
  skip_on_cran()
  url  <-
    "https://n.news.naver.com/mnews/article/001/0009205077?sid=102"
  test <- getContent(url)
  expect_equal(test$url, url)
})

test_that("passSportsnews", {
  skip_on_cran()
  url  <-
    "https://sports.news.naver.com/news?oid=477&aid=0000073768"
  test <- getContent(url)
  expect_equal(test$body, "page is not news section.")

  url <- getContent("https://n.news.naver.com/mnews/article/277/0003204982?sid=106")
  expect_equal(test$body, "page is not news section.")

})

test_that("getCategory", {
  test <- getCategory()
  expect_equal(test, news_category)
})

test_that("getCategoryFresh", {
  test <- getCategory(fresh = TRUE)
  expect_equal(names(test), c("cate_name", "sid1", "sub_cate_name", "sid2"))
  expect_equal(nrow(test), 48)
})

test_that("getMainCategory", {
  skip_on_cran()
  test <- getMainCategory()
  expect_equal(test$sid1, c("100", "101", "102", "103", "105", "104"))
})

test_that("getSubCategory", {
  skip_on_cran()
  test <- getSubCategory()
  expect_equal(test$sid2[1], "264")
})
