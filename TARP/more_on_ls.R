f <- function(y) {
    d <- 8
    return(h(d,y))
}

h <- function(dee,yyy) {
    print(ls())
    print(ls(envir=parent.frame(n=1)))
    return(dee*(w+yyy))
}

w <- 12
f(2)
