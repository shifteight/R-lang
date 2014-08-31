mystats <- function(x, parametric=TRUE, print=FALSE) {
    if (parametric) {
        center <- mean(x); spread <- sd(x)
    } else {
        center <- median(x); spread <- mad(x)
    }
    if (print & parametric) {
        cat("Mean=", center, "\n", "SD=", spread, "\n")
    } else if (print & !parametric) {
        cat("Median=", center, "\n", "\bMAD=", spread, "\n")
    }
    result <- list(center=center, spread=spread)
    return(result)
}

mydate <- function(type="long") {
    switch(type,
           long = format(Sys.time(), "%A %B %d %Y"),
           short = format(Sys.time(), "%m-%d-%y"),
           cat(type, "is not a recognized type\n")
           )
}
