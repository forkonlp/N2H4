context("function test")
test_that("getComment", {
  skip_on_cran()
  url  <-
    "https://n.news.naver.com/mnews/article/001/0009205077?sid=102"
  test <- getComment(url, type = "list")
  test <- test$result$commentList[[1]]
  expect_equal(test$contents, "test")
})

test_that("getAllComment", {
  skip_on_cran()
  url  <-
    "https://n.news.naver.com/mnews/article/015/0002303155?sid=100"
  test <- getAllComment(url)
  expect_equal(test$contents, c("test", "test2", "test"))
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
})

test_that("getMainCategory", {
  skip_on_cran()
  test <- getMainCategory()
  expect_equal(test$sid1, c("100", "101", "102", "103", "105", "104"))
})

test_that("getMaxPageNum", {
  skip_on_cran()
  url  <-
    "https://news.naver.com/main/list.naver?sid2=254&sid1=102&mid=shm&mode=LS2D&date=20170427"
  test <- getMaxPageNum(url)
  expect_equal(test, 1)
})

test_that("getUrlList", {
  skip_on_cran()
  url <-
    "https://news.naver.com/main/list.naver?sid2=267&sid1=100&mid=shm&mode=LS2D&date=20170101"
  test <- getUrlList(url)
  expect_identical(dim(test), c(20L, 2L))
})
