# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")


# PCA ---------------------------------------------------------------
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


#Percent of variance explained in PC1-PC8
pca %>%
  tidy(matrix = "eigenvalues")%>%
  ggplot(mapping = aes(PC, percent)) +
  geom_col(fill = "blue", alpha = 0.6) +
  scale_x_continuous(breaks = 1:8) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))) +
  theme_light() +
  ylab("Percent of variance explained")


#Plot PCA matrix points
pca %>%
  augment(proteomes_data) %>%
  ggplot(mapping = aes(x = .fittedPC1,
                       y = .fittedPC2,
                       color = Class)) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") +
  theme_light()







