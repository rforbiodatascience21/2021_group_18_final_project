# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------
proteomes_clean <- read_csv(file = "data/proteomes_clean.csv.gz")
proteomes_clean_NA <- read_csv(file = "data/proteomes_clean_NA.csv.gz")
clinical_clean <- read_csv(file = "data/clinical_clean.csv.gz")

### NESTED DATA ###

#Nesting data with RefSeqProteinID and Expression level by TCGA_ID
proteomes_nested <- proteomes_clean %>%
  pivot_longer(cols = -c("RefSeqProteinID", GeneSymbol,"Gene Name"),
               names_to = "TCGA_ID",
               values_to = "Expr_lvl" ) %>%
  select(-c(GeneSymbol,"Gene Name")) %>% 
  group_by(TCGA_ID) %>% 
  nest() %>% 
  ungroup()

### JOIN DATA ###

#Join the clinical and nested data to have one file to work with
joined_data <- clinical_clean %>%
  inner_join(proteomes_nested,
             by = "TCGA_ID") %>%
  select(TCGA_ID, everything())


#Fitting per gene logistic regression models

#Her skal fittes med gene expr level mht hvad? Dead or alive, gender?
cancer_data_lm <- cancer_data %>% 
  mutate(mdl = map(data, ~glm("blabla" ~ Expr_lvl,
                              data =.,
                              family = binomial(link = "logit"))))
