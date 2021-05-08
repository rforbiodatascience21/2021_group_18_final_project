# Run all scripts --------------------------------------------------------
source(file = "R/01_load.R")
source(file = "R/02_clean.R")
source(file = "R/03_augment.R")
source(file = "R/04_model_general")
source(file = "R/04_model_HM")

###Fra Leons FAQ-dokument:
#How do we run the entire project incl. the presentation?
# - Make sure to include a programmatic call to knitr at the end of you doit-script
