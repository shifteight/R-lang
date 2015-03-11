summary <- function(x) {
  funs <- c(mean, median, sd, mad, IQR)
  lapply(funs, function(f) f(x, na.rm=TRUE))
}

# closures

power <- function(exponent) {
  print(environment())
  function(x) {
    x ^ exponent
  }
}

square <- power(2)
environment(square)
cube <- power(3)
