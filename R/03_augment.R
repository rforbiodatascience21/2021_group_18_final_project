# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
joined_data <- read_tsv(file = "data/proteins_joined.tsv.gz")

# Wrangle data ------------------------------------------------------------

#Make dataset only with cancer data
cancer_data <- joined_data %>% 
  filter(str_detect(TCGA_ID,"263d3f-I", negate = TRUE)) %>% 
  filter(str_detect(TCGA_ID,"blcdb9-I", negate = TRUE)) %>% 
  filter(str_detect(TCGA_ID,"c4155b-C", negate = TRUE))


# Write data --------------------------------------------------------------
write_tsv(x = alon_clean_aug,
          path = "data/alon_clean_aug.tsv.gz")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")
