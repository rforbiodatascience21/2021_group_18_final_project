# Wrangle data
alon_clean_aug_long = alon_clean_aug %>%  
  pivot_longer(cols = -c(tissue, tissue_discrete), names_to = "Gene", values_to = "Expr_level")  
  

# Heatmap
ggplot(alon_clean_aug_long, aes(x = tissue, y = Gene, fill = Expr_level)) +
  geom_tile()

# Heat map with grouping 
ggplot(alon_clean_aug_long %>% 
         group_by(Gene, tissue) %>% 
         count(Expr_level), 
       mapping = aes(x = tissue, y = Gene, fill = Expr_level)) +
  geom_tile()


# Selecting few genes (100, 1001-1009)
alon_clean_aug_long_random <- alon_clean_aug %>%
  select(everything("tissue") | starts_with("X100")) %>%
  pivot_longer(cols = !tissue, names_to = "Gene", values_to = "Expr_level")

# Heatmap of the random genes 
############################# SPG, ved ikke helt hvordan det bestemmer Expr_level...
ggplot(alon_clean_aug_long_random %>% 
         group_by(Gene, tissue) %>% 
         count(Expr_level), 
       mapping = aes(x = tissue, y = Gene, fill = Expr_level)) +
  geom_tile()
