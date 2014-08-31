mtcars$cyl.f <- factor(mtcars$cyl,
                       levels = c(4, 6, 8),
                       labels = c("4", "6", "8"))

mtcars$am.f <- factor(mtcars$am,
                      levels = c(0, 1),
                      labels = c("auto", "standard"))

boxplot(mpg ~ am.f * cyl.f,
        data = mtcars,
        varwidth = TRUE,
        col = c("gold", "darkgreen"),
        main = "MPG Distribution by Auto Type",
        xlab = "Auto Type")
