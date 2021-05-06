
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


#Plot PCA matrix points

pca %>%
  augment(proteomes_data) %>%
  ggplot(mapping = aes(x = .fittedPC1,
                       y = .fittedPC2,
                       color = Class)) +
  geom_point()


#Column wise
pca %>%
  tidy(matrix = "eigenvalues")%>%
  ggplot(mapping = aes(PC, percent)) +
  geom_col()





