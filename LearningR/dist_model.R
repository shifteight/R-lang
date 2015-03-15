# sample with probability
weights <- c(1, 1, 2, 3, 5, 8, 13, 21, 8, 3, 1, 1)
sample(month.abb, 1, prob=weights)

# linear regressions
model1 <- lm(Rate ~ Year + Age.Group + Ethnicity + Gender, gonorrhoea)

lapply(Filter(is.factor, gonorrhoea), levels)
summary(model1)

## update the model
model2 <- update(model1, ~ . - Year)
summary(model2)

anova(model1, model2)
AIC(model1, model2)
BIC(model1, model2)

## you can see the effects of these functions better
## if we create a silly model.
silly_model <- update(model1, ~ . - Age.Group)
anova(model1, silly_model)
AIC(model1, silly_model)
BIC(model1, silly_model)

model3 <- update(model2, ~ . - Gender)
summary(model3)

## set a different default
g2 <- within(
  gonorrhoea,
  {
    Age.Group <- relevel(Age.Group, "30 to 34")
    Ethnicity <- relevel(Ethnicity, "Non-Hispanic Whites")
  })

model4 <- update(model3, data=g2)
summary(model4)

## plot and inspect models
plot_numbers <- 1:6
layout(matrix(plot_numbers, ncol=2, byrow=TRUE))
plot(model4, plot_numbers)

## outliers:
gonorrhoea[c(40, 41, 160), ]
## these large values all refer to non-Hispanic black females,
## suggesting that we are perhaps missing an interaction term
## with ethnicity and gender.

## convenience function for accessing the various components
## of the model
formula(model4)
nobs(model4)
head(residuals(model4))
head(fitted(model4))
head(coefficients(model4))
## functions for diagnosing the quality of models
## listed on ?influence.measures
head(cooks.distance(model4))
summary(model4)$r.squared

## using ggplot2 for diagnosing
diagnostics <- data.frame(
  residuals = residuals(model4),
  fitted    = fitted(model4)
)
ggplot(diagnostics, aes(fitted, residuals)) + 
  geom_point() +
  geom_smooth(method = 'loess')

## make prediction
new_data <- data.frame(
  Age.Group = "30 to 34",
  Ethnicity = "Non-Hispanic Whites")
predict(model4, new_data)
## compare the prediction to data for that group
subset(
  gonorrhoea,
  Age.Group == "30 to 34" & Ethnicity == "Non-Hispanic Whites"
)
