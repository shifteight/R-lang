require(vcd)  # uses Arthritis dataset

mytable <- xtabs(~Treatment+Improved, data=Arthritis)
chisq.test(mytable)
fisher.test(mytable)

## Cochran-Mantel-Haenszel test
## ----------------------------
## Tests the hypothesis that Treatment and Improved variables are independent
## with each level Sex.
## Assumes that there's no three-way (Treatment x Improved x Sex) interaction.
mytable1 <- xtabs(~ Treatment+Improved+Sex, data=Arthritis)
mantelhaen.test(mytable1)

cat("\n## measures of association\n\n")
assocstats(mytable)
