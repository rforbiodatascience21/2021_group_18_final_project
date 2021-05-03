# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
proteomes_clean <- read_csv(file = "data/proteomes_clean.csv.gz")
proteomes_clean_NA <- read_csv(file = "data/proteomes_clean_NA.csv.gz")
clinical_clean <- read_csv(file = "data/clinical_clean.csv.gz")

# Wrangle data ------------------------------------------------------------

#Transpose data
proteomes_clean_trans <- proteomes_clean_NA %>%
  select(-Frac_NA)%>%
  pivot_longer(cols = -c("RefSeqProteinID"),
               names_to = "TCGA_ID",
               values_to = "value" ) %>% 
  pivot_wider(names_from = "RefSeqProteinID",
              values_from = "value") 

#Join data
joined_data <- proteomes_clean_trans %>%
  right_join(x = clinical_clean, 
             y = ., 
             by = "TCGA_ID")

# Write data --------------------------------------------------------------


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")
