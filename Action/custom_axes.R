# Specify data
x <- c(1:10)
y <- x
z <- 10/x

opar <- par(no.readonly=TRUE)

# Increase margins
par(mar=c(5, 4, 4, 8) + 0.1)

# Plot x versus y
plot(x, y, type="b", pch=21, col="red",
     yaxt="n", lty=3, ann=FALSE)

# Add x versus 10/x line
lines(x, z, type="b", pch=22, col="blue", lty=2)

# Draw your axes
axis(2, at=x, labels=x, col.axis="red", las=2)
axis(4, at=z, labels=round(z, digits=2),
     col.axis="blue", las=2, cex.axis=0.7, tck=-.01)

# Add titles and text
mtext("y=10/x", side=4, line=3, cex.lab=1, las=2, col="blue")
title("An example of creative axes", xlab="X vlaues", ylab="Y=X")

par(opar)
