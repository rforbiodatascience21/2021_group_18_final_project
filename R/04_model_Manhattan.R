#Load data
alon_clean_aug <- read_tsv(file = "data/alon_clean_aug.tsv.gz")

# Wrangle data
alon_clean_aug_long = alon_clean_aug %>%  
  pivot_longer(cols = -c(tissue, tissue_discrete), names_to = "gene", values_to = "log2_expr_level")  

# Nesting data
alon_clean_aug_long_nested <- alon_clean_aug_long %>%
  group_by(gene) %>%
  nest() %>%
  ungroup()

#Selecting 100 random genes
set.seed(987639) 
alon_clean_aug_long_nested <- alon_clean_aug_long_nested %>% 
  sample_n(size=100)

#Fitting per gene logistic regression models
alon_clean_aug_long_nested <- alon_clean_aug_long_nested %>% 
  mutate(mdl = map(data, ~glm(tissue_discrete ~ log2_expr_level,
                              data =.,
                              family = binomial(link = "logit"))))

#Adding model information
alon_clean_aug_long_nested <- alon_clean_aug_long_nested %>% 
  mutate(mdl_tidy = map(mdl, ~tidy(.x, conf.int = TRUE))) %>%
  unnest(mdl_tidy)

#Remove intercept
alon_clean_aug_long_nested <- alon_clean_aug_long_nested %>%
  filter(term == "log2_expr_level")

#Add an indicator variable, denoing if a given term for a given gene is 
#significant i.e. p<0.05
alon_clean_aug_long_nested <- alon_clean_aug_long_nested %>%
  mutate(identified_as = case_when(p.value < 0.05 ~ "Significant", 
                                   p.value > 0.05 ~ "Not significant" ))

#Calculate the negative log10 of the p-values
alon_clean_aug_long_nested <- alon_clean_aug_long_nested %>%
  mutate(neg_log10_p = -log10(p.value))

#Manhattan plot
manhplot <- ggplot(alon_clean_aug_long_nested, 
                   mapping = aes(x = reorder(gene, desc(neg_log10_p)), 
                                 y = neg_log10_p, 
                                 color = identified_as)) +
  geom_point(alpha = 0.75, size = 2) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed") + 
  labs(x = "Gene", 
       y = "Minus log 10(p)") + 
  theme_classic(base_family = "Avenir", base_size = 8) +
  theme( 
    legend.position = "bottom",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.text.x = element_text(angle = 45, size = 4, vjust = 0.5)
  )
manhplot
