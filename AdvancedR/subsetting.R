diagonal <- function(x) {
  # return diagonal elements of a matrix, like diag()
  # assuming input a matrix without check
  return (x[row(x) == col(x)])
}
