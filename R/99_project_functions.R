# Define project functions ------------------------------------------------

pca_kmeans <- function(x){
#Defining k (number of center in k-means)
#k is equal to the number of unique classes
  k <- data %>% 
    select(x) %>% 
    unique() %>%
    pull() %>% 
    length()

#Choosing cancer genes and tumor class
proteomes_class <- joined_data %>%
  select(x, NP_009231, 
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

return(pca_org_aug)
}
