# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")


# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")
joined_healthy_data <- read_csv(file = "data/joined_healthy_data.csv.gz")
proteomes_clean_NA <- read_csv(file = "data/proteomes_clean_NA.csv.gz")

#Interrogation of genes related to breast cancer
# BRCA1 = NP_009231
# TP53 = NP_000537
# CHEK2 = NP_009125, NP_665861
# PTEN = NP_000305
# CDH1 = NP_004351
# STK11 = NP_000446
# ERRB2 / HER2 = NP_004439
# GATA3 = NP_001002295

#This analysis will illustrate the differences in gene expression for persons who do
#not have a tumor and persons with a tumor
#Selecting 3 ID's with T3 and T4 and lymph spread (N1-N3) and BC genes
#Dropping the ones that do not have measurement of all the genes
Tumor_sample <- joined_data %>%
  filter(Tumor == "T3" | Tumor == "T4") %>%
  filter(Node == "N1" | Node == "N2"| Node == "N3") %>% 
  select(-c(1:29)) %>% 
  select(`TCGA_ID`, `NP_009231`,`NP_000537`, `NP_009125`, `NP_665861`, `NP_000305`,
         `NP_004351`, `NP_000446`, `NP_004439`, `NP_001002295`) %>% 
  drop_na()

#Transpose
Tumor_sample_trans <- Tumor_sample %>%
  pivot_longer(cols = -c("TCGA_ID"),
               names_to = "RefSeqProteinID",
               values_to = "value" ) %>%
  pivot_wider(names_from = "TCGA_ID",
              values_from = "value") 

#Joined dataframe with sample from tumor and healthy data
# Helathy data does not have BRCA1 (NP_009231) expression, as it is only seen in BC
Sample_Tumor_and_Healthy <- Tumor_sample_trans %>%
  inner_join(x = joined_healthy_data, 
             y = Tumor_sample_trans, 
             by = "RefSeqProteinID")




