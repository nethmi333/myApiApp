test_that("get_nobel_laureates returns correct structure", {
  res <- get_nobel_laureates(category = "che", year = "2020")

  expect_s3_class(res, "data.frame")
  expect_true(all(c("Name", "Gender", "Category", "Year", "Motivation") %in% names(res)))
  expect_equal(res$Year[1], 2020)
})
