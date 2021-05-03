# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")

# Heat Map ---------------------------------------------------------------

## HM with 100 random samples for RefSeqProtin ID - this is not optimal... and can be removed
## but R might crash.
ggplot(data = joined_data %>%
         select(-(1:31)) %>%
         pivot_longer(cols = -c(TCGA_ID),
                      names_to = "RefSeqProteinID",
                      values_to = "value", 
                      values_drop_na = T) %>%
         sample_n(100),
       mapping = aes(x = RefSeqProteinID, y = TCGA_ID, fill = value)) + 
  geom_tile() +
  scale_fill_gradient(low = "red", high = "blue") + 
  ylab("Patient ID") + 
  xlab("Protein ID")



