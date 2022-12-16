library(ggplot2)
# This script tests the make_qqplot function

context("Test make_qqplot")

# Sample data
data <-  data.frame('a'=c(1,2,3),'b'=c(4,5,6))
data_v <- c(1,2,3)
data_matrix <- matrix(c(1,2,3,99,9,8,7,3,2,11,12,13), nrow = 4, ncol = 3, byrow = TRUE,
                      dimnames = list(c("r1", "r2","r3","r4"),
                                      c("C.1", "C.2", "C.3")))

#' Check that function returns a list
test_that("Test that output is a list", {

  plots <- make_qqplot(data)

  expect_true(typeof(plots)=="list")
})

#' Check that function fails with non-numeric data
test_that("Test that function fails with non-numeric data", {
  expect_error(make_qqplot('abcd'))
})

#'Check that passing an empty dataset fails
test_that("Test that passing an empty dataset fails", {
  expect_error(make_qqplot(matrix()))
})

#'Check that length of list <= # of continuous vars in a dataframe.
test_that("Test that output is <= number of continuous variables", {

  plots <- make_qqplot(data)

  expect_true(length(plots)<=dim(data)[2])
})

#'Check that length of list <= # of continuous vars in a matrix
test_that("Test that output is <= number of continuous variables for a matrix", {

  plots <- make_qqplot(data_matrix)

  expect_true(length(plots)<=dim(data_matrix)[2])
})

#'Check that length of list <= # of continuous vars in a dataframe.
test_that("Test that vector input returns a plot", {

  plots <- make_qqplot(data_v)

  expect_true("ggplot" %in% class(plots))
})


#'Check that each element is a plot
test_that("Test that each element is a plot", {

  plots <- make_qqplot(data)

  for (plt in plots) {
    expect_is(plt,"ggplot")
  }
})


#'Check that the element names of the list are the name of the columns
test_that("Test that list names are the names of the columns", {

  plots <- make_qqplot(data)

  for (column_name in names(plots)){
    expect_true(column_name %in% colnames(data))
  }
})

