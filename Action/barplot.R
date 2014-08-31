require("vcd")
counts <- table(Arthritis$Improved)
barplot(counts,
        main="Simple Bar Plot",
        xlab="Improvement", ylab="Frequency")

barplot(counts,
        main="Horizontal Bar Plot",
        xlab="Frequency", ylab="Improvement",
        horiz=TRUE)
