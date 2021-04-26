# Load data
alon_clean_aug <- read_tsv(file = "data/alon_clean_aug.tsv.gz")

#Looking into X1

#Making a linear model of X1
geneX1 <- alon_clean_aug %>% 
  glm(tissue_discrete ~ X1,
      data = .,
      family = binomial(link = "logit"))
#Intercept = -0.4564067
#Coefficient for X1 = 0.0001556009

#P-value for X1
tidy(geneX1) %>% 
  filter(term == "X1") %>% 
  select(term, p.value)
#P-value = 0.121
