# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
proteomes_clean <- read_csv(file = "data/proteomes_clean.csv.gz")
clinical_clean <- read_csv(file = "data/clinical_clean.csv.gz")


# Wrangle data ------------------------------------------------------------

### FRACTION OF NA ###
#adding fraction of NA in each gene expression
proteomes_clean <- proteomes_clean %>%
  select(-c(GeneSymbol, "Gene Name")) %>%
  mutate(Frac_NA = rowSums(is.na(select(.,-RefSeqProteinID)))/80)

#removing them
proteomes_clean_NA <- proteomes_clean %>%
  filter(Frac_NA < 0.25)

#Transpose data (get protein ID as columns)
#Drops the rest of the NAs in the long version, so only pr. gene
proteomes_clean_trans <- proteomes_clean_NA %>%
  select(-Frac_NA) %>%
  pivot_longer(cols = -c("RefSeqProteinID"),
               names_to = "TCGA_ID",
               values_to = "value" ) %>% 
  pivot_wider(names_from = "RefSeqProteinID",
              values_from = "value")

#CLINICAL
clinical_aug <- clinical_clean %>% 
  rename(Class = `PAM50 mRNA` ) %>%
  mutate(Class = factor(Class, 
                        levels = c("Basal-like", "HER2-enriched", "Luminal A", "Luminal B", "Healthy")))


#Join data to get one file (HEALTHY ARE REPRESENT IN THIS)
joined_data <- proteomes_clean_trans %>%
  right_join(x = clinical_aug, 
             y = proteomes_clean_trans, 
             by = "TCGA_ID") %>%
  mutate(Class = replace_na(data = Class, 
                            replace = "Healthy")) %>%
  mutate(Class = factor(x = Class, 
                        levels = c("Basal-like", "HER2-enriched", "Luminal A", "Luminal B", "Healthy")))

###### Joined healthy data
#263d3f-I
#blcdb9-I
#c4155b-C

joined_healthy_data <- proteomes_clean_NA %>% 
  select(`RefSeqProteinID`, `263d3f-I`, `blcdb9-I`, `c4155b-C`)

# Add age group to persons
joined_data <- joined_data %>%
mutate(Age_group = case_when(`Age at Initial Pathologic Diagnosis` < 30 ~ "<30",
                             30 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 40 ~ "30-40",
                             40 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 50 ~ "40-50",
                             50 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 60 ~ "50-60",
                             60 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 70 ~ "60-70",
                             70 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 80 ~ "70-80",
                             `Age at Initial Pathologic Diagnosis` >= 80 ~ "80+")) %>%
  select(TCGA_ID,Age_group, everything())


# Making the HER2 Final Status numeric with negaitve = 0 and positive = 1
#joined_data <- joined_data %>% 
#  mutate(`HER2 Numeric Final Status` = case_when(`HER2 Final Status` == "Negative" ~ 0, 
#                                                 `HER2 Final Status` == "Positive" ~ 1)) %>%
#  select(`HER2 Numeric Final Status`, everything())



# Write data --------------------------------------------------------------
write_csv(x = joined_data, 
          file = "data/joined_data.csv.gz")
write_csv(x = joined_healthy_data,
          file = "data/joined_healthy_data.csv.gz")
write_csv(x = proteomes_clean, 
          file = "data/proteomes_clean.csv.gz")
write_csv(x = proteomes_clean_NA, 
          file = "data/proteomes_clean_NA.csv.gz")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")
