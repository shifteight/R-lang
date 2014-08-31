# returns the minimum value of d[i,j], i!=j, and the row/col attaining
# that minimum, for square symmetric matrix d; no special policy on ties
mind <- function(d) {
  n <- nrow(d)
  # add a column to identify row number for apply()
  dd <- cbind(d, 1:n)
  wmins <- apply(dd[-n,], 1, imin)
  i <- which.min(wmins[2,])
  j <- wmins[1,i]
  return(c(d[i,j],i,j))
}

# finds the location, value of minimum in a row x
imin <- function(x) {
  lx <- length(x)
  i <- x[lx]    # original row number
  j <- which.min(x[(i+1):(lx-1)])
  k <- i+j
  return(c(k, x[k]))
}

# testing

# creates distance matrix
y <- c(12,13,8,20,15,28,88,6,9,33.01)
z <- diag(0, 5)
z[lower.tri(z)] <- y
z[upper.tri(z)] <- t(z)[upper.tri(t(z))]

mind(z)

# alternative method
min_value_index <- function(d) {
  y <- d[row(d)!=col(d)]  # excludes diagonal zero
  min_value <- min(y)
  index <- which(d==min_value, arr.ind=TRUE)
  return(c(min_value, index[1,]))
}

# general function for creating N-dim symmetric matrix with diagonal zeros
sym <- function(n) {
  n1 <- n * (n - 1) / 2
  y <- matrix(rnorm(n1))
  z <- diag(0, n)
  z[lower.tri(z)] <- y
  z[upper.tri(z)] <- t(z)[upper.tri(t(z))]
  
  return(z)
}

# testing
#z <- sym(1000)
#system.time(min_value_index(z))
#system.time(mind(z))
