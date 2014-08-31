# finds expected value of the maximum of two independent normal variables.
sum <- 0
nreps <- 100000
for (i in 1:nreps) {
  xy <- rnorm(2)  # generates 2 N(0,1)s
  sum <- sum + max(xy)
}
print(sum/nreps)

# more compactly
emax <- function(nreps) {
  x <- rnorm(2*nreps)
  maxxy <- pmax(x[1:nreps], x[(nreps+1):(2*nreps)])
  return(mean(maxxy))
}
