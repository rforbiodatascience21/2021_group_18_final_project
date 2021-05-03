# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")


# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")


# Making the HER2 Final Status numeric with negaitve = 0 and positive = 1
joined_data <- joined_data %>% 
  mutate(`HER2 Numeric Final Status` = case_when(`HER2 Final Status` == "Negative" ~ 0, 
                                                 `HER2 Final Status` == "Positive" ~ 1)) %>%
  select(`HER2 Numeric Final Status`, everything(), -`HER2 Final Status`)

joined_data_long <- joined_data  %>%
  select(-(2:29)) %>%
  pivot_longer(cols = -c("TCGA_ID"),
               names_to = "RefSeqProteinID",
               values_to = "value" ) %>% 
  drop_na()

joined_data_long_nested <- joined_data_long %>% 
  group_by(TCGA_ID) %>% 
  nest() %>% 
  ungroup()

