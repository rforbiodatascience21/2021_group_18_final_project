# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")


#PCA and K MEANS FOR TUMOR CLASS --------------------------------------------------------------

#Defining k (number of center in k-means)
#k is equal to the number of unique classes
k <- joined_data %>% 
  select(Class) %>% 
  unique() %>%
  pull() %>% 
  length()

#Choosing cancer genes and tumor class
proteomes_class <- joined_data %>%
  select(Class, 
         NP_009231, 
         NP_000537, 
         NP_009125, 
         NP_000305, 
         NP_004351, 
         NP_000446,
         NP_004439,
         NP_001002295)

# PCA on cancergenes
pca_class <- proteomes_class %>%
  select(where(is.numeric)) %>%
  prcomp(center = TRUE, 
         scale = TRUE)

#Percent of variance explained in PC1-PC8
PCA_percent <- pca_class %>%
  tidy(matrix = "eigenvalues")%>%
  ggplot(mapping = aes(PC, 
                       percent)) +
  geom_col(fill = "blue", 
           alpha = 0.6) +
  scale_x_continuous(breaks = 1:8) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 
                                0.01))) +
  theme_light() +
  labs(y = "Percentage of variance explained", 
       title = "Variance explained by each PC")

# Augment pca with class
pca_class_aug <- pca_class %>%
  augment(proteomes_class)

# Making k-means of original data - plot 1
pca_class_org <- pca_class_aug %>%
  select(contains("NP")) %>%
  kmeans(centers = k)

# Augment with pca - plot 2
pca_class_aug_org <- pca_class_org %>%
  augment(pca_class_aug) %>% 
  rename(cluster_org = .cluster)

# Making k-means of pca data
pca_fit_aug <- pca_class_aug_org %>%
  select(.fittedPC1, 
         .fittedPC2) %>%
  kmeans(centers = k)

# Augment of pca and original data - plot 3
pca_org_aug <- pca_fit_aug %>%
  augment(pca_class_aug_org) %>% 
  rename(cluster_pca = .cluster)


#Defining three plots - one with pca, second with kmeans of original data
# third with kmeans of pca data
pl1 <- pca_class_aug %>%
  ggplot(aes(x = .fittedPC1, 
             y = .fittedPC2, 
             colour = Class)) +
  geom_point() +
  theme(legend.position = "bottom") +
  labs(title = "PCA ",
       x = "PC1", 
       y = "PC2") +
  guides(colour = guide_legend(title.position = "top",
                                           nrow = 2,
                                           byrow = TRUE))

pl2 <- pca_class_aug_org %>%
  ggplot(aes(x = .fittedPC1, 
             y = .fittedPC2, 
             colour = cluster_org)) +
  geom_point() +
  theme(legend.position = "bottom") +
  labs(title = "K-means original data",
       x = "PC1", 
       y = "PC2") +
  guides(colour = guide_legend(title.position = "top",
                               nrow = 2,
                               byrow = TRUE))

pl3 <- pca_org_aug %>%
  ggplot(aes(x = .fittedPC1, 
             y = .fittedPC2, 
             colour = cluster_pca)) +
  geom_point() +
  theme(legend.position = "bottom") +
  labs(title = "K-means PCA data",
       x = "PC1", 
       y = "PC2") +
  guides(colour = guide_legend(title.position = "top",
                               nrow = 2,
                               byrow = TRUE))

# Write data --------------------------------------------------------------
ggsave(filename = "results/PCA_percent.png", plot = PCA_percent, width = 10, height = 5, dpi = 72)
ggsave(filename = "results/PCAkMeans.png", plot = pl1 + pl2 + pl3, width = 10, height = 5, dpi = 72)