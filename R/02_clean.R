# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
proteomes <- read_csv(file = "data/proteomes.csv.gz")
proteins <- read_csv(file = "data/proteins.csv.gz")
clinical <- read_csv((file = "data/clinical.csv.gz" ))

# Wrangle data ------------------------------------------------------------



# Write data --------------------------------------------------------------

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")
