print.employee <- function(wrkr) {
    cat(wrkr$name, "\n")
    cat("salary", wrkr$salary, "\n")
    cat("union member", wrkr$union, "\n")
}

## test:
j <- list(name="Joe", salary=55000, union=T)
class(j) <- "employee"
j
## Joe 
## salary 55000 
## union member TRUE

## inheritance:
k <- list(name="Kate", salary=68000, union=F, hrsthismonth=2)
class(k) <- c("hrlyemployee", "employee")
k
