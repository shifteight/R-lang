# summary statistics
data(obama_vs_mccain, package='learningr')
obama <- obama_vs_mccain$Obama
mean(obama)
median(obama)
table(cut(obama, seq.int(0, 100, 10)))

with(obama_vs_mccain, pmin(Obama, McCain))
range(obama)

# scatterplots

# Take 1: base Graphics
obama_vs_mccain <-
  obama_vs_mccain[!is.na(obama_vs_mccain$Turnout), ]
with(obama_vs_mccain, plot(Income, Turnout))
with(obama_vs_mccain, plot(Income, Turnout, col='violet',
                           pch=20))
with(obama_vs_mccain, plot(Income, Turnout, log = "y"))
with(obama_vs_mccain, plot(Income, Turnout, log = "xy"))

par(mar=c(3, 3, 0.5, 0.5), oma=rep.int(0, 4), mgp=c(2, 1, 0))
regions <- levels(obama_vs_mccain$Region)
plot_numbers <- seq_along(regions)
layout(matrix(plot_numbers, ncol=5, byrow=TRUE))
for (region in regions) {
  regional_data <- subset(obama_vs_mccain, Region==region)
  with(regional_data, plot(Income, Turnout))
}

# Take 2: lattice Graphics
library(lattice)
xyplot(Turnout ~ Income, obama_vs_mccain)
xyplot(Turnout ~ Income, obama_vs_mccain, col='violet', pch=20)
xyplot(Turnout ~ Income, obama_vs_mccain,
       scales=list(log=TRUE))
xyplot(Turnout ~ Income, obama_vs_mccain,
       scales=list(y=list(log=TRUE)))
xyplot(Turnout ~ Income | Region,
       obama_vs_mccain,
       scales=list(
         log=TRUE,
         relation="same",
         alternating=FALSE
       ),
       layout=c(5,2)
       )

(lat1 <- xyplot(
  Turnout ~ Income | Region,
  obama_vs_mccain))
(lat2 <- update(lat1, col='violet', pch=20))

# Take 3: ggplot2 Graphics
library(ggplot2)
ggplot(obama_vs_mccain, aes(Income, Turnout)) + geom_point()
ggplot(obama_vs_mccain, aes(Income, Turnout)) +
  geom_point(color='violet', shape=20)
ggplot(obama_vs_mccain, aes(Income, Turnout)) +
  geom_point() +
  scale_x_log10(breaks = seq(2e4, 4e4, 1e4)) +
  scale_y_log10(breaks = seq(50, 75, 5))
ggplot(obama_vs_mccain, aes(Income, Turnout)) +
  geom_point() +
  scale_x_log10(breaks = seq(2e4, 4e4, 1e4)) +
  scale_y_log10(breaks = seq(50, 75, 5)) +
  facet_wrap(~ Region, ncol=5)

(gg1 <- ggplot(obama_vs_mccain, aes(Income, Turnout)) +
   geom_point()
)
(gg2 <- gg1 +
   facet_wrap(~ Region, ncol=5) +
   theme(axis.text.x = element_text(angle=30, hjust=1))
)

# line plots
data(crab_tag, package='learningr')
with(crab_tag$daylog,
     plot(Date, -Max.Depth, type='l', ylim=c(-max(Max.Depth),0)))
with(crab_tag$daylog,
     lines(Date, -Min.Depth, col='blue'))

## using lattice
xyplot(-Min.Depth + -Max.Depth ~ Date, crab_tag$daylog, type='l')

## using ggplot2
ggplot(crab_tag$daylog, aes(Date, -Min.Depth)) + geom_line()

ggplot(crab_tag$daylog, aes(Date)) +
  geom_line(aes(y = -Max.Depth)) +
  geom_line(aes(y = -Min.Depth))

### The 'proper' ggplot2 way of doing such things
library(reshape2)
crab_long <- melt(crab_tag$daylog,
                  id.vars = "Date",
                  measure.vars = c('Min.Depth', 'Max.Depth')
)
ggplot(crab_long, aes(Date, -value, group=variable)) +
  geom_line()

### when there are only two lines, like above, there is
### an even better solution that doesn't require
### any data manipulation.
ggplot(crab_tag$daylog, aes(Date, ymin=-Min.Depth,
                            ymax=-Max.Depth)) +
  geom_ribbon(color='black', fill='white')


# Histograms
with(obama_vs_mccain, hist(Obama))
with(obama_vs_mccain, 
     hist(Obama, 4, main="An exact number of bins"))
with(obama_vs_mccain, 
     hist(Obama, seq.int(0, 100, 5), 
          main="A vector of bin edges"))
with(obama_vs_mccain, 
     hist(Obama, "FD", main="The name of a method"))
with(obama_vs_mccain, 
     hist(Obama, nclass.scott, 
          main="A function for the number of bins"))

binner <- function(x) {
  seq(min(x, na.rm=TRUE), max(x, na.rm=TRUE), length.out=50)
}
with(obama_vs_mccain,
     hist(Obama, binner, main="A function for the bin edges"))

## a probability density histogram
with(obama_vs_mccain, hist(Obama, freq = FALSE))

## lattice histograms
histogram(~ Obama, obama_vs_mccain)
histogram(~ Obama, obama_vs_mccain, breaks=10)
### specify y-axes
histogram(~ Obama, obama_vs_mccain, type='percent')

## ggplot2 histograms
ggplot(obama_vs_mccain, aes(Obama)) +
  geom_histogram(binwidth=5)
ggplot(obama_vs_mccain, aes(Obama, ..density..)) +
  geom_histogram(binwidth=5)


# Box Plots

## base
boxplot(Obama ~ Region, data=obama_vs_mccain)

ovm <- within(
  obama_vs_mccain,
  Region <- reorder(Region, Obama, median))
boxplot(Obama ~ Region, data=ovm)

## lattice
bwplot(Obama ~ Region, data=ovm)

## ggplot2
ggplot(ovm, aes(Region, Obama)) +
  geom_boxplot()


# Bar Charts
# ------------
ovm <- ovm[!(ovm$State %in% c("Alaska", "Hawaii")), ]

par(las=1, mar=c(3, 9, 1, 1))
with(ovm, barplot(Catholic, names.arg=State, horiz=TRUE))

## multiple variables
religions <- with(ovm, 
  rbind(Catholic, Protestant, Non.religious, Other))
colnames(religions) <- ovm$State
par(las=1, mar=c(3, 9, 1, 1))
barplot(religions, horiz=TRUE, beside=FALSE)

## lattice equivalent of barplot is barchart
barchart(State ~ Catholic, ovm)
barchart(
  State ~ Catholic + Protestant + Non.religious + Other,
  ovm,
  stack = TRUE)

## ggplot2: need the data in long form
religions_long <- melt(
  ovm,
  id.vars = 'State',
  measure.vars = c('Catholic', 'Protestant', 
                   'Non.religious', 'Other'))
ggplot(religions_long, aes(State, value, fill=variable)) +
  geom_bar(stat="identity") +
  coord_flip()

### To avoid the bars being stacked, using dodge
ggplot(religions_long, aes(State, value, fill=variable)) +
  geom_bar(stat="identity", position="dodge") +
  coord_flip()
ggplot(religions_long, aes(State, value, fill=variable)) +
  geom_bar(stat="identity", position="fill") +
  coord_flip()
