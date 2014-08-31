attach(mtcars)
plot(wt, mpg, main="Mileage vs. Car Weight",
     xlab="Weight", ylab="Mileage",
     pch=18, col="blue")
text(wt, mpg, row.names(mtcars),
     cex=0.6, pos=4, col="red")
detach(mtcars)
