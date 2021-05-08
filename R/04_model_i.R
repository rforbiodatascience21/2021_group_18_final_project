# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load libraries ----------------------------------------------------------
library("tidyverse")


# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")
joined_healthy_data <- read_csv(file = "data/joined_healthy_data.csv.gz")
proteomes_clean_NA <- read_csv(file = "data/proteomes_clean_NA.csv.gz")

###### Joined healthy data
#263d3f-I
#blcdb9-I
#c4155b-C

joined_healthy_data <- proteomes_clean_NA %>% 
  select(`RefSeqProteinID`, 
         `263d3f-I`, 
         `blcdb9-I`, 
         `c4155b-C`)

#Interrogation of genes related to breast cancer
# BRCA1 = NP_009231
# TP53 = NP_000537
# CHEK2 = NP_009125, NP_665861
# PTEN = NP_000305
# CDH1 = NP_004351
# STK11 = NP_000446
# ERRB2 / HER2 = NP_004439
# GATA3 = NP_001002295

#This analysis will illustrate the differences in gene expression for persons who do
#not have a tumor and persons with a tumor
#Selecting sample ID's with T1 and T3 and lymph spread (N1-N3) and BC genes
#This is done so we can see if there is a difference between tumor sizes also
#Dropping the ones that do not have measurement of all the genes
Tumor_sample <- joined_data %>%
  filter(Tumor == "T1"  | Tumor == "T3") %>%
  filter(Node == "N1" | Node == "N2"| Node == "N3") %>% 
  select(`TCGA_ID`, `NP_009231`,`NP_000537`, `NP_009125`, `NP_665861`, `NP_000305`,
         `NP_004351`, `NP_000446`, `NP_004439`, `NP_001002295`) %>% 
  drop_na()
  
#Make longer
Tumor_sample_long <- Tumor_sample %>%
  pivot_longer(cols = -c("TCGA_ID"),
               names_to = "RefSeqProteinID",
               values_to = "value" )

#Selecting only the same genes for the healthy data and make it longer
# Helathy data does not have BRCA1 (NP_009231) expression, as it is only seen in BC
joined_healthy_longer <- joined_healthy_data %>% 
  pivot_longer(cols = -c(RefSeqProteinID),
               names_to = "TCGA_ID",
               values_to = "value") %>% 
  filter(RefSeqProteinID == "NP_009231" | RefSeqProteinID == "NP_000537" |
         RefSeqProteinID == "NP_009125" | RefSeqProteinID == "NP_665861" |
         RefSeqProteinID == "NP_000305" | RefSeqProteinID == "NP_004351" |
         RefSeqProteinID == "NP_000446" | RefSeqProteinID == "NP_004439" |
         RefSeqProteinID == "NP_001002295")
  
#Joined dataframe with sample from tumor and healthy data
Sample_Tumor_and_Healthy <- full_join(joined_healthy_longer,Tumor_sample_long)


############ Heatmap ############
Sample_Tumor_and_Healthy %>% 
ggplot(mapping = aes(x = TCGA_ID, 
                     y = RefSeqProteinID, 
                     fill = value)) +
  geom_tile(alpha=0.9) +
  theme_minimal() +
  scale_fill_gradient2(low = "blue", 
                       mid = "white", 
                       high = "red") +
  theme(axis.text.x=element_text(angle=45, 
                                 vjust = 1, 
                                 hjust = 1), 
        legend.position = "right", 
        aspect.ratio = 1)
#Kan man på en måde opdele dem så dem der er T1 kommmer først, så kommer T3 også de healthy?
#Så man kan se expressions ved siden af hinanden, måske lave tekst i toppen?

############# PCA ##############
install.packages("cowplot")
install.packages("broom")
library(cowplot)
library(broom)

#To make the PCA we can use all the gene expressions to see if the healthy samples cluster
#the same way and the tumor samples cluster the same way
#Remove all the genes that contain NA -> can evt. use the average method instead?
#Make it wide
Tumor_sample_longer <- joined_data %>%
  filter(Tumor == "T1"  | Tumor == "T3") %>%
  filter(Node == "N1" | Node == "N2"| Node == "N3") %>% 
  select(-c(1:30)) %>%
  pivot_longer(cols = -c("TCGA_ID"),
               names_to = "RefSeqProteinID",
               values_to = "value")
  
Healthy_longer <- joined_healthy_data %>% 
  pivot_longer(cols = -c(RefSeqProteinID),
               names_to = "TCGA_ID",
               values_to = "value")

Sample_Tumor_and_Healthy_long <- full_join(Tumor_sample_longer,Healthy_longer) %>%
  drop_na()

Sample_Tumor_and_Healthy_wide <- Sample_Tumor_and_Healthy_long %>%
  pivot_wider(names_from = "TCGA_ID",
              values_from = "value")

#Hvorfor er der stadig NA værdier i den når jeg har droppet dem??
#Nedenstående virker fint hvis man bruger det lille datasæt med få gener.

pca_fit <- Sample_Tumor_and_Healthy_wide %>%
  select(where(is.numeric)) %>% # retain only numeric columns
  prcomp(center = TRUE, 
         scale = TRUE) # do PCA on scaled data

#The below code takes the pca values and extracts the rotation matrix
pca_fit %>%
  tidy(matrix = "rotation")

#Code below makes the arrows
arrow_style <- arrow(angle = 20, 
                     ends = "first", 
                     type = "closed", 
                     length = grid::unit(8, "pt"))

#Plot PCA rotation matrix
pca_fit %>%
  tidy(matrix = "rotation") %>%
  pivot_wider(names_from = "PC", 
              names_prefix = "PC", 
              values_from = "value") %>%
  ggplot(aes(PC1, PC2)) +
  geom_segment(xend = 0, 
               yend = 0, 
               arrow = arrow_style) +
  geom_text(aes(label = column),
            hjust = 1, 
            nudge_x = -0.02, 
            color = "#904C2F") +
  coord_fixed() + # fix aspect ratio to 1:1
  theme_minimal_grid(12)

#Her kan vi se at de healthy cluster sammen, men ved ikke lige hvilke der er T1 og T3
#måske man kan tilføje en legend eller noget her også der kan farve dem i gruppetype?




