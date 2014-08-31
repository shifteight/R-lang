par(mfrow = c(2,1))
d <- density(mtcars$mpg)

plot(d, main="Kernel Density of MPG")
polygon(d, col="red", border="blue")
rug(mtcars$mpg, col="brown")
