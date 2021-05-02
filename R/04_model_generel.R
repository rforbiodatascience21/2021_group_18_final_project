# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load data ---------------------------------------------------------------
#alon_clean <- read_tsv(file = "data/alon_clean.tsv.gz")
joined_data

# Get to know your data
nrow(joined_data) #80 observations
ncol(joined_data) #31 variables

# How many females and males in the data:
joined_data %>% 
  count(Gender)

# Count the OS (overall survival) grouped by gender (1 = dead, 0 = survial)
joined_data %>% 
  group_by(Gender) %>%
  count(`OS event`)



# The age at initial pathologic diagnosis
##### na.rm is to remove all NAs
ggplot(joined_data,
       mapping = aes(x =`Age at Initial Pathologic Diagnosis`, fill = Gender)) +
  geom_bar(na.rm = T)

# Scatterplot of age vs tumor filled by gender:
ggplot(joined_data,
       mapping = aes(x = `Age at Initial Pathologic Diagnosis`,
                     y = Tumor, 
                     color = Gender)) +
  geom_point() +
  labs()


# Scatterplot of cancer stage vs tumor size filled by metastasis if positive or negative:
ggplot(joined_data,
       mapping = aes(x = `AJCC Stage`,
                     y = Tumor, 
                     color = `Metastasis-Coded`)) +
  geom_point() +
  labs() + theme(legend.position = "bottom")

#
#inner join on data to create full data set
library(ggplot2)

ggplot(data = joined_data, aes(Tumor, 
                 col = Tumor, 
                 fill = Tumor)) + 
  geom_bar() + 
  ggtitle("Proportion of patients with each tumor subtype") 


