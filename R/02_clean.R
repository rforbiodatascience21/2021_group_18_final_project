# Clear workspace ---------------------------------------------------------
rm(list = ls())

#####
#PCA
#Heat map
#K-means
#Generelle plots for at vise data
#Linear models og p-værdier
#####

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
proteomes <- read_csv(file = "data/proteomes.csv.gz")
proteins <- read_csv(file = "data/proteins.csv.gz")
clinical <- read_csv((file = "data/clinical.csv.gz" ))

# Wrangle data ------------------------------------------------------------

#### PROTEOME ####
#Renaming columns to match proteins file
proteomes_clean <- proteomes %>%
  rename(RefSeqProteinID =  RefSeq_accession_number,
         "Gene Name" = gene_name,
         GeneSymbol = gene_symbol)

#Removing .01TCGA from every column name in proteome to match ID's in clinical
#And removing three duplicates 
proteomes_clean <- proteomes_clean %>%
  select(.,-c("AO-A12D.05TCGA","C8-A131.32TCGA","AO-A12B.34TCGA"))

proteomes_clean <- proteomes_clean %>% 
  rename_with(., ~ str_replace_all(.,"\\..*",""))

#### CLINICAL ####

#Aligning ID's with ID's in proteome file
clinical_clean <- clinical %>%
  mutate(TCGA_ID = str_sub(`Complete TCGA ID`, 
                           start = 6,
                           end = -1)) %>%
  select(-`Complete TCGA ID`)

### NESTED DATA ###

#Nesting data with RefSeqProteinID and Expression level by TCGA_ID
proteomes_nested <- proteomes_clean %>%
  pivot_longer(cols = -c("RefSeqProteinID", GeneSymbol,"Gene Name"),
               names_to = "TCGA_ID",
               values_to = "Expr_lvl" ) %>%
  select(-c(GeneSymbol,"Gene Name")) %>% 
  group_by(TCGA_ID) %>% 
  nest() %>% 
  ungroup()
  
### JOIN DATA ###

#Join the clinical and nested data to have one file to work with
joined_data <- clinical_clean %>%
  right_join(proteomes_nested,
            by = "TCGA_ID") %>%
  select(TCGA_ID, everything())

#Have tried with different write functions, but it doesn't work with a list...
