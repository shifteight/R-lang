## fit <- lm(weight~height, data=women)
## par(mfrow=c(2,2))
## plot(fit)

## fit2 <- lm(weight ~ height + I(height^2),data=women)
## par(mfrow=c(2,2))
## plot(fit2)

## newfit <- lm(weight ~ height + I(height^2), data=women[-c(13, 15),])

states <- as.data.frame(state.x77[,c("Murder", "Population",
                                     "Illiteracy", "Income", "Frost")])

fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data=states)
par(mfrow=c(2,2))
plot(fit)

library(car)
qqPlot(fit, labels=row.names(states), id.method="identify",
       simulate=TRUE, main="Q-Q Plot")

hat.plot <- function(fit) {
    p <- length(coefficients(fit))
    n <- length(fitted(fit))
    plot(hatvalues(fit), main="Index Plot of Hat Values")
    abline(h=c(2,3)*p/n, col="red", lty=2)
    identify(1:n, hatvalues(fit), names(hatvalues(fit)))
}
hat.plot(fit)

## creates a Cook's D plot
cutoff <- 4/(nrow(states)-length(fit$coefficients)-2)
plot(fit, which=4, cook.levels=cutoff)
abline(h=cutoff, lty=2, col="red")

## creates added-variable plots
avPlots(fit, ask=FALSE, onepage=TRUE, id.method="identify")

## influence plot:
## States above +2 or below –2 on the vertical axis are considered
## outliers. States above 0.2 or 0.3 on the horizontal axis have high
## leverage (unusual combinations of predictor values). Circle size is
## proportional to influence. Observations depicted by large circles may
## have disproportionate influence on the parameters estimates of the
## model.                                  
influencePlot(fit, id.method="identify", main="Influence Plot",
              sub="Circle size is proprortional to Cook's distance")
