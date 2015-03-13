yn_to_logical <- function(x) {
  y <- rep.int(NA, length(x))
  y[x=='Y'] <- TRUE
  y[x=='N'] <- FALSE
  y
}

data(english_monarchs, package='learningr')
head(english_monarchs)

library(stringr)

multiple_kingdoms <- str_detect(english_monarchs$domain, fixed(','))
english_monarchs[multiple_kingdoms, c('name', 'domain')]

multiple_rulers <- str_detect(english_monarchs$name, ",|and")
english_monarchs$name[multiple_rulers & !is.na(multiple_rulers)]

individual_rulers <- str_split(english_monarchs$name, ", | and ")
head(individual_rulers[sapply(individual_rulers, length) > 1])

th <- c("th", "ð", "þ")
sapply(th, function(th) sum(str_count(english_monarchs$name, th)))
english_monarchs$new_name <- str_replace_all(english_monarchs$name, "[ðþ]", "th")

gender <- c('MALE', 'Male', 'male', 'M',
            'FEMALE', 'Female', 'female', 'f', NA)
clean_gender <- str_replace(gender, ignore.case("^m(ale)?$"), "Male")
(clean_gender <- str_replace(clean_gender, ignore.case("^f(emale)?$"), "Female"))

english_monarchs <- within(
                      english_monarchs,
                      {
                        length.of.reign.years <- end.of.reign - start.of.reign
                        reign.was.more.than.30.years <- length.of.reign.years>30
                      }
                    )

english_monarchs <- plyr::mutate(
                      english_monarchs,
                      length.of.reign.years = end.of.reign - start.of.reign,
                      reign.was.more.than.30.years = length.of.reign.years > 30
                      )

# dealing with missing values
data("deer_endocranial_volume", package="learningr")
has_all_measurements <- complete.cases(deer_endocranial_volume)
deer_endocranial_volume[has_all_measurements, ]
na.omit(deer_endocranial_volume)  ## same as above

# converting between wide and long form
deer_wide <- deer_endocranial_volume[, 1:5]
library(reshape2)
deer_long <- melt(deer_wide, id.vars='SkullID')
head(deer_long)
melt(deer_wide, measure.vars = c("VolCT", "VolBead", "VolLWH", "VolFinarelli"))
deer_wide_again <- dcast(deer_long, SkullID ~ variable)

# sorting
year_order <- order(english_monarchs$start.of.reign)
english_monarchs[year_order, ]
plyr::arrange(english_monarchs, start.of.reign)  # same as above

# functional programming
# ----------------------
## This example retrieves the average measurement using
## each method for each deer in the red deer dataset.
get_volume <- function(ct, bead, lwh, finarelli, ct2, bead2, lwh2) {
  # if there is a second measurement, take the average
  if (!is.na(ct2)) {
    ct <- (ct + ct2) / 2
    bead <- (bead + bead2) / 2
    lwh <- (lwh + lwh2) / 2
  }
  # divide lwh by 4 to bring it in line with other measurements
  c(ct=ct, bead=bead, lwh.4=lwh/4, finarelli=finarelli)
}
measurements_by_deer <- with(
                          deer_endocranial_volume,
                          Map(
                            get_volume,
                            VolCT,
                            VolBead,
                            VolLWH,
                            VolFinarelli,
                            VolCT2,
                            VolBead2,
                            VolLWH2
                          )
                        )
head(measurements_by_deer)

# simulating pmax function in base R
pmax2 <- function(x, y) ifelse(x >= y, x, y)
Reduce(pmax2, measurements_by_deer)
