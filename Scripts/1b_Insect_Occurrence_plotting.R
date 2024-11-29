####### Identifying the knowledge and capacity gaps in Southeast Asian insect conservation
####### Author: Xin Rui Ong
####### (1b) Insect Occurrence - Plotting

# Description ----
## This script is for the plotting of cleaned GBIF occurrence records:
## Figure 2A: Map of insect occurrence records
## Figure 2B: Number of insect occurrence records across the years
## For cleaning of raw occurrence records, refer to "1a_Insect_Occurrence_cleaning.R".
## Files from Zenodo (https://doi.org/10.5281/zenodo.11195326): "Curated_Datasets.zip"

# Setup: Load packages and fonts ----
library(tidyverse)
windowsFonts(Roboto=windowsFont("Roboto Condensed"))

# Read data ----
all_occurrences <- 
  read.csv("Curated_Datasets/1_Insect_Occurrences.csv", header = T) # Cleaned occurrence records

# Determine top 10 insect orders in occurrence dataset
all_occurrences %>% filter(order != "") %>% 
  group_by(order) %>%
  summarise(count = n()) %>%
  top_n(n=10) %>%
  arrange(desc(count))

# Filter by the top 10 insect orders ----
order_filter <- c("Lepidoptera",
                  "Odonata",
                  "Hymenoptera",
                  "Coleoptera",
                  "Diptera",
                  "Hemiptera",
                  "Orthoptera",
                  "Blattodea",
                  "Trichoptera",
                  "Mantodea")

top10 <- 
  combined_cleaned %>%
  filter(order %in% order_filter)

top10$order <- factor(top10$order,
                      levels = c("Lepidoptera",
                                 "Odonata",
                                 "Hymenoptera",
                                 "Coleoptera",
                                 "Diptera",
                                 "Hemiptera",
                                 "Orthoptera",
                                 "Blattodea",
                                 "Trichoptera",
                                 "Mantodea"))

# Derive number of occurrence records per year and per insect order
top10_sum <-
  top10 %>% 
  group_by(year, order) %>%
  summarise(count = n())

# Derive number of occurrence records per Southeast Asian country
top10_country <-
  top10 %>% 
  group_by(countryCode) %>%
  summarise(count = n())

# Plotting ----
map_world <- borders(database = "world", fill="#444444", colour = "white") 

## Map of insect occurrence records (Figure 2A) ----
SEA_GBIF_map <- 
  top10 %>% 
  ggplot(aes(x = decimalLongitude,
             y = decimalLatitude,
             colour = order)) +
  map_world +
  geom_point(size = 0.5) +
  coord_equal(xlim = c(90, 150),
                         ylim = c(-12, 30)) +
  labs(colour = "Top 10 Insect Orders") +
  scale_colour_manual(values = 
                        c("#BE0032",
                          "#F3C300",
                          "#875692",
                          "#F38400",
                          "#A1CAF1",
                          "#C2B280",
                          "#848482",
                          "#008856",
                          "#E68FAC",
                          "#0067A5")) +
  guides(color = guide_legend(override.aes = 
                                list(size = 3,
                                     alpha = 1))) +
  theme_minimal() +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        text = element_text(family = "Roboto",
                            size = 14),
        legend.position = "bottom") +
  guides(fill = guide_legend(title.position = "top",
                             title.hjust = 0.5,
                             nrow = 2)) 
SEA_GBIF_map # Figure 2A

## Plot of number of occurrence records across the years (Figure 2B) ----
SEA_GBIF_plot <- 
  top10_sum %>%
  ggplot(aes(x = year,
             y = count,
             colour = order)) +
  geom_line(linewidth = 1.2) +
  geom_point(aes(colour = order),
                 size = 2,
                 shape = 21,
                 stroke = 1.5,
                 fill = "white") +
  labs(fill = "Insect Orders",
       x = "",
       y = "No. of Records") +
  scale_colour_manual(values = 
                        c("#BE0032",
                          "#F3C300",
                          "#875692",
                          "#F38400",
                          "#A1CAF1",
                          "#C2B280",
                          "#848482",
                          "#008856",
                          "#E68FAC",
                          "#0067A5")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90,
                                   vjust = 0.3),
        legend.position = "none",
        panel.background = element_rect(fill = "white",
                                        color = NA),
        text = element_text(family = "Roboto",
                            size = 16))
SEA_GBIF_plot # Figure 2B