# Clear workspace ---------------------------------------------------------
rm(list = ls())

#####
#PCA
#Heat map
#K-means
#Generelle plots for at vise data
#Linear models og p-værdier
#Cluster analysis
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
  select(-c("AO-A12D.05TCGA","C8-A131.32TCGA","AO-A12B.34TCGA"))

proteomes_clean <- proteomes_clean %>% 
  rename_with( ~ str_replace_all(.,"\\..*",""))

#### CLINICAL ####

#Aligning ID's with ID's in proteome file
clinical_clean <- clinical %>%
  mutate(TCGA_ID = str_sub(`Complete TCGA ID`, 
                           start = 6,
                           end = -1)) %>%
  select(-`Complete TCGA ID`)


### FRACTION OF NA ###

proteomes_clean <- proteomes_clean %>%
  select(-c(GeneSymbol, "Gene Name")) %>%
  mutate(Frac_NA = rowSums(is.na(select(.,-RefSeqProteinID)))/80)

#removing them
proteomes_clean_NA <- proteomes_clean %>%
  filter(Frac_NA < 0.25)


# WRITE data

write_csv(x = proteomes_clean, 
          file = "data/proteomes_clean.csv.gz")

write_csv(x = proteomes_clean_NA, 
          file = "data/proteomes_clean_NA.csv.gz")

write_csv(x = clinical_clean, 
          file = "data/clinical_clean.csv.gz")
