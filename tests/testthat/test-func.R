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

test_that("passSportsnews", {

  url  <- "http://sports.news.naver.com/wfootball/news/read.nhn?oid=477&aid=0000073768"
  test <- getContent(url)
  expect_equal(test$body, "page is not news section.")

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

# test_that("getVideoUrl",{
#
#   url  <- "http://news.naver.com/main/read.nhn?mode=LPOD&mid=tvh&oid=437&aid=0000143025"
#   test <- getVideoUrl(url)
#   expected  <- "http://news.video.p.rmcnmv.naver.com/owfs_rmc/read/NEWS_2017_01_01_5/531C05F39305F3AC2033EE1A93792813B82_muploader_e_270P_480_500_64_2.mp4?_lsu_sa_=67d595fc611060e610de45ff6c55e7bc6eef3e88c6063f7c3fd7f8c497cc3e051e228a8e6c15e00e40623852d43c7b4d57664b3483a2ff7d843930bced98ea0d9c507066ad92a275d3901fa6c1546fed"
#   expect_equal(test,expected)
#
# })

test_that("getQueryUrl",{

  test <- getQueryUrl("test",startDate = "2017-04-28",endDate = "2017-05-01")
  expected <- "http://news.naver.com/main/search/search.nhn?st=news.all&q_enc=EUC-KR&r_enc=UTF-8&r_format=xml&rp=none&sm=all.basic&ic=all&so=datetime.dsc&detail=1&pd=1&dnaSo=rel.dsc&startDate=2017-04-28&endDate=2017-05-01&stPaper=exist:1&query=test"
  expect_equal(test,expected)

})

test_that("getUrlListByCategory",{

  url <- "http://news.naver.com/main/list.nhn?sid2=267&sid1=100&mid=shm&mode=LS2D&date=20170101"
  test <- getUrlListByCategory(url)
  expect_identical(dim(test) ,c(20L, 2L))

})
