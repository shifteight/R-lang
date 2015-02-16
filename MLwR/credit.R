credit <- read.csv('credit.csv')
str(credit)
table(credit$checking_balance)
table(credit$savings_balance)
summary(credit$months_loan_duration)
summary(credit$amount)
table(credit$default)

# create random training and test datasets
set.seed(12345)
credit_rand <- credit[order(runif(1000)), ]
credit_train <- credit_rand[1:900, ]
credit_test <- credit_rand[901:1000, ]
prop.table(table(credit_train$default))
prop.table(table(credit_test$default))

# build the classifier
require(C50)
credit_train$default <- factor(credit_train$default)
credit_model <- C5.0(credit_train[-21], credit_train$default)
# summary(credit_model)

# evaluate model performance
credit_pred <- predict(credit_model, credit_test)
require(gmodels)
CrossTable(credit_test$default, credit_pred,
           prop.chisq=FALSE, prop.c=FALSE, prop.r=FALSE,
           dnn=c('actual default', 'predicted default'))

# improve model performance

## using boosting through trials parameter
credit_boost10 <- C5.0(credit_train[-21], credit_train$default,
                       trials=10)
#summary(credit_boost10)

credit_boost_pred10 <- predict(credit_boost10, credit_test)
CrossTable(credit_test$default, credit_boost_pred10,
           prop.chisq=FALSE, prop.c=FALSE, prop.r=FALSE,
           dnn=c('actual default', 'predicted default'))

# add mistake costs
error_cost <- matrix(c(0, 1, 4, 0), nrow=2)
credit_cost <- C5.0(credit_train[-21], credit_train$default,
                    costs=error_cost)
credit_cost_pred <- predict(credit_cost, credit_test)
CrossTable(credit_test$default, credit_cost_pred,
           prop.chisq=FALSE, prop.c=FALSE, prop.r=FALSE,
           dnn=c('actual default', 'predicted default'))

