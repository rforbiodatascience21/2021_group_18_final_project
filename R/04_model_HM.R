# Wrangle data
alon_clean_aug_long = alon_clean_aug %>%  
  pivot_longer(cols = !tissue, names_to = "Gene", values_to = "Expr_level") 

# Nesting data
alon_clean_aug_long_nested <- alon_clean_aug_long %>%
  group_by(Gene) %>%
  nest() %>%
  ungroup()

# Heatmap
ggplot(alon_clean_aug_long, aes(x = tissue, y = Gene, fill = Expr_level)) +
  geom_tile()

# Heat map with groupimg and count of expression
ggplot(alon_clean_aug_long %>% 
         group_by(Gene, tissue) %>% 
         count(Expr_level), 
       mapping = aes(x = tissue, y = Gene, fill = Expr_level)) +
  geom_tile()


# Making random data to get fewer genes
alon_clean_aug_long_random <- alon_clean_aug %>%
  select(starts_with("X100") | contains("tissue")) %>% 
  pivot_longer(cols = !tissue, names_to = "Gene", values_to = "Expr_level") 

# Heatmap of the random genes 
############################# SPG, ved ikke helt hvordan det bestemmer Expr_level...
ggplot(alon_clean_aug_long_random %>% group_by(Gene, tissue) %>% count(Expr_level), aes(x = tissue, y = Gene, fill = Expr_level)) +
  geom_tile()
