par(lwd=2)  # double width of plotted lines

require(sm)
attach(mtcars)

# generate grouping factor
cyl.f <- factor(cyl, levels=c(4,6,8),
                labels=c("4 cylinder", "6 cylinder", "8 cylinder"))

# plot densities
sm.density.compare(mpg, cyl, xlab="Miles Per Gallon")
title(main="MPG Distribution by Car Cylinders")

# add legend via mouse click
colfill <- c(2:(1+length(levels(cyl.f))))
legend(locator(1), levels(cyl.f), fill=colfill)

detach(mtcars)
