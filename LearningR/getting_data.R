# reading text files
require(learningr)

deer_file <- system.file(
  'extdata',
  'RedDeerEndocranialVolume.dlm',
  package = "learningr"
)
deer_data <- read.table(deer_file, header=TRUE, fill=TRUE)
str(deer_data, vec.len=1)

crab_file <- system.file(
               'extdata',
               'crabtag.csv',
               package='learningr'
               )
(crab_id_block <- read.csv(
                    crab_file,
                    header=FALSE,
                    skip=3,
                    nrow=2))
(crab_tag_notebook <- read.csv(
                        crab_file,
                        header=FALSE,
                        skip=8,
                        nrow=5
                        ))
(crab_lifetime_notebook <- read.csv(
                             crab_file,
                             header=FALSE,
                             skip=15,
                             nrow=3
                             ))
