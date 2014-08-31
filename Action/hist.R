par(mfrow=c(2,2))

# simple histogram
hist(mtcars$mpg)

# with specified bins and color
hist(mtcars$mpg, breaks=12, col="red",
     xlab="Miles Per Gallon",
     main="Colored histogram with 12 bins")

# with rug plot and frame
hist(mtcars$mpg, freq=FALSE, breaks=12, col="red",
     xlab="Miles Per Gallon",
     main="Histogram, rug plot, density curve")
rug(jitter(mtcars$mpg))
lines(density(mtcars$mpg), col="blue", lwd=2)

# with normal curve
x <- mtcars$mpg
h <- hist(x, breaks=12, col="red",
          xlab="Miles Per Gallon",
          main="Histogram with normal curve and box")
xfit <- seq(min(x), max(x), length=40)
yfit <- dnorm(xfit, mean=mean(x), sd=sd(x))
yfit <- yfit*diff(h$mids[1:2])*length(x)
lines(xfit, yfit, col="blue", lwd=2)
box()
