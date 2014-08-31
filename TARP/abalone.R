aba <- read.csv("abalone.data", header=TRUE, as.is=TRUE)
pchvec <- ifelse(aba$Gender == "M", "o", "x")
plot(aba$Length, aba$Diameter, pch=pchvec)
