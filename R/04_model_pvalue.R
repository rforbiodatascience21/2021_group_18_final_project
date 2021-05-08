cancer_genes <-
  c("NP_009231", 
"NP_000537", 
"NP_009125", 
"NP_000305", 
"NP_004351", 
"NP_000446",
"NP_004439",
"NP_001002295")

random_genes <- proteomes_clean_NA %>%
  select(-Frac_NA) %>%
  pivot_longer(cols = -c("RefSeqProteinID"),
               names_to = "TCGA_ID",
               values_to = "log2_expression" ) %>%
  sample_n(92) 


proteomes_clean_long <- proteomes_clean_NA %>%
  select(-Frac_NA) %>%
  pivot_longer(cols = -c("RefSeqProteinID"),
                names_to = "TCGA_ID",
                values_to = "log2_expression" ) %>%
  filter(RefSeqProteinID == cancer_genes) 


proteomes_nested <- joined_data %>%
  select("TCGA_ID",`OS event`) %>%
  full_join(y = proteomes_clean_long,
            by = "TCGA_ID") %>% 
  select(-TCGA_ID) %>%
  group_by(RefSeqProteinID) %>%
  nest() %>%
  ungroup()


proteomes_func <- proteomes_nested %>%
  mutate(mdl = map(data,
                 ~glm(`OS event` ~ log2_expression, 
                      data = .,
                      family = binomial(link = "logit"))),
       tidying = map(mdl, conf.int = TRUE, tidy)) %>%
  unnest(tidying)



proteomes_func <- proteomes_nested %>%
  pluck("data") %>%
  glm("OS event" ~ log2_expression,
      data = proteomes_func,
      family = binomial(link = "logit"))

# **Q1: What are the coefficients for the intercept and your gene?**\\
# Svar: intercept; -0.737, g2E09; -2.184
# ```{r}
# gene <- gravier_data %>% 
#   glm(outcome ~ g2E09,
#       data = .,
#       family = binomial(link = "logit"))
# ```
# 
# **Q2: What is the p-value for your gene?**\\
# ```{r}
# library(broom)
# tidy(gene)
# ```




proteomes_func <- proteomes_func %>%
  mutate(identified_as = case_when(p.value > 0.05 ~"Non-significant",
                                   p.value < 0.05 ~ "Significant"))

