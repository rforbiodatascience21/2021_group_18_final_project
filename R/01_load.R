# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("usethis")
library("devtools")
install_github('ramhiser/datamicroarray')
library("datamicroarray")
library("patchwork")
library(modelr)
options(na.action = na.warn)
library(lubridate)
library(broom)
library(purrr)
library(vroom)


# Define functions --------------------------------------------------------
#source(file = "R/99_project_functions.R")
data('alon', package = 'datamicroarray')



# Load data ---------------------------------------------------------------
proteomes <- read_csv("data/_raw/77_cancer_proteomes_CPTAC_itraq.csv")
clinical <- read_csv("data/_raw/clinical_data_breast_cancer.csv")
proteins <- read_csv("data/_raw/PAM50_proteins.csv")

# Write data --------------------------------------------------------------
write_csv(x = proteomes, 
          file = "data/proteomes.tsv.gz")

write_csv(x = clinical, 
          file = "data/clinical.tsv.gz")

write_csv(x = proteins, 
          file = "data/proteins.tsv.gz")

