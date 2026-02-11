testthat::test_that("news_cache_enabled parses truthy and falsy values", {
  old <- Sys.getenv("N2H4_CACHE", unset = NA_character_)
  on.exit({
    if (is.na(old)) {
      Sys.unsetenv("N2H4_CACHE")
    } else {
      Sys.setenv(N2H4_CACHE = old)
    }
  }, add = TRUE)

  Sys.setenv(N2H4_CACHE = "true")
  testthat::expect_true(N2H4:::news_cache_enabled())

  Sys.setenv(N2H4_CACHE = "false")
  testthat::expect_false(N2H4:::news_cache_enabled())
})

testthat::test_that("news_cache_enabled warns on invalid values", {
  old <- Sys.getenv("N2H4_CACHE", unset = NA_character_)
  on.exit({
    if (is.na(old)) {
      Sys.unsetenv("N2H4_CACHE")
    } else {
      Sys.setenv(N2H4_CACHE = old)
    }
  }, add = TRUE)

  Sys.setenv(N2H4_CACHE = "wat")
  testthat::expect_warning(
    testthat::expect_false(N2H4:::news_cache_enabled(default = FALSE)),
    "Invalid N2H4_CACHE"
  )
})

testthat::test_that("news_category_get bypasses cache when N2H4_CACHE is false", {
  old <- Sys.getenv("N2H4_CACHE", unset = NA_character_)
  on.exit({
    if (is.na(old)) {
      Sys.unsetenv("N2H4_CACHE")
    } else {
      Sys.setenv(N2H4_CACHE = old)
    }
  }, add = TRUE)

  Sys.setenv(N2H4_CACHE = "false")

  testthat::local_mocked_bindings(
    getMainCategory = function() {
      tibble::tibble(cate_name = "정치", sid1 = "100")
    },
    getSubCategory = function(sid1 = 100) {
      tibble::tibble(sub_cate_name = "정치일반", sid2 = "264")
    },
    .package = "N2H4"
  )

  out <- N2H4::news_category_get(fresh = FALSE)

  testthat::expect_s3_class(out, "tbl_df")
  testthat::expect_equal(out$cate_name, "정치")
  testthat::expect_equal(out$sid2, "264")
})
