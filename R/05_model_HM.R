# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")


# Heat Map - TUMOR CLASS  ---------------------------------------------------------------

#Genes related to breast cancer (found in literature)

# BRCA1 = NP_009231
# TP53 = NP_000537
# CHEK2 = NP_009125, NP_665861
# PTEN = NP_000305
# CDH1 = NP_004351
# STK11 = NP_000446
# ERRB2 / HER2 = NP_004439
# GATA3 = NP_001002295

#Selecting above mentioned genes, tumor class and TCGA_ID
cancer_genes <- joined_data %>% 
  select(TCGA_ID, 
         Class, 
         NP_009231, 
         NP_000537, 
         NP_009125, 
         NP_000305, 
         NP_004351, 
         NP_000446,
         NP_004439,
         NP_001002295) %>%
  # Rename to correspondent gene names
  rename("BRCA1" = "NP_009231",
         "TP53" = "NP_000537",
         "CHEK2" = "NP_009125",
         "PTEN" = "NP_000305",
         "CDH1" = "NP_004351",
         "STK11" = "NP_000446",
         "ERRB2" = "NP_004439",
         "GATA3" = "NP_001002295") %>%
  # Create long data for heatmap
  pivot_longer(cols = c("BRCA1", 
                        "TP53", 
                        "CHEK2", 
                        "PTEN", 
                        "CDH1", 
                        "STK11", 
                        "ERRB2", 
                        "GATA3"), 
               names_to = "RefSeqProteinID",
               values_to = "Expression level (log2)")

# The heatmap plot
HM_class <- 
  ggplot(data = cancer_genes, 
         mapping = aes(x = RefSeqProteinID,
                       y = TCGA_ID, 
                       fill = `Expression level (log2)`)) +
  geom_tile() + 
  facet_grid(Class ~ ., 
             scales = "free") +
  scale_fill_gradient2(low = "blue",
                       mid = "white",
                       high = "red",
                       midpoint = 0,
                       name = "Expression \n(log2)") +
  theme_bw(base_family = "Times",
             base_size = 10) + 
  theme(panel.grid = element_blank(),
        axis.ticks = element_blank(),
        axis.text.x = element_text(size = 16, 
                                   angle = 45,
                                   hjust = 1),
        axis.text.y = element_blank(),
        strip.text.y = element_text(size = 12),
        plot.title = element_text(size = 18,
                                  face = "bold"),
        legend.title = element_text(size = 16,
                                    hjust = 0.5),
        legend.text = element_text(size = 14),
        panel.spacing.y = unit(0.1, "cm")) +
  labs(title = "Heatmap of breast cancer genes",
       subtitle = "Based on tumor class",
       x = "Cancer related genes",
       y = NULL) 



# Heat Map - TUMOR SIZE  ---------------------------------------------------------------

#Selecting above mentioned genes, tumor size (T1, T2, T3, T4) and TCGA_ID
cancer_genes_tumor <- joined_data %>% 
  select(TCGA_ID, 
         Tumor, 
         NP_009231, 
         NP_000537, 
         NP_009125, 
         NP_000305, 
         NP_004351, 
         NP_000446,
         NP_004439,
         NP_001002295) %>%
  # Rename to correspondent gene names
  rename("BRCA1" = "NP_009231",
         "TP53" = "NP_000537",
         "CHEK2" = "NP_009125",
         "PTEN" = "NP_000305",
         "CDH1" = "NP_004351",
         "STK11" = "NP_000446",
         "ERRB2" = "NP_004439",
         "GATA3" = "NP_001002295") %>%
  # Create long data for heatmap
  pivot_longer(cols = c("BRCA1", 
                        "TP53", 
                        "CHEK2", 
                        "PTEN", 
                        "CDH1", 
                        "STK11", 
                        "ERRB2", 
                        "GATA3"), 
               names_to = "RefSeqProteinID",
               values_to = "Expression level (log2)")

# The heatmap plot
HM_TumorSize <-
  ggplot(data = cancer_genes_tumor, 
         mapping = aes(x = RefSeqProteinID,
                       y = TCGA_ID,
                       fill = `Expression level (log2)`)) +
  geom_tile()+ 
  facet_grid(Tumor ~ ., 
             scales = "free") +
  scale_fill_gradient2(low = "blue",
                       mid = "white",
                       high = "red",
                       midpoint = 0,
                       name = "Expression \n(log2)") +
  theme_bw(base_family = "Times",
           base_size = 10) + 
  theme(panel.grid = element_blank(),
        axis.ticks = element_blank(),
        axis.text.x = element_text(size = 16, 
                                   angle = 45,
                                   hjust = 1),
        axis.text.y = element_blank(),
        strip.text.y = element_text(size = 12),
        plot.title = element_text(size = 18,
                                  face = "bold"),
        legend.title = element_text(size = 16,
                                    hjust = 0.5),
        legend.text = element_text(size = 14),
        panel.spacing.y = unit(0.1, "cm")) +
  labs(title = "Heatmap of breast cancer genes",
       subtitle = "Based on tumor size",
       x = "Cancer related genes",
       y = NULL) 


# Write data --------------------------------------------------------------
ggsave(filename = "results/HeatMap_Class.png", plot = HM_class, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/HeatMap_TumorSize.png", plot = HM_TumorSize, width = 16, height = 9, dpi = 72)
