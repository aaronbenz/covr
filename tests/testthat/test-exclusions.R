context("parse_exclusions")
test_that("it returns an empty vector if there are no exclusions", {
  t1 <- tempfile()
  on.exit(unlink(t1))
  writeLines(
    c("this",
      "is",
      "a",
      "test"), t1)
  expect_equal(parse_exclusions(t1), numeric(0))
})

test_that("it returns the line if one line is excluded", {
  t1 <- tempfile()
  on.exit(unlink(t1))
  writeLines(
    c("this",
      "is # EXCLUDE COVERAGE",
      "a",
      "test"), t1)
  expect_equal(parse_exclusions(t1), c(2))

  t2 <- tempfile()
  on.exit(unlink(t2))
  writeLines(
    c("this",
      "is # EXCLUDE COVERAGE",
      "a",
      "test # EXCLUDE COVERAGE"), t2)
  expect_equal(parse_exclusions(t2), c(2, 4))
})

test_that("it returns all lines between start and end", {
  t1 <- tempfile()
  on.exit(unlink(t1))
  writeLines(
    c("this # EXCLUDE COVERAGE START",
      "is",
      "a # EXCLUDE COVERAGE END",
      "test"), t1)
  expect_equal(parse_exclusions(t1), c(1, 2, 3))

  t2 <- tempfile()
  on.exit(unlink(t2))
  writeLines(
    c("this # EXCLUDE COVERAGE START",
      "is",
      "a # EXCLUDE COVERAGE END",
      "test",
      "of",
      "the # EXCLUDE COVERAGE START",
      "emergency # EXCLUDE COVERAGE END",
      "broadcast",
      "system"
      ), t2)
  expect_equal(parse_exclusions(t2), c(1, 2, 3, 6, 7))
})

test_that("it ignores exclude coverage lines within start and end", {
  t1 <- tempfile()
  on.exit(unlink(t1))
  writeLines(
    c("this # EXCLUDE COVERAGE START",
      "is # EXCLUDE COVERAGE",
      "a # EXCLUDE COVERAGE END",
      "test"), t1)
  expect_equal(parse_exclusions(t1), c(1, 2, 3))
})

test_that("it throws an error if start and end are unpaired", {
  t1 <- tempfile()
  on.exit(unlink(t1))
  writeLines(
    c("this # EXCLUDE COVERAGE START",
      "is # EXCLUDE COVERAGE",
      "a",
      "test"), t1)
  expect_error(parse_exclusions(t1), "but only")
})