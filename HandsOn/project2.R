# make a deck
deck <- read.csv('deck.csv', stringsAsFactors=FALSE)


random <- sample(1:52, size=52)
deck4 <- deck[random,]
head(deck4)
