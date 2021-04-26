# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("usethis")
library("devtools")
install_github('ramhiser/datamicroarray')
library("datamicroarray")


# Define functions --------------------------------------------------------
#source(file = "R/99_project_functions.R")
data('alon', package = 'datamicroarray')



# Load data ---------------------------------------------------------------
load("data/_raw/alon.RData")


#Data consist of 62 samples (rows) from 2000 genes (columns)
# x = all measurements
# y = classes, n = normal tissue (22), t = tumor tissue (40)

# Write data --------------------------------------------------------------
write_tsv(x = alon %>% 
            pluck("x") %>% 
            as_tibble,
          file = "data/alon_x.tsv.gz")

write_tsv(x = alon %>% 
            pluck("y") %>% 
            as_tibble,
          file = "data/alon_y.tsv.gz")
