# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")


# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")
proteomes_clean_NA <- read_csv(file = "data/proteomes_clean_NA.csv.gz")

cancer_genes <-
  c("NP_009231", 
  "NP_000537", 
  "NP_009125", 
  "NP_000305", 
  "NP_004351", 
  "NP_000446",
  "NP_004439",
  "NP_001002295")

proteomes_clean_long <- proteomes_clean_NA %>%
  select(-c(`263d3f-I`, 
            `blcdb9-I`, 
            `c4155b-C`)) %>%
  select(-Frac_NA) %>%
  pivot_longer(cols = -c("RefSeqProteinID"),
                names_to = "TCGA_ID",
                values_to = "log2_expression")
  
proteomes_clean_long <- proteomes_clean_long %>%
  filter(RefSeqProteinID == "NP_009231" | RefSeqProteinID == "NP_000537"
         | RefSeqProteinID == "NP_009125" | RefSeqProteinID == "NP_000305"
         | RefSeqProteinID == "NP_004351" | RefSeqProteinID == "NP_000446"
         | RefSeqProteinID == "NP_004439" | RefSeqProteinID == "NP_001002295")


proteomes_nested <- joined_data %>%
  select("TCGA_ID",
         "HER2_binary") %>%
  right_join(y = proteomes_clean_long,
            by = "TCGA_ID") %>% 
  select(-TCGA_ID) %>%
  group_by(RefSeqProteinID) %>%
  nest() %>%
  ungroup()


proteomes_func <- proteomes_nested %>%
  mutate(mdl = map(data,
                 ~glm(HER2_binary ~ log2_expression, 
                      data = .,
                      family = binomial(link = "logit"))),
       tidying = map(mdl, conf.int = TRUE, tidy)) %>%
  unnest(tidying)

proteomes_func <- proteomes_func %>%
  filter(term == "log2_expression")

proteomes_func_sig <- proteomes_func %>%
  mutate(identified_as = case_when(p.value > 0.05 ~"Non-significant",
                                   p.value < 0.05 ~ "Significant"))

proteomes_func_sig <- proteomes_func_sig %>%
  mutate(neg_log10_p = -log10(p.value))


manhplot <- ggplot(proteomes_func_sig, 
                   mapping = aes(x = reorder(RefSeqProteinID, desc(neg_log10_p)), 
                                 y = neg_log10_p, 
                                 color = identified_as)) +
  geom_point(alpha = 0.75, size = 2) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed") + 
  labs(x = "Gene", 
       y = "Minus log 10(p)") + 
  theme_classic(base_family = "Avenir", base_size = 8) +
  theme( 
    legend.position = "bottom",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.text.x = element_text(angle = 45, size = 4, vjust = 0.5)
  )
