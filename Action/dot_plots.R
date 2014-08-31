par(mfrow=c(1,2))

dotchart(mtcars$mpg, labels=row.names(mtcars), cex=.7,
         main="Gas Mileage for Car Models", xlab="Mile Per Gallon")

x <- mtcars[order(mtcars$mpg),]
x$cyl <- factor(x$cyl)
x$color[x$cyl==4] <- "red"
x$color[x$cyl==6] <- "blue"
x$color[x$cyl==8] <- "darkgreen"

dotchart(x$mpg,
         labels = row.names(x),
         cex = .7,
         groups = x$cyl,
         gcolor = "black",
         color = x$color,
         pch = 19,
         main = "Gas Mileage for Car Models\ngrouped by cylinder",
         xlab = "Miles Per Gallon")
