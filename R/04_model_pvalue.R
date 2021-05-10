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


#proteomes_func <- proteomes_nested %>%
#  mutate(event = map(data, "OS event"), 
#         log2 = map(data, "log2_expression"))


proteomes_func <- proteomes_func %>%
  mutate(identified_as = case_when(p.value > 0.05 ~"Non-significant",
                                   p.value < 0.05 ~ "Significant"))
