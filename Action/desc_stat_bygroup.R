vars <- c("mpg", "hp", "wt")
dstats <- function(x) {
    mean = sapply(x, mean)
    sd = sapply(x, sd)
    c(mean=mean, sd=sd)
}
by(mtcars[vars], mtcars$am, dstats)
