# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load data ---------------------------------------------------------------
proteomes_clean <- read_csv(file = "data/proteomes_clean.csv.gz")
proteomes_clean_NA <- read_csv(file = "data/proteomes_clean_NA.csv.gz")
clinical_clean <- read_csv(file = "data/clinical_clean.csv.gz")
joined_data <- read_csv(file = "data/joined_data.csv.gz")

#### PLOT fraction NA ###
ggplot(data = proteomes_clean,
       mapping = aes(x = reorder(RefSeqProteinID,desc(Frac_NA)), y = Frac_NA), color = blue) +
  geom_col() +
  labs(y = "Fraction of NA in data", x = "Proteins", title = "Amount of missing data") 



### HOW MANY REMOVED ###
proteomes_clean %>%
  filter(Frac_NA > 0.25) %>%
  count()


# Get to know your data
nrow(joined_data) #80 observations
ncol(joined_data) #1031 variables

# How many females and males in the data:
joined_data %>% 
  count(Gender)

# Count the OS (overall survival) grouped by gender (1 = dead, 0 = survial)
joined_data %>% 
  group_by(Gender) %>%
  count(`OS event`)

#Count in age group
joined_data %>% 
  count(Age_group)

# The age at initial pathologic diagnosis
ggplot(data = joined_data,
       mapping = aes(x = Age_group, fill = Gender)) +
  geom_bar(alpha = 0.7) +
  labs(x = "Age group", y = "Number of patients", title = "Age at diagnosis")+
  theme_classic()

# Scatterplot of age vs tumor filled by gender:
ggplot(joined_data,
       mapping = aes(x = Tumor,
                     y = `Age at Initial Pathologic Diagnosis`, 
                     fill = Gender)) +
  geom_boxplot(alpha = 0.5) +
  labs(x = "Tumor classification", title = "Age divided on tumor class")+
  theme_classic()

# Scatterplot of cancer stage vs tumor size filled by metastasis if positive or negative:
ggplot(joined_data,
       mapping = aes(x = `AJCC Stage`,
                     y = Tumor, 
                     color = `Metastasis-Coded`)) +
  geom_point() +
  labs() + theme(legend.position = "bottom")


# Plot of how many patients have each type of cancer. 
#Breast cancer is generally classified into five molecular subtypes: 
#Luminal A, Luminal B, HER2, Basal like and Normal. 
#Each is associated with different prognoses, treatments and therapies.

ggplot(data = joined_data, aes(`PAM50 mRNA`,
                 fill = `PAM50 mRNA`)) + 
  geom_bar() + 
  scale_fill_brewer(palette = "Blues") +
  labs(x = "Tumor type", y = "Number of patients", 
       title = "Proportion of patients with each cancer subtype", fill = "Tumor type")+
  theme_classic()
