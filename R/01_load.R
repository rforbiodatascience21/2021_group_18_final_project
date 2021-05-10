# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library(tidyverse)
library(patchwork)
library(modelr)
library(broom)
library(purrr)
library(vroom)
library(stringr)
library(kableExtra)


# Load data ---------------------------------------------------------------
proteomes <- read_csv("data/_raw/77_cancer_proteomes_CPTAC_itraq.csv")
clinical <- read_csv("data/_raw/clinical_data_breast_cancer.csv")
proteins <- read_csv("data/_raw/PAM50_proteins.csv")

# Write data --------------------------------------------------------------
write_csv(x = proteomes, 
          file = "data/proteomes.csv.gz")

write_csv(x = clinical, 
          file = "data/clinical.csv.gz")

write_csv(x = proteins, 
          file = "data/proteins.csv.gz")
