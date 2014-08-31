attach(mtcars)
layout(matrix(c(1,1,2,3), 2, 2, byrow=TRUE),
       widths=c(3,1), heights=c(1,2))
hist(wt)
hist(mpg)
hist(disp)
detach(mtcars)
