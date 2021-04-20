# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")
library("usethis")
library("devtools")
install_github('ramhiser/datamicroarray')
library("datamicroarray")


# Define functions --------------------------------------------------------
#source(file = "R/99_project_functions.R")
data('alon', package = 'datamicroarray')
