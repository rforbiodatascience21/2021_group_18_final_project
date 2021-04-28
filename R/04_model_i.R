# Clear workspace ---------------------------------------------------------
rm(list = ls())


# Load libraries ----------------------------------------------------------
library("tidyverse")

# Load data ---------------------------------------------------------------

#Fitting per gene logistic regression models

#Her skal fittes med gene expr level mht hvad? Dead or alive, gender?
cancer_data_lm <- cancer_data %>% 
  mutate(mdl = map(data, ~glm("blabla" ~ Expr_lvl,
                              data =.,
                              family = binomial(link = "logit"))))
