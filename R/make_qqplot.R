#' make_qqplot
#'
#' Create QQ-plot for each continuous variable in the data
#'
#' @name make_qqplot
#'
#' @param data, VECTOR, LIST, DATAFRAME, MATRIX, or ARRAY where data for each continous variable is in its respective column
#'
#' @return List of plots where the list names are the column names (or index)
#'
#' @import stats ggplot2
#'
#' @export make_qqplot
#'
#' @examples
#' iris_data <- data.frame("length" = c(1,2,3,4), "width" = c(5,6,7,8))
#' make_qqplot(iris_data)

library(ggplot2)
library(stats)

make_single_qqplot <- function(column) {
  x <- quantile(rnorm(1000),probs=seq(0, 1, 1/20),names=FALSE) # Get a thousand observations for a theoretical dist

  y <- quantile(column,probs=seq(0, 1, 1/20),names=FALSE, na.rm=TRUE)

  tryCatch({
    if(sum(is.na(y))==length(y)){
      error
    }}, error = function(e) {
      stop('Empty column or dataset passed')
    }
  )


  to_plot <- data.frame('Theoretical'=x, 'Actual'=y)
  ggplot(to_plot,aes(x,y)) +
    geom_point() +
    labs(title="Q-Q Plot") +
    xlab("Theoretical") +
    ylab("Actual")
}

make_qqplot <- function(data){
  tryCatch({
    # Handle non-numeric
    if (class(data) == 'numeric') {
      make_single_qqplot(data)
    } else if (class(data) %in% c('list','data.frame')) {
      lapply(data,make_single_qqplot)
    } else if (class(data) == 'matrix') {
      apply(data,2,make_single_qqplot)
    }
    else {
      error
    }
  }, error = function(e) {
    stop('Type Error')
  })
}
