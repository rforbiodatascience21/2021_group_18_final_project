# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
alon_clean <- read_tsv(file = "data/alon_clean.tsv.gz")

#Usikker på om det her skal gøre - men mutate til binary factor?
# Wrangle data ------------------------------------------------------------
alon_clean_aug <- alon_clean %>%
  mutate(tissue = case_when(value == "n" ~ 0, 
                             value == "t" ~ 1))%>%
  select(tissue,everything(),-value)
#1 = tumor
#0 = normal

# Write data --------------------------------------------------------------
write_tsv(x = alon_clean_aug,
          path = "data/alon_clean_aug.tsv.gz")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")