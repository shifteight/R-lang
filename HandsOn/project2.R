# make a deck
# deck <- read.csv('deck.csv', stringsAsFactors=FALSE)

<<<<<<< HEAD
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
=======
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
>>>>>>> FETCH_HEAD
