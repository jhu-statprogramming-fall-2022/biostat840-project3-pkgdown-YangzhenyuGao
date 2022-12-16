#' Date: February 9, 2018
#' Authors: Constantin Shuster, Richie Zitomer, Sylvia Lee
#'
#' This script tests the function from shapiro_wilk.R
#'
#' Parameters
#' ----------
#' None
#'
#'
#' Returns
#' -------
#' Throws errors if tests fail

context("Evaluate normality using Shapiro-Wilk test")

# Sample data
data_array_1d <- array(c(41.5,38.7,44.5,43.8,46.0,39.4, 40.6, 42.7))
data_array_2d <- array(c(41.5,38.7,44.5,43.8,46.0,39.4, 40.6, 42.7, 45.6, 37.9), dim = c(5,2))
data_matrix <- matrix(c(41.5,38.7,44.5,43.8,46.0,39.4, 40.6, 42.7, 45.6, 37.9), nrow = 5, ncol = 2)
data_df <-  data.frame('data' = c(41.5,38.7,44.5,43.8,46.0,39.4, 40.6, 42.7),
                       'data2' = c(65,63,86,70,74,35,68,45))
data_list_1d<- list(c(41.5,38.7,44.5,43.8,46.0,39.4, 40.6, 42.7))
data_list_2d <- list(data_df$data, data_df$data2)
data_list_2d_named <- list("data" = data_df$data, "data2" = data_df$data2)
data_vector1 <- c(41.5,38.7,44.5,43.8,46.0,39.4, 40.6, 42.7)
data_vector2 <- c(41.5,38.7,44.5,43.8,46.0)

data_bad1 <-  data.frame('a'= c("ab", "cd", "ef", "hlp"),
                         'b'= c(TRUE, FALSE, TRUE, FALSE))
data_bad2 <- data.frame()
data_bad3 <- factor(c("female", "male", "female"))
data_array_3d <- array(c(41.5,38.7,44.5,43.8,46.0,39.4, 40.6, 42.7, 45.6, 37.9, 55.9, 77.4), dim = c(3,2,2))
data_bad4 <- c(1,2,3)
data_bad5 <- rnorm(6000, 5, 2)

is.vector(data_bad3)

#' Check that function returnes a list with all appropriate inputs
test_that("Test that output is a list", {
  expect_true(typeof(shapiro_wilk(data_array_1d)) == "list")
  expect_true(typeof(shapiro_wilk(data_array_2d)) == "list")
  expect_true(typeof(shapiro_wilk(data_matrix)) == "list")
  expect_true(typeof(shapiro_wilk(data_df)) == "list")
  expect_true(typeof(shapiro_wilk(data_list_1d)) == "list")
  expect_true(typeof(shapiro_wilk(data_list_2d)) == "list")
  expect_true(typeof(shapiro_wilk(data_list_2d_named)) == "list")
  expect_true(typeof(shapiro_wilk(data_vector1)) == "list")
  expect_true(typeof(shapiro_wilk(data_vector2)) == "list")
})

#' Check that length of list output is 2 (1 for  statistic values, other for p-values).
test_that("Test that output list is length 2", {
  stats <- shapiro_wilk(data_df)
  expect_true(length(stats) == 2)
})


#' check that the length of the first vector is as <= amount of columns in data
test_that("Test that length of first vector in output list is <= number of variables in dataframe", {
  stats_1 <- shapiro_wilk(data_df)[1]
  expect_true(length(stats_1) <= dim(data_df)[2])
})

#' check that the length of the first vector is equal to the output of the second vector
test_that("Test that both vectors in output list have the same lengths", {
  stats <- shapiro_wilk(data_df)
  expect_true(length(stats[1]) == length(stats[2]))
})

#' check that error is thrown with expression "no continuous variables to test" if dataframe doesn't have any
test_that("Test that error is thrown if input has no continuous variables", {
  expect_error(shapiro_wilk(data_bad1), "Not all values in data are numeric")
})

#' check that error is thrown for invalid data
test_that("Test that error is thrown if data input is empt", {
  expect_error(shapiro_wilk(data_bad2), "Empty data input")
  expect_error(shapiro_wilk(data_bad3), "Invalid data type")
  expect_error(shapiro_wilk(data_array_3d), "Too many dimensions in input array")

})

#' check that error is thrown for n <=3 or >5000
test_that("Test that error is thrown if data input is empty", {
  expect_error(shapiro_wilk(data_bad4), "Must have greater than 3 observations in each dataset to calculate this statistic.")
  expect_error(shapiro_wilk(data_bad5), "Statistic is inaccurate when > 5000 observations. Please split data randomly.")
})

#' check that the shapiro-wilk test statistic is correctly calculated because p-value should be > 0.05 for this test
test_that("Test that the S-W stat is properly calculated", {
  norm_values <- rnorm(100, 5, 2)
  expect_true(shapiro_wilk(norm_values)[2] > 0.05)
})
