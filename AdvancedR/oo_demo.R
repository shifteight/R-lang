# abtain x-axis of any object
#
## defining generic
xpos <- function(x, ...)
  UseMethod('xpos')
## defining methods
xpos.xypoint <- function(x) x$x
xpos.rthetapoint <- function(x) x$r * cos(x$theta)

# UseMethod() calls methods in a special way.
y <-1
g <- function(x) {
  y <- 2
  UseMethod("g")
}
g.numeric <- function(x) y
g(10)

h <- function(x) {
  x <- 10
  UseMethod("h")
}
h.character <- function(x) paste("char", x)
h.numeric <- function(x) paste("num", x)
h("a")

# Internal generics don’t dispatch on 
# the implicit class of base types.
f <- function() 10
g <- function() 2
class(g) <- "function"

class(f)
class(g)

length.function <- function(x) "function"
length(f)
length(g)

# S4 example
library(stats4)

# From example(mle)
y <- c(26, 17, 13, 12, 20, 5, 9, 8, 5, 4, 8)
nLL <- function(lambda) - sum(dpois(y, lambda, log = TRUE))
fit <- mle(nLL, start = list(lambda = 5), nobs = length(y))

# An S4 object
isS4(fit)
otype(fit)

# An S4 generic
isS4(nobs)
ftype(nobs)

# Retrieve an S4 method
mle_nobs <- method_from_call(nobs(fit))
isS4(mle_nobs)
ftype(mle_nobs)

＃ Create S4 classes and objects
setClass("Person",
         slots = list(name = "character", age = "numeric"))
setClass("Employee",
         slots = list(boss = "Person"),
         contains = "Person")

alice <- new("Person", name = "Alice", age = 40)
john <- new("Employee", name = "John", age = 20, boss = alice)

# An S4 object inheriting from a base type
setClass("RangedNumeric",
         contains="numeric",
         slots=list(min="numeric", max="numeric"))
rn <- new("RangedNumeric", 1:10, min=1, max=10)
rn@min
rn@.Data

# Make union() work with data frames
setGeneric("union")
setMethod("union",
          c(x="data.frame", y="data.frame"),
          function(x, y) {
            unique(rbind(x, y))
          }
)

# RC classes

Account <- setRefClass("Account",
                       fields=list(balance="numeric"))
a <- Account$new(balance=100)
a$balance
a$balance <- 200
a$balance

# RC methods
Account <- setRefClass("Account",
                       fields = list(balance = "numeric"),
                       methods = list(
                         withdraw = function(x) {
                           balance <<- balance - x
                         },
                         deposit = function(x) {
                           balance <<- balance + x
                         }
                       )
)

a <- Account$new(balance = 100)
a$deposit(100)
a$balance

# inheritance using 'contains' argument
NoOverdraft <- setRefClass("NoOverdraft",
                           contains = "Account",
                           methods = list(
                             withdraw = function(x) {
                               if (balance < x) stop("Not enough money")
                               balance <<- balance - x
                             }
                           )
)
accountJohn <- NoOverdraft$new(balance = 100)
accountJohn$deposit(50)
accountJohn$balance
#> [1] 150
accountJohn$withdraw(200)
#> Error in accountJohn$withdraw(200): Not enough money
