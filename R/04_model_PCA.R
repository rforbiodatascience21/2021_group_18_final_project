# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")


# PCA ---------------------------------------------------------------

### Class
proteomes_data <- joined_data %>%
  select(Class, NP_009231, 
         NP_000537, 
         NP_009125, 
         NP_000305, 
         NP_004351, 
         NP_000446,
         NP_004439,
         NP_001002295)

pca <- proteomes_data %>%
  select(where(is.numeric)) %>%
  prcomp(center = TRUE, 
         scale=TRUE)


#Percent of variance explained in PC1-PC8
PCA_percent <- pca %>%
  tidy(matrix = "eigenvalues")%>%
  ggplot(mapping = aes(PC, percent)) +
  geom_col(fill = "blue", 
           alpha = 0.6) +
  scale_x_continuous(breaks = 1:8) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))) +
  theme_light() +
  labs(y = "Percentage of variance explained", 
       title = "Variance explained by each PC")


#Plot PCA matrix points
PCA_plot <- pca %>%
  augment(proteomes_data) %>%
  ggplot(mapping = aes(x = .fittedPC1,
                       y = .fittedPC2,
                       color = Class)) +
  geom_point() +
  theme_light() +
  labs(x = "PC1", y = "PC2", 
       title = "PCA plot of chosen cancer genes")+
  theme(legend.key = element_rect(fill = "white", 
                                  colour = "black"),
        legend.title = element_text(face = "bold"))



### Tumor
proteomes_data2 <- joined_data %>%
  select(Tumor, NP_009231, 
         NP_000537, 
         NP_009125, 
         NP_000305, 
         NP_004351, 
         NP_000446,
         NP_004439,
         NP_001002295)

pca2 <- proteomes_data %>%
  select(where(is.numeric)) %>%
  prcomp(center = TRUE, scale=TRUE)


#Percent of variance explained in PC1-PC8
PCA_percent2 <- pca2 %>%
  tidy(matrix = "eigenvalues")%>%
  ggplot(mapping = aes(PC, percent)) +
  geom_col(fill = "blue", 
           alpha = 0.6) +
  scale_x_continuous(breaks = 1:8) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))) +
  theme_light() +
  ylab("Percentage of variance explained")

#Plot PCA matrix points
PCA_plot2 <- pca2 %>%
  augment(proteomes_data2) %>%
  ggplot(mapping = aes(x = .fittedPC1,
                       y = .fittedPC2,
                       color = Tumor)) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") +
  theme_light()



# K MEANS FOR TUMOR CLASS --------------------------------------------------------------

#Defining k (number of center in k-means)
#k is equal to the number of unique classes
k <- joined_data %>% 
  select(Class) %>% 
  unique() %>%
  pull() %>% 
  length()

#Choosing cancer genes and tumor class
proteomes_class <- joined_data %>%
  select(Class, NP_009231, 
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
  prcomp(center = TRUE, scale=TRUE)

# Augment pca with class
pca_class_aug <- pca_class %>%
  augment(proteomes_class)

# Making k-means of original data
pca_class_org <- pca_class_aug %>%
  select(contains("NP")) %>%
  kmeans(centers = k)

# Augment with pca
pca_class_aug_org <- pca_class_org %>%
  augment(pca_class_aug) %>% 
  rename(cluster_org = .cluster)

# Making k-means of pca data
pca_fit_aug <- pca_class_aug_org %>%
  select(.fittedPC1, .fittedPC2) %>%
  kmeans(centers = k)

# Augment of pca and original data
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
  theme(legend.position = "bottom")+
  labs(title = "PCA ")

pl2 <- pca_class_aug_org %>%
  ggplot(aes(x = .fittedPC1, 
             y = .fittedPC2, 
             colour = cluster_org)) +
  geom_point() +
  theme(legend.position = "bottom")+
  labs(title = "K-means original data")

pl3 <- pca_org_aug %>%
  ggplot(aes(x = .fittedPC1, 
             y = .fittedPC2, 
             colour = cluster_pca)) +
  geom_point() +
  theme(legend.position = "bottom") +
  labs(title = "K-means PCA data")

(pl1 + pl2 + pl3)

# Write data --------------------------------------------------------------
ggsave(filename = "results/PCA_percent.png", plot = PCA_percent, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/PCA_plot.png", plot = PCA_plot, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/PCA_percent2.png", plot = PCA_percent2, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/PCA_plot2.png", plot = PCA_plot2, width = 16, height = 9, dpi = 72)


