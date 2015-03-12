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

new_counter <- function() {
  i <- 0
  function() {
    i <<- i + 1
    i
  }
}

counter_one <- new_counter()
counter_two <- new_counter()

counter_one()
counter_one()
counter_two()

i <- 0
new_counter2 <- function() {
  i <<- i + 1
  i
}

new_counter3 <- function() {
  i <- 0
  function() {
    i <- i + 1
    i
  }
}

# compute the ith central moment of a numeric vector
moment <- function(order) {
  function(x) {
    mean((x-mean(x))^order)
  }
}

m1 <- moment(1)
m2 <- moment(2)

x <- runif(100)
stopifnot(all.equal(m1(x), 0))
stopifnot(all.equal(m2(x), var(x)*99/100))

pick <- function(i) {
  function(x) {
    x[[i]]
  }
}

compute_mean <- list(
                  base = function(x) mean(x),
                  sum = function(x) sum(x) / length(x),
                  manual = function(x) {
                    total <- 0
                    n <- length(x)
                    for (i in seq_along(x)) {
                      total <- total + x[i] / n
                    }
                    total
                  }
)
                  
x <- runif(1e5)
system.time(compute_mean$base(x))
system.time(compute_mean[[2]](x))
system.time(compute_mean[["manual"]](x))

lapply(compute_mean, function(f) f(x))

call_fun <- function(f, ...) f(...)
lapply(compute_mean, call_fun, x)

lapply(compute_mean, function(f) system.time(f(x)))

# summarise an object in multiple ways
x <- 1:10
funs <- list(
          sum = sum,
          mean = mean,
          median = median
)

lapply(funs, function(f) f(x))
lapply(funs, function(f) f(x, na.rm=TRUE))

# scale a vector to range [0,1]
scale01 <- function(x) {
  rng <- range(x, na.rm=TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

# fit linear models using different formulas
formulas <- list(
  mpg ~ disp,
  mpg ~ I(1 / disp),
  mpg ~ disp + wt,
  mpg ~ I(1 / disp) + wt
)

lapply(formulas, function(f) lm(f, data=mtcars))

# multiple inputs: Map (mapply)

# generate some sample data
xs <- replicate(5, runif(10), simplify = FALSE)
ws <- replicate(5, rpois(10, 5) + 1, simplify = FALSE)
# unweighted mean
unlist(lapply(xs, mean))
# weighted mean
unlist(Map(weighted.mean, xs, ws))

# smooth data using a rolling mean function
rollmean <- function(x, n) {
  out <- rep(NA, length(x))
  
  offset <- trunc(n / 2)
  for (i in (offset + 1):(length(x) - n + offset + 1)) {
    out[i] <- mean(x[(i - offset):(i + offset - 1)])
  }
  out
}
x <- seq(1, 3, length=1e2) + runif(1e2)
plot(x)
lines(rollmean(x, 5), col="blue", lwd=2)
lines(rollmean(x, 10), col="red", lwd=2)

# data with more variable noise, using median instead of mean
x <- seq(1, 3, length = 1e2) + rt(1e2, df = 2) / 3
plot(x)
lines(rollmean(x, 5), col = "red", lwd = 2)

rollapply <- function(x, n, f, ...) {
  offset <- trunc(n / 2)
  locs <- (offset + 1):(length(x) - n + offset + 1)
  num <- vapply(
    locs,
    function(i) f(x[(i - offset):(i + offset)], ...),
    numeric(1)
  )
  c(rep(NA, offset), num)
}
plot(x)
lines(rollapply(x, 5, median), col="red", lwd=2)
