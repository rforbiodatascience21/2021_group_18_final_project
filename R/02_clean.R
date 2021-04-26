# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
alon_x <- read_tsv(file = "data/alon_x.tsv.gz")
alon_y <- read_tsv(file = "data/alon_y.tsv.gz")

# Wrangle data ------------------------------------------------------------
alon_clean <- bind_cols(alon_x, alon_y)
#if size is different, the bind_cols can be dangerous

# Write data --------------------------------------------------------------
write_tsv(x = alon_clean,
          path = "data/alon_clean.tsv.gz")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")
