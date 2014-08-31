w <- 12
f <- function(y) {
    d <- 8
    w <- w + 1
    y <- y - 2
    print(w)
    h <- function() {
        return(d * (w+y))
    }
    return(h())
}
