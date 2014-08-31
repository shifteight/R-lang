attach(mtcars)
opar <- par(no.readonly=TRUE)

# Set up scatter plot
par(fig=c(0, 0.8, 0, 0.8))
plot(wt, mpg, xlab="Miles Per Gallon", ylab="Car Weight")

# Add box plot above
par(fig=c(0, 0.8, 0.55, 1), new=TRUE)
boxplot(wt, horizontal=TRUE, axes=FALSE)

# Add box plot to right
par(fig=c(0.65, 1, 0, 0.8), new=TRUE)
boxplot(mpg, axes=FALSE)

mtext("Enhanced Scatterplot" side=3, outer=TRUE, line=-3)

par(opar)
detach(mtcars)
