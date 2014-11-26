# A slot machine game

get_symbols <- function() {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  sample(wheel, size=3, replace=TRUE,
         prob=c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}

play <- function() {
  symbols <- get_symbols()
  structure(score(symbols), symbols=symbols, class="slots")
}

score <- function(symbols) {

  diamonds <- sum(symbols == 'DD')
  cherries <- sum(symbols == 'C')
  
  # identify case
  # since diamonds are wild, only nondiamonds
  # matter for three of a kind and all bars
  slots <- symbols[symbols != 'DD']
  same <- length(unique(slots)) == 1
  bars <- slots %in% c("B", "BB", "BBB")

  # assign prize
  if (diamonds == 3) {
    prize <- 100
  } else if (same) {
    payouts <- c("7" = 80, "BBB" = 40, "BB" = 25,
                 "B" = 10, "C" = 10, "0" = 0)
    prize <- unname(payouts[slots[1]])
  } else if (all(bars)) {
    prize <- 5
  } else if (cherries > 0) {
    # diamonds count as cherries
    # so long as there is one real cherry
    prize <- c(0, 2, 5)[cherries + diamonds + 1]
  } else {
    prize <- 0
  }

  # double for each diamond
  prize * 2 ^ diamonds
}

slot_display <- function(prize) {

  # extract symbols
  symbols <- attr(prize, "symbols")

  # collapse symbols into single string
  symbols <- paste(symbols, collapse=" ")

  # combine symbol with prize as a regular expression
  # \n is regular expression for new line (i.e. return or enter)
  string <- paste(symbols, prize, sep = "\n$")

  # display regular expression in console without quotes
  cat(string)
}

print.slots <- function(x, ...) {
  slot_display(x)
}

# calculate payout rate (expected prize value) of the slot machine

wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")

combos <- expand.grid(wheel, wheel, wheel, stringsAsFactors=FALSE)

prob <- c("DD" = 0.03, "7" = 0.03, "BBB" = 0.06,
          "BB" = 0.1, "B" = 0.25, "C" = 0.01, "0" = 0.52)

combos$prob1 <- prob[combos$Var1]
combos$prob2 <- prob[combos$Var2]
combos$prob3 <- prob[combos$Var3]

combos$prob <- combos$prob1 * combos$prob2 * combos$prob3

combos$prize <- NA
for (i in 1:nrow(combos)) {
  symbols <- c(combos[i,1], combos[i,2], combos[i,3])
  combos$prize[i] <- score(symbols)
}

sum(combos$prize * combos$prob)

plays_till_broke <- function(start_with) {
  cash <- start_with
  n <- 0
  while (cash > 0) {
    cash <- cash - 1 + play()
    n <- n + 1
  }
  n
}
