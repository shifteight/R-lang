# Simulating fake data
x_1 <- rnorm(1000,5,7)
x_2 <- rgamma(1000,2)

#hist(x_1, col="grey")
true_error <- rnorm(1000,0,2)
true_beta_0 <- 1.1
true_beta_1 <- -8.2
true_beta_2 <- 2.3
y <- true_beta_0 + true_beta_1 * x_1 + true_beta_2 * x_2 + true_error
hist(y)
#plot(x_1, y, pch=20, col="red")

m1 <- lm(y~x_1)


