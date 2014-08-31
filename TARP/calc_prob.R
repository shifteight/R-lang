# calculates the probability of exactly one of n events occurring
# given probabilities of each events occurring
exactlyone <- function(p) {
    notp <- 1 - p
    tot <- 0.0
    for (i in 1:length(p))
        tot <- tot + p[i] * prod(notp[-i])
    return(tot)
}
