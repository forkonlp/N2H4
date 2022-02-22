context("function test")
with_mock_api({
  test_that("getComment", {
    url  <-
      "https://news.naver.com/main/read.naver?mode=LSD&mid=shm&sid1=102&oid=001&aid=0009205077"
    test <- getComment(url, type = "list")
    test <- test$result$commentList[[1]]
    expect_equal(test$contents, "test")
  })

  test_that("getAllComment", {
    url  <-
      "https://news.naver.com/main/read.naver?mode=LS2D&mid=shm&sid1=100&sid2=264&oid=015&aid=0002303155"
    test <- getAllComment(url)
    expect_equal(test$contents, c("test", "test2", "test"))
  })


  test_that("getContent", {
    url  <-
      "https://news.naver.com/main/read.naver?mode=LSD&mid=shm&sid1=102&oid=001&aid=0009205077"
    test <- getContent(url)
    expect_equal(test$url, url)
  })

  test_that("passSportsnews", {
    url  <-
      "https://sports.news.naver.com/wfootball/news/read.naver?oid=477&aid=0000073768"
    test <- getContent(url)
    expect_equal(test$body, "page is not news section.")
  })

  test_that("getMainCategory", {
    test <- getMainCategory()
    expect_equal(test$sid1, c("100", "101", "102", "103", "105", "104"))
  })

  test_that("getMaxPageNum", {
    url  <-
      "https://news.naver.com/main/list.naver?sid2=254&sid1=102&mid=shm&mode=LS2D&date=20170427"
    test <- getMaxPageNum(url)
    expect_equal(test, 1)
  })

  test_that("getUrlList", {
    url <-
      "https://news.naver.com/main/list.naver?sid2=267&sid1=100&mid=shm&mode=LS2D&date=20170101"
    test <- getUrlList(url)
    expect_identical(dim(test), c(20L, 2L))
  })
})
