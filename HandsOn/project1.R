# simulate rolling a pair of dice
roll <- function() {
  die <- 1:6
  dice <- sample(die, size=2, replace=TRUE,
                 prob=c(1/8, 1/8, 1/8, 1/8, 1/8, 3/8))
  sum(dice)
}

roll2 <- function(bones=1:6) {
  dice <- sample(bones, size=2, replace=TRUE)
  sum(dice)
}

require(ggplot2)
rolls <- replicate(10000, roll())
qplot(rolls, binwidth=1)
