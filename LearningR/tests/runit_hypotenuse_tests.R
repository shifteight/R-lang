# hypotenuse test suite

test.hypotenuse.3_4.return_5 <- function() {
  expected <- 5
  actual <- hypotenuse(3, 4)
  checkEqualsNumeric(expected, actual)
}

test.hypotenuse.no_inputs.fails <- function() {
  checkException(hypotenuse())
}

test.hypotenuse.very_small_inputs.returns_small_positive <- function() {
  expected <- sqrt(2) * 1e-300
  actual <- hypotenuse(1e-300, 1e-300)
  checkEqualsNumeric(expected, actual, tolerance=1e-305)
}

test.hypotenuse.very_large_inputs.returns_large_finite <- function() {
  expected <- sqrt(2) * 1e300
  actual <- hypotenuse(1e300, 1e300)
  checkEqualsNumeric(expected, actual)
}
