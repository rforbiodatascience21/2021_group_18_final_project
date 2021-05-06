# Clear workspace ---------------------------------------------------------
rm(list = ls())

# Load data ---------------------------------------------------------------
joined_data <- read_csv(file = "data/joined_data.csv.gz")


# PCA ---------------------------------------------------------------

### Class
proteomes_data <- joined_data %>%
  select(Class, NP_009231, 
         NP_000537, 
         NP_009125, 
         NP_000305, 
         NP_004351, 
         NP_000446,
         NP_004439,
         NP_001002295)

pca <- proteomes_data %>%
  select(where(is.numeric)) %>%
  prcomp(center = TRUE, scale=TRUE)


#Percent of variance explained in PC1-PC8
PCA_percent1 <- pca %>%
  tidy(matrix = "eigenvalues")%>%
  ggplot(mapping = aes(PC, percent)) +
  geom_col(fill = "blue", alpha = 0.6) +
  scale_x_continuous(breaks = 1:8) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))) +
  theme_light() +
  ylab("Percentage of variance explained")


#Plot PCA matrix points
PCA_plot1 <- pca %>%
  augment(proteomes_data) %>%
  ggplot(mapping = aes(x = .fittedPC1,
                       y = .fittedPC2,
                       color = Class)) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") +
  theme_light()


#Arrow style
pca %>%
  tidy(matrix = "rotation")

# define arrow style for plotting
arrow_style <- arrow(
  angle = 20, ends = "first", type = "closed", length = grid::unit(8, "pt")
)

# plot rotation matrix
pca %>%
  tidy(matrix = "rotation") %>%
  pivot_wider(names_from = "PC", names_prefix = "PC", values_from = "value") %>%
  ggplot(aes(PC1, PC2)) +
  geom_segment(xend = 0, yend = 0, arrow = arrow_style) +
  geom_text(
    aes(label = column),
    hjust = 1, nudge_x = -0.02, 
    color = "#904C2F"
  ) +
  xlim(-1.25, .5) + ylim(-.5, 1) +
  coord_fixed() + # fix aspect ratio to 1:1
  theme_minimal_grid(12)





### Tumor
proteomes_data2 <- joined_data %>%
  select(Tumor, NP_009231, 
         NP_000537, 
         NP_009125, 
         NP_000305, 
         NP_004351, 
         NP_000446,
         NP_004439,
         NP_001002295)

pca2 <- proteomes_data %>%
  select(where(is.numeric)) %>%
  prcomp(center = TRUE, scale=TRUE)


#Percent of variance explained in PC1-PC8
PCA_percent2 <- pca2 %>%
  tidy(matrix = "eigenvalues")%>%
  ggplot(mapping = aes(PC, percent)) +
  geom_col(fill = "blue", alpha = 0.6) +
  scale_x_continuous(breaks = 1:8) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))) +
  theme_light() +
  ylab("Percentage of variance explained")

#Plot PCA matrix points
PCA_plot2 <- pca2 %>%
  augment(proteomes_data2) %>%
  ggplot(mapping = aes(x = .fittedPC1,
                       y = .fittedPC2,
                       color = Tumor)) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") +
  theme_light()



# Write data --------------------------------------------------------------
ggsave(filename = "results/PCA_percent1.png", plot = PCA_percent1, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/PCA_plot1.png", plot = PCA_plot1, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/PCA_percent2.png", plot = PCA_percent2, width = 16, height = 9, dpi = 72)
ggsave(filename = "results/PCA_plot2.png", plot = PCA_plot2, width = 16, height = 9, dpi = 72)


