testthat::test_that("news_content_reporter extracts reporter from primary selector", {
  html <- xml2::read_html(testthat::test_path("fixtures", "content-reporter.html"))

  testthat::expect_equal(
    N2H4:::news_content_reporter(html),
    "홍길동"
  )
})

testthat::test_that("news_content_reporter extracts reporter from fallback selector", {
  html <- xml2::read_html(
    "<html><body><span class='byline_s'>김기자</span></body></html>"
  )

  testthat::expect_equal(
    N2H4:::news_content_reporter(html),
    "김기자"
  )
})

testthat::test_that("news_content includes reporter in default column set", {
  cols <- eval(formals(N2H4::news_content)$col)

  testthat::expect_true("reporter" %in% cols)
})
