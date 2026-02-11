testthat::test_that("getContent warns and delegates to news_content", {
  testthat::local_mocked_bindings(
    news_content = function(...) tibble::tibble(url = "u"),
    .package = "N2H4"
  )

  testthat::expect_warning(
    out <- getContent("https://example.com"),
    "deprecated"
  )
  testthat::expect_equal(out$url, "u")
})

testthat::test_that("legacy wrappers warn and delegate", {
  testthat::local_mocked_bindings(
    news_comment = function(...) "comment",
    news_comment_history = function(...) "history",
    news_urls_from_list = function(...) "urls",
    news_max_page_num = function(...) 9,
    news_category_get = function(...) "category",
    .package = "N2H4"
  )

  testthat::expect_warning(getComment("https://example.com"), "deprecated")
  testthat::expect_warning(getCommentHistory("https://example.com", 1), "deprecated")
  testthat::expect_warning(getUrlList("https://example.com"), "deprecated")
  testthat::expect_warning(getMaxPageNum("https://example.com"), "deprecated")
  testthat::expect_warning(getCategory(), "deprecated")
})
