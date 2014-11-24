# make a deck
deck <- read.csv('deck.csv', stringsAsFactors=FALSE)

# deal
deal <- function(cards) {
    cards[1,]
}

# shuffle decks
shuffle <- function(cards) {
  random <- sample(1:52, size=52)
  cards[random,]
}

show_env <- function() {
    a <- 1
    b <- 2
    c <- 3
    list(ran.in=environment(),
         parent=parent.env(environment()),
         objects=ls.str(environment()))
}
