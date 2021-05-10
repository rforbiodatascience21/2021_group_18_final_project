# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")


# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")
proteomes_clean_NA <- read_csv(file = "data/proteomes_clean_NA.csv.gz")

# Sample cancer genes
sample_genes_cancer <- proteomes_clean_NA %>%
  filter(RefSeqProteinID == "NP_009231" | RefSeqProteinID == "NP_000537"
         | RefSeqProteinID == "NP_009125" | RefSeqProteinID == "NP_000305"
         | RefSeqProteinID == "NP_004351" | RefSeqProteinID == "NP_000446"
         | RefSeqProteinID == "NP_004439" | RefSeqProteinID == "NP_001002295")

#Sampling 92 random genes, which cannot be the cancer genes
set.seed(429)
sample_genes_random <- proteomes_clean_NA %>%
  filter(RefSeqProteinID != "NP_009231" | RefSeqProteinID != "NP_000537"
         | RefSeqProteinID != "NP_009125" | RefSeqProteinID != "NP_000305"
         | RefSeqProteinID != "NP_004351" | RefSeqProteinID != "NP_000446"
         | RefSeqProteinID != "NP_004439" | RefSeqProteinID != "NP_001002295") %>%
  sample_n(92)

# Bind together, in order to contain random and cancer genes
sample_100_genes <- bind_rows(sample_genes_cancer, 
                              sample_genes_random)

# Make long data (excluding healthy persons)
sample_100_genes_long <- sample_100_genes %>%
  select(-c(`263d3f-I`, 
            `blcdb9-I`, 
            `c4155b-C`, 
            Frac_NA)) %>%
  pivot_longer(cols = -c("RefSeqProteinID"),
               names_to = "TCGA_ID",
               values_to = "log2_expression")

# Same for cancer data
sample_cancer_genes_long <- sample_genes_cancer %>%
  select(-c(`263d3f-I`, 
            `blcdb9-I`, 
            `c4155b-C`, 
            Frac_NA)) %>%
  pivot_longer(cols = -c("RefSeqProteinID"),
               names_to = "TCGA_ID",
               values_to = "log2_expression")


# Join and nest data to get HER2 positive/negative factor included
sample_100_genes_nested <- joined_data %>%
  select("TCGA_ID",
         "HER2_binary") %>%
  right_join(y = sample_100_genes_long,
             by = "TCGA_ID") %>% 
  select(-TCGA_ID) %>%
  group_by(RefSeqProteinID) %>%
  nest() %>%
  ungroup()

# Same for cancer data
sample_cancer_genes_nested <- joined_data %>%
  select("TCGA_ID",
         "HER2_binary") %>%
  right_join(y = sample_cancer_genes_long,
             by = "TCGA_ID") %>% 
  select(-TCGA_ID) %>%
  group_by(RefSeqProteinID) %>%
  nest() %>%
  ungroup()

# Make logistic expressions function
proteomes_func <- sample_100_genes_nested %>%
  mutate(mdl = map(data,
                   ~glm(HER2_binary ~ log2_expression, 
                        data = .,
                        family = binomial(link = "logit"))),
         tidying = map(mdl, conf.int = TRUE, tidy)) %>%
  unnest(tidying)

# Same for cancer data
proteomes_func_cancer <- sample_cancer_genes_nested %>%
  mutate(mdl = map(data,
                   ~glm(HER2_binary ~ log2_expression, 
                        data = .,
                        family = binomial(link = "logit"))),
         tidying = map(mdl, conf.int = TRUE, tidy)) %>%
  unnest(tidying)


# Excluding the intercept, identify significance and making negative log of p-value
# for better visualization. 
proteomes_func <- proteomes_func %>%
  filter(term != "(Intercept)") %>%
  mutate(identified_as = case_when(p.value > 0.05 ~"Non-significant",
                                   p.value < 0.05 ~ "Significant")) %>%
  mutate(neg_log10_p = -log10(p.value))

# Same for cancer data
proteomes_func_cancer <- proteomes_func_cancer %>%
  filter(term != "(Intercept)") %>%
  mutate(identified_as = case_when(p.value > 0.05 ~"Non-significant",
                                   p.value < 0.05 ~ "Significant")) %>%
  mutate(neg_log10_p = -log10(p.value))


# Making manhattan plot combining cancer genes and random genes
manhplot <- ggplot(proteomes_func, 
                   mapping = aes(x = reorder(RefSeqProteinID, 
                                             desc(neg_log10_p)), 
                                 y = neg_log10_p, 
                                 color = identified_as)) +
  geom_point(alpha = 0.25, size = 3) +
  geom_point(data = proteomes_func_cancer,
             mapping = aes(x = reorder(RefSeqProteinID, 
                                       desc(neg_log10_p)), 
                           y = neg_log10_p,
                           fill = identified_as))+
  geom_hline(yintercept = -log10(0.05), linetype = "dashed") + 
  labs(x = "Gene", 
       y = "Minus log 10(p)",
       title = "Manhattan plot of 100 genes",
       subtitle = "Including 8 cancer genes and 92 random selected genes.\nFaded = random genes") + 
  theme_classic(base_family = "Avenir", base_size = 10) +
  theme( 
    legend.position = "bottom",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.text.x = element_text(angle = 45, size = 6, vjust = 0.5)
  )


conf_int <- ggplot(proteomes_func,
                   mapping = aes(x = estimate,
                                 y = reorder(RefSeqProteinID, 
                                             desc(estimate)),
                                 color = identified_as)) +
  geom_point(alpha = 0.75, size = 2) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_errorbarh(aes(xmin = conf.low,
                     xmax = conf.high,
                     height = 0.2)) +
  labs(y = "RefSeqProteinID", 
       title = "Confidence interval plot with effect directions",
       subtitle = "Including 8 cancer genes and 92 random selected genes") +
  theme_classic(base_family = "Avenir", base_size = 10) +
  theme(legend.position = "bottom",
        panel.border = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.text.x = element_text(angle = 45, size = 6, vjust = 0.5)
  )

# Filtering to only get significant proteomes
proteomes_func_sig <- proteomes_func %>%
  filter(identified_as == "Significant") 

# Same for cancer
proteomes_func_sig_cancer <- proteomes_func_cancer %>%
  filter(identified_as == "Significant") 

conf_int_sig <- ggplot(data = proteomes_func_sig, 
                       mapping = aes(x = estimate,
                                     y = reorder(RefSeqProteinID, 
                                                 desc(estimate)))) +
  geom_point(alpha = 0.75, size = 2) +
  geom_point(data = proteomes_func_sig_cancer, 
             mapping = aes(x = estimate,
                           y = reorder(RefSeqProteinID, 
                                       desc(estimate)))) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_errorbarh(aes(xmin = conf.low,
                     xmax = conf.high)) +
  labs(y = "RefSeqProteinID", 
       title = "Confidence interval plot with effect directions - only significant",
       subtitle = "Only significant genes")+
  theme_classic(base_family = "Avenir", base_size = 8) +
  theme(
    legend.position = "bottom",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.text.x = element_text(angle = 45, size = 4, vjust = 0.5)
  )

# Write data --------------------------------------------------------------
ggsave(filename = "results/manhplot.png", plot = manhplot, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/conf_int.png", plot = manhplot, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/conf_int_sig.png", plot = manhplot, width = 16, height = 9, dpi = 72)
