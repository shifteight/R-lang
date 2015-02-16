# A simple regression function
reg <- function(y, x) {
  x <- as.matrix(x)
  x <- cbind(Intercept=1, x)
  solve(t(x) %*% x) %*% t(x) %*% y
}

launch <- read.csv('challenger.csv')
str(launch)
reg(y=launch$distress_ct, x=launch[3])
reg(y=launch$distress_ct, x=launch[3:5])
