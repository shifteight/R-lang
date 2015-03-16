# Messages

f <- function(x) {
  message("'x' contains ", toString(x))
  x
}
f(letters[1:5])

suppressMessages(f(letters[1:5]))

# Warnings

g <- function(x) {
  if (any(x < 0)) {
    warning("'x' contains negative values: ", toString(x[x < 0]))
  }
  x
}
g(c(3, -7, 2, -9))  # 'warn' option is off (set to -1) in RStudio

generate_n_warnings <- function(n) {
  for (i in seq_len(n)) {
    warning("This is warning ", i)
  }
}
generate_n_warnings(3)
generate_n_warnings(11)

# Errors
h <- function(x, na.rm=FALSE) {
  if (!na.rm && any(is.na(x))) {
    stop("'x' has missing values.")
  }
  x
}
h(c(1, NA))

h2 <- function(x, na.rm=FALSE) {
  if (!na.rm) {
    stopifnot(!any(is.na(x)))
  }
  x
}
h2(c(1, NA))

## a more extensive set of human-friendly tests
library(assertive)
h3 <- function(x, na.rm=FALSE) {
  if (!na.rm) {
    assert_all_are_not_na(x)
  }
  x
}
h3(c(1, NA))

# Error handling

to_convert <- list(
  first = sapply(letters[1:5], charToRaw),
  second = polyroot(c(1, 0, 0, 0, 1)),
  third = list(x = 1:2, y = 3:5))
result <- try(lapply(to_convert, as.data.frame))
if (inherits(result, "try-error")) {
  # special error handling code
} else {
  # code for normal execution
}

## a more concise way:
tryCatch(
  lapply(to_convert, as.data.frame),
  error = function(e) {
    message("An error was thrown: ", e$message)
    data.frame()
  })

## when looping over items, keep the results that worked
lapply(
  to_convert,
  function(x) {
    tryCatch(
      as.data.frame(x),
      error = function(e) NULL
    )
  }
)

## plyr::tryapply provides a cleaner way:
plyr::tryapply(to_convert, as.data.frame)

# Debugging
outer_fn <- function(x) inner_fn(x)
inner_fn <- function(x) {
  #browser()  # execution pauses here
  exp(x)
}
outer_fn(list(1))

## using 'error' option
### example:
oh_dear <- function() message("Oh dear!")
old_ops <- options(error=oh_dear)
stop('I wll break your program!')
options(old_ops)

### use:
old_ops <- options(error=recover)
outer_fn(list(1))
options(old_ops)

## using 'debug' function
library(learningr)
debug(buggy_count)
x <- factor(sample(c('male', 'female'), 20, replace=TRUE))
buggy_count(x)
undebug(buggy_count)

# Testing

## RUnit
library(RUnit)
test_dir <- system.file("tests", package='learningr')
suite <- defineTestSuite("hypotenuse suite", test_dir)
runTestSuite(suite)

## testthat
library(testthat)
filename <- system.file('tests', 'testthat_hypotenuse_tests.R',
                        package='learningr')
test_file(filename)

# OO Programming

## S3

## Ref Classes

## class generator template
my_class_generator <- setRefClass(
                        "MyClass",
                        fields = list(
                          # data variables
                          ),
                        methods = list(
                          # functions to operate on that data
                          initialize = function(...) {
                            # called when an object is created
                          }
                          )
                        )
## build a class for 2D points
point_generator <- setRefClass(
                        "point",
                        fields = list(
                          # data variables
                          x = "numeric",
                          y = "numeric"
                        ),
                        methods = list(
                          initialize = function(x=NA_real_, y=NA_real_) {
                            "Assign x and y upon object creation."
                            x <<- x
                            y <<- y
                          },
                          distanceFromOrigin = function() {
                            "Euclidean distance from the origin"
                            sqrt(x ^ 2 + y ^ 2)
                          },
                          add = function(point) {
                            "Add another point to this point"
                            x <<- x + point$x
                            y <<- y + point$y
                            .self
                          }
                        )
)

## create objects
(a_point <- point_generator$new(5, 3))

## return help string
point_generator$help("initialize")

## wrapping class methods, providing a more traditional interface
create_point <- function(x, y) {
  point_generator$new(x, y)
}

a_point <- create_point(3, 4)
a_point$distanceFromOrigin()

another_point <- create_point(4, 2)
a_point$add(another_point)

## list the fields and methods of the class
point_generator$fields()
point_generator$methods()

## inheritance
three_d_point_generator <- setRefClass(
                             "three_d_point",
                             fields = list(
                               z = "numeric"
                             ),
                             contains = "point",
                             methods = list(
                               initialize = function(x, y, z) {
                                 "Assign x, y, z upon object creation."
                                 x <<- x
                                 y <<- y
                                 z <<- z
                               },
                               distanceFromOrigin = function() {
                                 "Euclidean distance from the origin"
                                 sqrt(x ^ 2 + y ^ 2 + z ^ 2)
                               }
                             )
)                             
a_three_d_point <- three_d_point_generator$new(3, 4, 5)
a_three_d_point$distanceFromOrigin()
