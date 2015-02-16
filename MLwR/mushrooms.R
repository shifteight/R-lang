mushrooms <- read.csv('mushrooms.csv', stringsAsFactors=TRUE)
str(mushrooms)

# drop variable `veil_type` which has all same values
mushrooms$veil_type <- NULL

table(mushrooms$type)

require(RWeka)
mushroom_1R <- OneR(type ~ ., data=mushrooms)
summary(mushroom_1R)

require(JRip)
mushroom_JRip <- JRip(type ~ ., data=mushrooms)
