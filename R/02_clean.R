# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
proteomes <- read_csv(file = "data/proteomes.csv.gz")
proteins <- read_csv(file = "data/proteins.csv.gz")
clinical <- read_csv((file = "data/clinical.csv.gz" ))

# Wrangle data ------------------------------------------------------------

# Simplify ID's (from .01 and .05 eg.)
proteomes <- proteomes %>%
  str_replace_all(string = .,
                  )



# Write data --------------------------------------------------------------

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")
