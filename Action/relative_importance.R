relweights <- function(fit, ...) {
    R <- cor(fit$model)
    nvar <- ncol(R)
    rxx <- R[2:nvar, 2:nvar]
    rxy <- R[2:nvar, 1]
    svd <- eigen(rxx)
    evec <- svd$vectors
    ev <- svd$values
    delta <- diag(sqrt(ev))
    lambda <- evec %*% delta %*% t(evec)
    lambdasq <- lambda ^ 2
    beta <- solve(lambda) %*% rxy
    rsquare <- colSums(beta^2)
    rawwgt <- lambdasq %*% beta ^ 2
    import <- (rawwgt / rsquare) * 100
    lbls <- names(fit$model[2:nvar])
    rownames(import) <- lbls
    colnames(import) <- "Weights"
    barplot(t(import), names.arg=lbls,
            ylab="% of R-Square",
            xlab="Predictor Variables",
            main="Relative Importance of Predictor Variables",
            sub=paste("R-Square=", round(rsquare, digits=3)),
            ...)
    return(import)
}

fit <- lm(Murder ~ Population + Income + Illiteracy + Frost, data=states)
relweights(fit, col="lightgrey")
