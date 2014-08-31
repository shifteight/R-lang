all2006 <- read.csv("2006.csv", header=TRUE, as.is=TRUE)

all2006 <- all2006[all2006$Wage_Per=="Year",] # exclude hourly-wagers
all2006 <- all2006[all2006$Wage_Offered_From > 20000,] # exclude weird cases
all2006 <- all2006[all2006$Prevailing_Wage_Amount > 200,] # exclude hrly prv wg

all2006$rat <- all2006$Wage_Offered_From / all2006$Prevailing_Wage_Amount

medrat <- function(dataframe) {
  return(median(dataframe$rat,na.rm=TRUE))
}

se2006 <- all2006[grep("Software Engineer",all2006),]
prg2006 <- all2006[grep("Programmer",all2006),]
ee2006 <- all2006[grep("Electronics Engineer",all2006),]

makecorp <- function(corpname) {
  t <- all2006[all2006$Employer_Name == corpname,]
  return(t)
}

corplist <- c("MICROSOFT CORPORATION","ms","INTEL CORPORATION","intel",
              "SUN MICROSYSTEMS, INC.","sun","GOOGLE INC.","google")

for (i in 1:(length(corplist)/2)) {
  corp <- corplist[2*i-1]
  newdtf <- paste(corplist[2*i],"2006",sep="")
  assign(newdtf,makecorp(corp),pos=.GlobalEnv)
}
