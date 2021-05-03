# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
proteomes_clean <- read_csv(file = "data/proteomes_clean.csv.gz")
proteomes_clean_NA <- read_csv(file = "data/proteomes_clean_NA.csv.gz")
clinical_clean <- read_csv(file = "data/clinical_clean.csv.gz")

#Genes related to breast cancer 

# BRCA1 = NP_009231
# TP53 = NP_000537
# CHEK2 = NP_009125, NP_665861
# PTEN = NP_000305
# CDH1 = NP_004351
# STK11 = NP_000446
# ERRB2 / HER2 = NP_004439
# GATA3 = NP_001002295


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
             by = "TCGA_ID") %>%
  filter(!is.na(Gender))


# Add age group to persons
joined_data <- joined_data %>%
mutate(Age_group = case_when(`Age at Initial Pathologic Diagnosis` < 30 ~ "<30",
                             30 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 40 ~ "30-40",
                             40 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 50 ~ "40-50",
                             50 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 60 ~ "50-60",
                             60 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 70 ~ "60-70",
                             70 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 80 ~ "70-80",
                             `Age at Initial Pathologic Diagnosis` >= 80 ~ "80+")) %>%
  select(Age_group, everything())

# Making the HER2 Final Status numeric with negaitve = 0 and positive = 1
joined_data <- joined_data %>% 
  mutate(`HER2 Numeric Final Status` = case_when(`HER2 Final Status` == "Negative" ~ 0, `HER2 Final Status` == "Positive" ~ 1)) %>%
  select(`HER2 Numeric Final Status`, everything())



# Write data --------------------------------------------------------------
write_csv(x = joined_data, 
          file = "data/joined_data.csv.gz")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")
