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
read_csv("data/_raw/clinical_data_breast_cancer.csv")
read_csv("data/_raw/PAM50_proteins.csv")



