context("function test")

test_that("getComment", {

  url  <- "http://news.naver.com/main/read.nhn?mode=LSD&mid=shm&sid1=102&oid=001&aid=0009205077"
  test <- getComment(url)
  test <- test$result$commentList[[1]]
  expect_equal(test$contents, "test")

})

test_that("getContent", {

  url  <- "http://news.naver.com/main/read.nhn?mode=LSD&mid=shm&sid1=102&oid=001&aid=0009205077"
  test <- getContent(url)
  expect_equal(test$url, url)

})

test_that("getMainCategory", {

  test <- getMainCategory()
  expect_equal(test$sid1, c("100","101","102","103","104","105"))

})

test_that("getMaxPageNum", {

  url  <- "http://news.naver.com/main/list.nhn?sid2=254&sid1=102&mid=shm&mode=LS2D&date=20170427"
  test <- getMaxPageNum(url)
  expect_equal(test, 2)

})
