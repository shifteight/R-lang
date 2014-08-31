fit <- lm(mpg ~ hp + wt + hp:wt, data=mtcars)
require(effects)
plot(effect("hp:wt", fit, list(wt=c(2.2, 3.2, 4.2))), multiline=TRUE)
