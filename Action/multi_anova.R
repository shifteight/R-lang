library(MASS)
attach(UScereal)
y <- cbind(calories, fat, sugars)
aggregate(y, by=list(shelf), FUN=mean)
cov(y)
fit <- manova(y ~ shelf)
summary(fit)

# univariate results
summary.aov(fit)

# assess multivariate normality
center <- colMeans(y)
n <- nrow(y)
p <- ncol(y)
cov <- cov(y)
d <- mahalanobis(y, center, cov)
coord <- qqplot(qchisq(ppoints(n),df=p), d,
                main="Q-Q Plot Assessing Multivariate Normality",
                ylab="Mahalanobis D2")
abline(a=0, b=1)
identify(coord$x, coord$y, labels=row.names(UScereal))

# tests for outliers
library(mvoutlier)
outliers <- aq.plot(y)
outliers
