# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")

# Heat Map ---------------------------------------------------------------

## HM with 100 random samples - this is not optimal... ##
ggplot(data = joined_data %>%
         select(-(1:29)) %>%
         pivot_longer(cols = -c("TCGA_ID"),
                      names_to = "RefSeqProteinID",
                      values_to = "value" ) %>%
         sample_n(100),
       mapping = aes(x = RefSeqProteinID, y = TCGA_ID, fill = value)) + 
  geom_tile() +
  scale_fill_gradient(low = "red", high = "blue") + 
  ylab("Patient ID") + 
  xlab("Protein ID")


## Trying to make a HM from nested data ##
ggplot(data = joined_data %>%
         select(-(1:29)) %>%
       mapping = aes(x = TCGA_ID, y = as.tibble(data,), fill = value)) + 
  geom_tile() +
  scale_fill_gradient(low = "red", high = "blue") + 
  ylab("") + 
  xlab("Patient ID")


nested = proteomes_clean_NA %>%
  group_by(RefSeqProteinID) %>%
  nest() %>%
  ungroup()



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
