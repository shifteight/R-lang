require(reshape)
dstats <- function(x) {
    c(n=length(x), mean=mean(x), sd=sd(x))
}
dfm <- melt(mtcars, measure.vars=c("mpg", "hp", "wt"),
            id.vars=c("am", "cyl"))
cast(dfm, am + cyl + variable ~ ., dstats)
