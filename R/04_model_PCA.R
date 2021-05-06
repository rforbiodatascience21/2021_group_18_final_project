
proteomes_data <- joined_data %>%
  select(Class,NP_009231, 
         NP_000537, 
         NP_009125, 
         NP_000305, 
         NP_004351, 
         NP_000446,
         NP_004439,
         NP_001002295)

pca <- proteomes_data %>%
  select(where(is.numeric)) %>%
  prcomp(center = TRUE, scale=TRUE)


#Plot PCA rotation matrix
pca %>%
  augment(proteomes_data) %>%
  ggplot(mapping = aes(.fittedPC1, .fittedPC2, color = Class)) +
  geom_point(size = 0.5) +
  scale_color_manual(
    values = c(maligant = "red", benign = "blue", three = "green", four = "yellow", five = "purple")
  ) +
  theme_half_open(12) + background_grid()


  



