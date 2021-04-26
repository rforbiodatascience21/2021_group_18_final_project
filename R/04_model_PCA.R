#Load data
alon_clean_aug <- read_tsv(file = "data/alon_clean_aug.tsv.gz")

# Wrangle data
alon_clean_aug_long = alon_clean_aug %>%  
  pivot_longer(cols = -c(tissue, tissue_discrete), names_to = "Gene", values_to = "Expr_level")  

# Nesting data
alon_clean_aug_long_nested <- alon_clean_aug_long %>%
  group_by(gene) %>%
  nest() %>%
  ungroup() %>% 
  cols(-tissue_discrete)

gravier_data_long_nested <- gravier_data_long_nested %>% 
  mutate(mdl = map(data, ~glm(outcome ~ log2_expr_level,
                              data =.,
                              family = binomial(link = "logit"))))

