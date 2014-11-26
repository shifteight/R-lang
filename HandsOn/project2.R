# make a deck
# deck <- read.csv('deck.csv', stringsAsFactors=FALSE)

# A self-contained card game

setup <- function(deck) {
  DECK <- deck

  DEAL <- function() {
    card <- deck[1,]
    assign('deck', deck[-1,], envir=parent.env(environment()))
    card
  }
  
  SHUFFLE <- function() {
    random <- sample(1:52, size=52)
    assign('deck', DECK[random,], envir=parent.env(environment()))
  }

  list(deal = DEAL, shuffle = SHUFFLE)
}

cards <- setup(deck)
deal <- cards$deal
shuffle <- cards$shuffle

