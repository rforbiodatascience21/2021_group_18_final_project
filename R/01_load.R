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
read_csv("data/_raw/77_cancer_proteomes_CPTAC_itraq.csv")
read_csv("clinical_data_breast_cancer.csv")
read_csv("PAM50_proteins.csv")


#Data consist of 

# Write data --------------------------------------------------------------
write_tsv(x = alon %>% 
            pluck("x") %>% 
            as_tibble,
          file = "data/alon_x.tsv.gz")

write_tsv(x = alon %>% 
            pluck("y") %>% 
            as_tibble,
          file = "data/alon_y.tsv.gz")

