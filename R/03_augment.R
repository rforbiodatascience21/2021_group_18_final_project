# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
proteomes_clean <- read_csv(file = "data/proteomes_clean.csv.gz")
proteomes_clean_NA <- read_csv(file = "data/proteomes_clean_NA.csv.gz")
clinical_clean <- read_csv(file = "data/clinical_clean.csv.gz")

# Wrangle data ------------------------------------------------------------


# Write data --------------------------------------------------------------


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")
