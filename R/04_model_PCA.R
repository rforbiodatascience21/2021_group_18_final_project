#Load data
alon_clean_aug <- read_tsv(file = "data/alon_clean_aug.tsv.gz")

# Wrangle data
alon_clean_aug_long = alon_clean_aug %>%  pivot_longer(cols = !tissue, names_to = "Gene", values_to = "Expr_level") 

# Nesting data
alon_clean_aug_long_nested <- alon_clean_aug_long %>%
  group_by(Gene) %>%
  nest() %>%
  ungroup()

