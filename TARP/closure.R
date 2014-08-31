w <- 12
f <- function(y) {
    d <- 8
    h <- function() {
        return(d*(w+y))
    }
    print(environment(h))
    return(h())
}

g <- function(y, ftn) {
    d <- 8
    print(environment(ftn))
    return(ftn(d,y))
}

h <- function(dee, yyy) {
    return(dee*(w+yyy))
}

