wbcd <- read.csv('wisc_bc_data.csv', stringsAsFactors=FALSE)
wbcd <- wbcd[-1]
wbcd$diagnosis <- factor(wbcd$diagnosis, levels=c('B','M'),
                         labels=c('Benign','Malignant'))
wbcd_z <- as.data.frame(scale(wbcd[-1]))
wbcd_train <- wbcd_z[1:469,]
wbcd_test <- wbcd_z[470:569,]
wbcd_train_labels <- wbcd[1:469,1]
wbcd_test_labels <- wbcd[470:569,1]

require(class)
wbcd_test_pred <- knn(train=wbcd_train, test=wbcd_test,
                      cl=wbcd_train_labels, k=21)

require(gmodels)
CrossTable(x=wbcd_test_labels, y=wbcd_test_pred, prop.chisq=FALSE)

