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
table(Forbes2000$assets > 1000)
Forbes2000[Forbes2000$assets > 1000,
           c("name", "sales", "profits", "assets")]

# the observations with profit information missing
na_profits <- is.na(Forbes2000$profits)
Forbes2000[na_profits, c("name", "sales", "profits", "assets")]

table(complete.cases(Forbes2000))

UKcomp <- subset(Forbes2000, country=="United Kingdom")
dim(UKcomp)

#--------------------
# Computing with data
#--------------------

summary(Forbes2000)
lapply(Forbes2000, summary)

mprofits <- tapply(Forbes2000$profits,
                   Forbes2000$category, median, na.rm=TRUE)
rev(sort(mprofits))[1:3]


#---------------------
# Customizing analyses
#---------------------

iqr <- function(x, ...) {
  q <- quantile(x, probs = c(0.25, 0.75), names = FALSE, ...)
  return(diff(q))
}
xdata <- rnorm(100)
iqr(xdata, na.rm=TRUE)
IQR(xdata, na.rm=TRUE)
iqr(Forbes2000$profits, na.rm=TRUE)

iqr_profits <- tapply(Forbes2000$profits, 
                      Forbes2000$category, iqr, na.rm=TRUE)

levels(Forbes2000$category)[which.min(iqr_profits)]
levels(Forbes2000$category)[which.max(iqr_profits)]

# using a for-loop
bcat <- Forbes2000$category
iqr_profits2 <- numeric(nlevels(bcat))
names(iqr_profits2) <- levels(bcat)
for (cat in levels(bcat)) {
    catprofit <- subset(Forbes2000, category==cat)$profit
    this_iqr <- iqr(catprofit, na.rm=TRUE)
    iqr_profits2[levels(bcat)==cat] <- this_iqr
}


#-------------------
# Simple graphics
#-------------------

layout(matrix(1:2, nrow=2))
hist(Forbes2000$marketvalue)
hist(log(Forbes2000$marketvalue))
layout(c(1,1))
plot(log(marketvalue) ~ log(sales), data=Forbes2000, pch=".")
plot(log(marketvalue) ~ log(sales), data=Forbes2000,
     col=rgb(0,0,0,0.1), pch=16)

tmp <- subset(Forbes2000,
              country %in% c("United Kingdom", 
                             "Germany",
                             "India",
                             "Turkey"))
tmp$country <- tmp$country[, drop=TRUE]
plot(log(marketvalue) ~ country, data=tmp,
     ylab="log(marketvalue)", varwidth=TRUE)
