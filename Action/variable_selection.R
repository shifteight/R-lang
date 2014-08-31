states <- as.data.frame(state.x77[,c("Murder", "Population",
                                     "Illiteracy", "Income", "Frost")])
fit1 <- lm(Murder ~ Population + Illiteracy + Income + Frost,
                  data=states)

# backward stepwise selection
require(MASS)
stepAIC(fit1, direction="backward")

# all subsets regression
require(leaps)
leaps <- regsubsets(Murder ~ Population + Illiteracy + Income + Frost,
                    data=states, nbest=4)
plot(leaps, scale="adjr2")

require(car)
subsets(leaps, statistic="cp", main="Cp Plot for All Subsets Regression")
abline(1,1,lty=2,col="red")
