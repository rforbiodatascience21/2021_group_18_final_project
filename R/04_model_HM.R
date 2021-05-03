# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")

# Heat Map ---------------------------------------------------------------
ggplot(data = , 
       mapping = aes(x = sample, y = GeneName, fill = value)) + 
  geom_tile() +
  scale_fill_gradient(low = "red", high = "blue") + 
  ylab("GeneName") + 
  xlab("Patients")


### Det her virker men er med forkert data #### 
test <- proteomes_clean_NA %>%
  pivot_longer(cols = -c("RefSeqProteinID"),
               names_to = "TCGA_ID",
               values_to = "value" )

ggplot(data = test, 
       mapping = aes(x = RefSeqProteinID, y = TCGA_ID, fill = value)) + 
  geom_tile() +
  scale_fill_gradient(low = "red", high = "blue") + 
  ylab("GeneName") + 
  xlab("Patients")
