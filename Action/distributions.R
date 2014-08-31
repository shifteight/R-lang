x <- pretty(c(-3, 3), 30)
y <- dnorm(x)
plot(x, y,
     type = "l",
     xlab = "Normal Deviate",
     ylab = "Density",
     yaxs = "i"
)

# generate multivariate normal distribution
library(MASS)
options(digits=3)

# set a seed to reproduce the results
set.seed(1234)

# specify mean vector, covariance matrix
mean <- c(230.7, 146.7, 3.6)
sigma <- matrix(c(15360.8, 6721.2, -47.1,
                   6721.2, 4700.9, -16.5,
                    -47.1,  -16.5,   0.3), nrow=3, ncol=3)

# generate data
mydata <- mvrnorm(500, mean, sigma)
mydata <- as.data.frame(mydata)
names(mydata) <- c("y", "x1", "x2")

# view results
dim(mydata)  # 500 3
head(mydata, n=10)
