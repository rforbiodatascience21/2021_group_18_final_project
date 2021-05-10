# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load data ---------------------------------------------------------------
proteomes_clean <- read_csv(file = "data/proteomes_clean.csv.gz")
proteomes_clean_NA <- read_csv(file = "data/proteomes_clean_NA.csv.gz")
joined_data <- read_csv(file = "data/joined_data.csv.gz")


#### PLOT fraction NA ###
fractionNA_All <- proteomes_clean %>%
  ggplot(mapping = aes(x =  Frac_NA)) +
  geom_histogram(fill = "navy", 
                 binwidth = 0.04) +
  geom_vline(xintercept = 0.25, color = "red", linetype = "dashed")+
  labs(y = "Number of Proteomes", 
       x = "Fraction of NA in data", 
       title = "Amount of missing data",
       subtitle = "Including all genes")+
  theme_minimal()


## AS 8074 are equal to 0, then these are 'removed' from the plot, 
#to give a better overview ###
fractionNA_without0 <- proteomes_clean %>%
  ggplot(mapping = aes(x =  Frac_NA)) +
  geom_histogram(fill = "navy") +
  geom_vline(xintercept = 0.25, color = "red", linetype = "dashed")+
  labs(y = "Number of Proteomes", 
       x = "Fraction of NA in data", 
       title = "Amount of missing data",
       subtitle = "Genes with NA fraction above 0.0")+
  theme_minimal() +
  xlim(0.000000001,0.8)


### HOW MANY REMOVED ###
proteomes_clean %>%
  filter(Frac_NA > 0.25) %>%
  count()
#2205 removed


# Get to know your data
nrow(joined_data) #80 observations
ncol(joined_data) #10315 variables

# How many females and males in the data:
joined_data %>% 
  count(Gender)

# Count the OS (overall survival) grouped by gender (1 = dead, 0 = survial)
joined_data %>% 
  group_by(Gender) %>%
  count(`OS event`)

#Count in age group
joined_data %>% 
  filter(Class != "Healthy") %>%
  count(Age_group)

# The age at initial pathologic diagnosis
age_diagnosis <- ggplot(data = joined_data %>%
         filter(Class != "Healthy"),
       mapping = aes(x = Age_group, fill = Gender)) +
  geom_bar(alpha = 0.7) +
  labs(x = "Age group", y = "Number of patients", title = "Age at diagnosis")+
  theme_classic()

# Scatterplot of age vs tumor filled by gender:
tumor_gender <- ggplot(joined_data %>%
                         filter(Class != "Healthy"),
       mapping = aes(x = Tumor,
                     y = `Age at Initial Pathologic Diagnosis`, 
                     fill = Gender)) +
  geom_boxplot(alpha = 0.5) +
  labs(x = "Tumor classification", 
       title = "Age divided on tumor size") +
  theme_classic()

# Plot of how many patients have each type of cancer. 
#Breast cancer is generally classified into five molecular subtypes: 
#Luminal A, Luminal B, HER2, Basal like and Normal. 
#Each is associated with different prognoses, treatments and therapies.

cancer_subtype <- joined_data %>%
  mutate(Class = fct_rev(fct_infreq(Class))) %>%
  ggplot(aes(x = Class,
                 fill = `Class`)) + 
  geom_bar() + 
  scale_fill_brewer(palette = "Spectral") +
  labs(x = "Tumor type", 
       y = "Number of patients", 
       title = "Proportion of patients with each cancer subtype", 
       fill = "Tumor type") +
  theme_classic()


# Write data --------------------------------------------------------------
ggsave(filename = "results/FractionNA_withAllPoints.png", plot = fractionNA_All, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/FractionNA_without0.png", plot = fractionNA_without0, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/age_diagnosis.png", plot = age_diagnosis, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/tumor_gender.png", plot = tumor_gender, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/cancer_subtype.png", plot = cancer_subtype, width = 16, height = 9, dpi = 72)
