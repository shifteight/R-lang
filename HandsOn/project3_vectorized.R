# A slot machine game - vectorized version

get_many_symbols <- function(n) {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  vec <- sample(wheel, size=3*n, replace=TRUE,
         prob=c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
  matrix(vec, ncol=3)
}

play_many <- function(n) {
  symb_mat <- get_many_symbols(n=n)
  data.frame(w1=symb_mat[,1], w2=symb_mat[,2],
             w3=symb_mat[,3], prize=score_many(symb_mat))
}

# symbols should be a matrix with a column for each slot machine window
score_many <- function(symbols) {

    # step 1: assign base prize based on cherries and diamonds
    ## count the number of cherries and diamonds in each combination
    diamonds <- rowSums(symbols == 'DD')
    cherries <- rowSums(symbols == 'C')

    ## wild diamonds count as cherries
    prize <- c(0, 2, 5)[cherries + diamonds + 1]

    ## ...but not if there are zero real cherries
    ### (cherries is coerced to FALSE where cherries==0)
    prize[!cherries] <- 0

    # step 2: change prize for combinations that contain three of a kind
    same <- symbols[,1] == symbols[, 2] &
        symbols[,2] == symbols[,3]
    payoffs <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
                 "B" = 10, "C" = 10, "0" = 0)
    prize[same] <- payoffs[symbols[same, 1]]

    # step 3: change prize for combinations that contain all bars
    bars <- symbols == 'B' | symbols == 'BB' | symbols == 'BBB'
    all_bars <- bars[,1] & bars[,2] & bars[,3] & !same
    prize[all_bars] <- 5

    # step 4: handle wilds

    ## combos with two diamonds
    two_wilds <- diamonds == 2

    ### indentify the nonwild symbol
    one <- two_wilds & symbols[,1] != symbols[,2] &
        symbols[,2] == symbols[,3]
    two <- two_wilds & symbols[,1] != symbols[,2] &
        symbols[,1] == symbols[,3]
    three <- two_wilds & symbols[,1] == symbols[,2] &
        symbols[,2] != symbols[,3]

    ### treat as three of a kind
    prize[one] <- payoffs[symbols[one, 1]]
    prize[two] <- payoffs[symbols[two, 2]]
    prize[three] <- payoffs[symbols[three, 3]]

    ## combos with one wild
    one_wild <- diamonds == 1

    ### treat as all bars (if appropriate)
    wild_bars <- one_wild & (rowSums(bars) == 2)
    prize[wild_bars] <- 5

    ## treat as three of a kind (if appropriate)
    one <- one_wild & symbols[,1] == symbols[,2]
    two <- one_wild & symbols[,2] == symbols[,3]
    three <- one_wild & symbols[,3] == symbols[,1]
    prize[one] <- payoffs[symbols[one, 1]]
    prize[two] <- payoffs[symbols[two, 2]]
    prize[three] <- payoffs[symbols[three, 3]]

    # step 5: double prize for every diamond in combo
    unname(prize * 2 ^ diamonds)
}
