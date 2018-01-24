require(HSAUR3)
str(Forbes2000)

companies <- Forbes2000$name

# the three companies with the lowest sales
order_sales <- order(Forbes2000$sales)
companies[order_sales[1:3]]

# the three top sellers
Forbes2000[order_sales[c(2000, 1999, 1998)],
           c("name", "sales", "profits", "assets")]

# the companies with assets of more than 1000 billion US dollars
Forbes2000[Forbes2000$assets > 1000,
           c("name", "sales", "profits", "assets")]

# the observations with profit information missing
na_profits <- is.na(Forbes2000$profits)
Forbes2000[na_profits, c("name", "sales", "profits", "assets")]
