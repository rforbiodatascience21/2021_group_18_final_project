# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("usethis")
library("devtools")
library("patchwork")
library(modelr)
options(na.action = na.warn)
library(lubridate)
library(broom)
library(purrr)
library(vroom)
library(stringr)


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


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

