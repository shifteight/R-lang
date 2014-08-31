u <- cbind(c(1,2,3), c(1,2,4))
v <- cbind(c(8,12,20), c(15,10,2))

for (m in c("u", "v")) {
    z <- get(m)
    print(lm(z[,2] ~ z[,1]))
}
