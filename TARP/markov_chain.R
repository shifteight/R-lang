findpi1 <- function(p) {
  n <- nrow(p)
  imp <- diag(n) - t(p)
  imp[n,] <- rep(1,n)
  rhs <- c(rep(0,n-1),1)
  pivec <- solve(imp,rhs)
  return(pivec)
}

findpi2 <- function(p) {
  n <- nrow(p)
  # find first eigenvector of P transpose
  pivec <- eigen(t(p))$vectors[,1]
  # guaranteed to be real, but could be negative
  if (pivec[1] < 0) pivec <- -pivec
  # normalize to sum to 1
  pivec <- pivec / sum(pivec)
  return(pivec)
}
