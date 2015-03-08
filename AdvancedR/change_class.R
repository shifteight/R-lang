# create a linear model
mod <- lm(log(mpg) ~ log(disp), data=mtcars)
class(mod)
print(mod)

# turn it into a data frame
class(mod) <- "data.frame"
print(mod)
