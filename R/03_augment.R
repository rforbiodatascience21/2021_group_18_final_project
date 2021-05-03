# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
proteomes_clean <- read_csv(file = "data/proteomes_clean.csv.gz")
proteomes_clean_NA <- read_csv(file = "data/proteomes_clean_NA.csv.gz")
clinical_clean <- read_csv(file = "data/clinical_clean.csv.gz")

# Wrangle data ------------------------------------------------------------

#Transpose data (get protein ID as columns)
proteomes_clean_trans <- proteomes_clean_NA %>%
  select(-Frac_NA) %>%
  pivot_longer(cols = -c("RefSeqProteinID"),
               names_to = "TCGA_ID",
               values_to = "value" ) %>% 
  pivot_wider(names_from = "RefSeqProteinID",
              values_from = "value") 

#Join data to get one file (inner join to make sure ID's are represented in both)
joined_data <- proteomes_clean_trans %>%
  inner_join(x = clinical_clean, 
             y = proteomes_clean_trans, 
             by = "TCGA_ID")

# Write data --------------------------------------------------------------
write_csv(x = joined_data, 
          file = "data/joined_data.csv.gz")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")
