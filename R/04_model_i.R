# Load data
alon_clean_aug <- read_tsv(file = "data/alon_clean_aug.tsv.gz")

# Counting columns and rows
nrow(alon_clean_aug) #62
ncol(alon_clean_aug) #2001

# Showing how many there is in each tissue group.
alon_clean_aug %>% 
  count(tissue)

# Making a boxplot over X1 and X10 gene, divided by normal and tumor tissue
p1 = ggplot(data = alon_clean_aug,
       mapping = aes(x = tissue,
                     y = X1, fill = tissue)) +
  geom_boxplot(alpha = 0.5, show.legend = FALSE)


p2 = ggplot(data = alon_clean_aug,
            mapping = aes(x = tissue,
                          y = X10)) +
  geom_boxplot(alpha = 0.5, show.legend = FALSE)

p1 + p2


# Density plot of X1 gene colored by tissue
ggplot(data = alon_clean_aug,
       mapping = aes(x = X1,
                     color = tissue)) +
  geom_density()
