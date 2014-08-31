boxplot(mpg ~ cyl, data=mtcars,
        notch = TRUE,
        varwidth = TRUE,
        col = "red",
        main = "Car Mileage Data",
        xlab = "Number of Cylinders",
        ylab = "Miles Per Gallon")
