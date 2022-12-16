#' shapiro_wilk
#'
#' Conduct the Shapiro-Wilk test for every continuous variable in the data to test against normality
#'
#' @name shapiro_wilk
#'
#' @param data, VECTOR, LIST, DATAFRAME, MATRIX, or ARRAY where data for each continous variable is in its respective column.
#'
#' @return LIST where the first vector contains the test statistics and the second vector contains the p-values. Both are ordered same as column of input.
#'
#' @import stats
#'
#' @export shapiro_wilk
#'
#' @examples
#' iris_data <- data.frame("length" = c(1,2,3,4,5,6,7,8), "width" = c(9,10,11,12,13,14,15,16))
#' shapiro_wilk(iris_data)

library(tidyverse)

shapiro_wilk <- function(data){

  ## Preprocessing
  ## =============

  if (is.array(data)){
    if (length(dim(data)) == 1){
      var_names <- c(1)
      data <- matrix(data, ncol = 1)
    } else if (is.matrix(data)){
      var_names <- seq(ncol(data))
      data <- as.matrix(data)
    } else {
      stop("Too many dimensions in input array")
    }
  } else if (is.data.frame(data)){
    var_names <-  colnames(data)
    data <- as.matrix(data)
  } else if (is.list(data)){
    var_names <- seq(length(data))
    data <- matrix(unlist(data), ncol = length(data))
  } else if (is.vector(data)){
    var_names <- c(1)
    data <- matrix(data, ncol = 1)
  } else {
    stop("Invalid data type")
  }

  ## Exception Handling
  ## ==================
  tryCatch({
    if (all(is.na(data))){
      error
    }}, error = function(e) {
      stop("Empty data input", call. = FALSE)
    })
  tryCatch({
    if (typeof(data) != "double" & typeof(data) != "integer"){
      error
    }}, error = function(e){
      stop("Not all values in data are numeric", call. = FALSE)
    })

  # create lists to be returned
  shapiro_stats <- vector()
  p_values <- vector()

  ## Calculations
  ## =============
  ## algorithm reference: http://www.real-statistics.com/tests-normality-and-symmetry/statistical-tests-normality-symmetry/shapiro-wilk-expanded-test/

  for (index in var_names){
    x <- data[, index]
    n <- length(x)

    # cannot perform shapiro-wilk test if n<=3 or n>5000, raise
    if (n <= 3){
      stop("Must have greater than 3 observations in each dataset to calculate this statistic.", call. = FALSE)
    } else if (n > 5000){
      stop("Statistic is inaccurate when > 5000 observations. Please split data randomly.", call. = FALSE)
    }

    #### let W be the Shapiro-Wilk test statistic
    #### W = b^2/SSE

    #### step 1: sort list(x)
    y <- sort(x)

    #### step 2: calculate m[i] values using inverse CDF
    #### mi = inverse CDF of ((i − .375)/(n + .25)), i = 1 to n
    m <- vector("double", length = n)
    for (i in 1:n){
      m[i] <- qnorm((i-0.375)/(n+0.25))
    }

    #### step 3: calculate M
    M <- as.double(sum(m^2))

    #### step 4: calculate u
    u <- as.double(1/sqrt(n))

    #### step 5: calculate a[i] values
    a <- vector("double",length=n)
    a[n] <- -(2.706056*(u^5)) + (4.434685*(u^4)) - (2.071190*(u^3)) - (0.147981*(u^2)) + (0.221157*u) + (m[n]*(M^(-0.5)))
    a[n-1] <- -(3.582633*(u^5)) + (5.682633*(u^4)) - (1.752461*(u^3)) - (0.293762*(u^2)) + (0.042981*u) + (m[n-1]*(M^(-0.5)))
    a[2] <- -a[n-1]
    a[1] <- -a[n]

    e1 <- M
    e2 <- (2*(m[n]^2))
    e3 <- (2*(m[n-1]^2))
    e4 <- (2*(a[n]^2))
    e5 <- (2*(a[n-1]^2))
    e <- (e1-e2-e3)/(1-e4-e5)
    if (e < 0){
      e <- e*-1
    }
    if (n > 4){
      for (i in 3:(n-2)){
        a[i] <- m[i]/sqrt(e)
      }
    }

    #### step 6: calculate W (Shapiro-Wilk) statistic
    b <- sum(a*y)
    SSE <- sum((x-mean(x))^2)
    W <- (b^2)/SSE

    #### step 7: calculate p-value, knowing that ln(1-W) is approximately normally distirbuted
    mu <- 0.0038915*(log(n)^3) - 0.083751*(log(n)^2) - 0.31082*(log(n)) - 1.5861
    exponent <- 0.0030302*(log(n)^2) - 0.082676*(log(n)) - 0.4803
    sd <- exp(exponent)

    #### calculate z-score and p-value
    p <- 1-pnorm(log(1-W), mu, sd)

    #### append W and p to lists
    shapiro_stats[index] <- W
    p_values[index] <- p
  }

  output_list <- list(statistic = shapiro_stats, p.value = p_values)

  return (output_list)
}
