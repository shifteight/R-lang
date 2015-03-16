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

# parallelisation of lapply()
lapply3 <- function(x, f, ...) {
  out <- vector("list", length(x))
  for (i in sample(seq_along(x))) {
    out[[i]] <- f(x[[i]], ...)
  }
  out
}
unlist(lapply(1:10, sqrt))
unlist(lapply3(1:10, sqrt))

library(parallel)
# this example is actually slower than lapply
unlist(mclapply(1:10, sqrt, mc.cores=4))
# a more realistic example: boostrap replicates of a linear model
boot_df <- function(x) x[sample(nrow(x), rep=T), ]
rsquared <- function(mod) summary(mod)$r.square
boot_lm <- function(i) {
  rsquared(lm(mpg ~ wt + disp, data=boot_df(mtcars)))
}
system.time(lapply(1:500, boot_lm))
system.time(mclapply(1:500, boot_lm, mc.cores=2))

# apply() for matrix or array
a <- matrix(1:20, nrow=5)
apply(a, 1, mean)

## apply() is not idempotent!
a1 <- apply(a, 1, identity)
identical(a, a1)     # FALSE
identical(a, t(a1))  # TRUE
a2 <- apply(a, 2, identity)
identical(a, a2)     # TRUE

## sweep(), used with apply, to standardize arrays
x <- matrix(rnorm(20, 0, 10), nrow=4)
x1 <- sweep(x, 1, apply(x, 1, min), `-`)
x2 <- sweep(x1, 1, apply(x1, 1, max), `/`)

## outer()
## create a time table
outer(1:3, 1:10, "*")

## sapply() allows for "ragged" arrays
## Example: compare two groups in a medical trial
pulse <- round(rnorm(22, 70, 10/3)) + rep(c(0,5), c(10,12))
group <- rep(c('A', 'B'), c(10,12))
tapply(pulse, group, length)
tapply(pulse, group, mean)
## tapply() is just the combination of split() and sapply()
tapply2 <- function(x, group, f, ..., simplify=TRUE) {
  pieces <- split(x, group)
  sapply(pieces, f, simplify=simplify)
}
tapply2(pulse, group, length)
tapply2(pulse, group, mean)

# manipulating lists
# Reduce()
Reduce2 <- function(f, x) {
  out <- x[[1]]
  for (i in seq(2, length(x))) {
    out <- f(out, x[[i]])
  }
  out
}

## find the values that occur in every element of a list of vectors
l <- replicate(5, sample(1:10, 15, replace=T), simplify=FALSE)
str(l)
Reduce(intersect, l)

# predicate functionals
where <- function(f, x) {
  vapply(x, f, logical(1))
}
df <- data.frame(x=1:3, y=c('a','b','c'))
where(is.factor, df)
str(Filter(is.factor, df))
str(Find(is.factor, df))
Position(is.factor, df)

# mathematical functionals
integrate(sin, 0, pi)
str(uniroot(sin, pi * c(1/2, 3/2)))
str(optimise(sin, c(0, 2*pi)))
str(optimise(sin, c(0, pi), maximum=TRUE))

# In statistics, optimisation, combined with closures, is often used
# for solving MLE problems.
# ---------------------------
# 
## a function factory that, given a dataset, returns a function that
## computes the negative log likelihood (NLL) for parameter lambda.
poisson_nll <- function(x) {
  n <- length(x)
  sum_x <- sum(x)
  function(lambda) {
    n * lambda - sum_x * log(lambda) # + terms not involving lambda
  }
}

x1 <- c(41, 30, 31, 38, 29, 24, 30, 29, 31, 38)
x2 <- c(6, 4, 7, 3, 3, 7, 5, 2, 2, 7, 5, 4, 12, 6, 9)
nll1 <- poisson_nll(x1)
nll2 <- poisson_nll(x2)
optimise(nll1, c(0,100))$minimum
optimise(nll2, c(0,100))$minimum

# function operators
# ------------------

chatty <- function(f) {
  function(x, ...) {
    res <- f(x, ...)
    cat("Processing ", x, "\n", sep="")
    res
  }
}
f <- function(x) x^2
s <- c(3,2,1)
chatty(f)(1)
vapply(s, chatty(f), numeric(1))
