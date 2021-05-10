# Run all scripts --------------------------------------------------------
source(file = "R/01_load.R")
source(file = "R/02_clean.R")
source(file = "R/03_augment.R")
source(file = "R/04_model_generel.R")
source(file = "R/05_model_HM.R")
source(file = "R/06_model_PCA.R")
source(file = "R/07_model_pvalue.R")

###Fra Leons FAQ-dokument:
#How do we run the entire project incl. the presentation?
# - Make sure to include a programmatic call to knitr at the end of you doit-script
