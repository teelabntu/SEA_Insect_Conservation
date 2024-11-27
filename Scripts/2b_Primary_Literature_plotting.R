####### Identifying the knowledge and capacity gaps in Southeast Asian insect conservation
####### Author: Xin Rui Ong
####### (2b) Primary Literature - Plotting

# Description ----
## This script is for the plotting of our primary literature data:
## Figure 3A: Number of insect studies per year
## Figure 3B: Number of insect studies per study country
## Figure 3C: Co-occurrence matrix of research theme VS insect order
## Figure 3D: Co-occurrence matrix of study country VS research theme
## Figure 3E: Co-occurrence matrix of study country VS insect order
## Files from Zenodo (https://zenodo.org/records/14227113): SEA_Insect_Conservation_Quantitative_Review_Dataset_v3.xlsx

# Setup: Load packages ----
library(readxl)
library(tidyverse)
library(data.table)
library(ggsci)
windowsFonts(Roboto=windowsFont("Roboto Condensed"))

# Read data ----
pri_lit <- 
  read_excel("data/SEA_Insect_Conservation_Quantitative_Review_Dataset_v3.xlsx",
             sheet = "(2) Primary Literature") # Cleaned primary literature records
pri_lit <- data.table(pri_lit)  # convert to data.table

# Plot number of insect studies per year (Figure 3A) ----
year_summary <- 
  pri_lit %>%
  group_by(Year) %>%
  summarise(count = n())

year_plot <- 
  year_summary %>% 
  filter(Year != "2024") %>%
  ggplot(aes(x = forcats::fct_rev(as.factor(Year)),
             y = count)) +
  geom_point(size = 6,
             color = "#e37e00") +
  geom_segment(aes(xend = forcats::fct_rev(as.factor(Year)),
                   y = 0,
                   yend = count), 
               color = "#e37e00",
               size = 1.3) +
  labs(x = "",
       y = "No. of Studies",
       fill = "") +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.background = element_rect(fill = "white",
                                        color = NA),
        text = element_text(family = "Roboto",
                            size = 16),
        legend.position = "none") +
  coord_flip()
year_plot # Figure 3A

# Plot number of insect studies per study country (Figure 3B) ----
country <- pri_lit[, .(Study_Country=tstrsplit(Study_Country, ";",fixed=F)), 
                   by = SN]
country_summary <-
  country %>%
  group_by(Study_Country) %>%
  summarise(count = n())
country_summary$Study_Country <- factor(country_summary$Study_Country,
                                        levels = c("Timor-Leste",
                                                   "Brunei",
                                                   "Cambodia",
                                                   "Singapore",
                                                   "Laos",
                                                   "Myanmar",
                                                   "Philippines",
                                                   "Vietnam",
                                                   "Indonesia",
                                                   "Malaysia",
                                                   "Thailand"))
country_plot <- 
  country_summary %>% 
  ggplot() +
  geom_bar(aes(x = count,
               y = Study_Country),
           stat = "identity",
           colour = "#748c2e",
           fill = "#748c2e") +
  labs(x = "",
       y = "",
       fill = "") +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.background = element_rect(fill = "white",
                                        color = NA),
        text = element_text(family = "Roboto",
                            size = 20),
        legend.position = "none")
country_plot # Figure 3B

# Plot co-occurrence matrices ----
## Create vectors for insect orders, study country & research themes
orders <- c("BLATTODEA", "COLEOPTERA", "DIPTERA", "EPHEMEROPTERA",
            "HEMIPTERA", "HYMENOPTERA", "LEPIDOPTERA", "ODONATA",
            "ORTHOPTERA", "TRICHOPTERA")
countries <- c("Brunei", "Cambodia", "Indonesia", "Laos", "Malaysia",
               "Myanmar", "Philippines", "Singapore",
               "Thailand", "Timor-Leste", "Vietnam")
themes <- c("Edible insects & ethnoentomology",
            "Forensic entomology",
            "Insect conservation & ecology",
            "Insect disease vectors",
            "Insect genetics & phylogeny",
            "Insect pest & biological control",
            "Insect taxonomy & natural history",
            "Invasive species",
            "Life history, physiological & behavioural adaptations")

## Transpose data ----
## Research theme & insect order
nw_to <- pri_lit[, .(theme.order=tstrsplit(theme.order, ";",fixed=T)), 
                 by = SN]  
nw_to1 <- as_tibble(nw_to)  # convert data.table to tibble
nw_to1$theme.order <- as.character(nw_to1$theme.order)

## Study country & research theme
nw_ct <- pri_lit[, .(country.theme=tstrsplit(country.theme, ";",fixed=T)), 
                 by = SN]  
nw_ct1 <- as_tibble(nw_ct)  # convert data.table to tibble
nw_ct1$country.theme <- as.character(nw_ct1$country.theme)

## Study country & insect order
nw_co <- pri_lit[, .(country.order=tstrsplit(country.order, ";",fixed=T)), 
                 by = SN]
nw_co1 <- as_tibble(nw_co)  # convert data.table to tibble
nw_co1$country.order <- as.character(nw_co1$country.order)

## Create co-occurrence matrices ----
## Research theme & insect order
cocc_to <- crossprod(table(nw_to1[1:2]))  
cocc_to <- as.data.frame(cocc_to)
theme <- rownames(cocc_to)
cocc_to <- cbind(theme,cocc_to)
rownames(cocc_to) <- NULL
cocc_to1 <- melt(cocc_to)
cocc_to1 <- cocc_to1 %>% 
  rename(order = variable,
         count = value)

cocc_to1 <- filter(cocc_to1, theme %in% themes)
cocc_to1 <- filter(cocc_to1, order %in% orders)

## Study country & research theme
cocc_ct <- crossprod(table(nw_ct1[1:2]))  
cocc_ct <- as.data.frame(cocc_ct)
country <- rownames(cocc_ct)
cocc_ct <- cbind(country,cocc_ct)
rownames(cocc_ct) <- NULL
cocc_ct1 <- melt(cocc_ct)
cocc_ct1 <- cocc_ct1 %>% 
  rename(theme = variable,
         count = value)

cocc_ct1 <- filter(cocc_ct1, country %in% countries)
cocc_ct1 <- filter(cocc_ct1, theme %in% themes)

## Study country & insect order
cocc_co <- crossprod(table(nw_co1[1:2]))  
cocc_co <- as.data.frame(cocc_co)
country <- rownames(cocc_co)
cocc_co <- cbind(country,cocc_co)
rownames(cocc_co) <- NULL
cocc_co1 <- melt(cocc_co)
cocc_co1 <- cocc_co1 %>% 
  rename(order = variable,
         count = value)

cocc_co1 <- filter(cocc_co1, country %in% countries)
cocc_co1 <- filter(cocc_co1, order %in% orders)

### Plot research theme & insect order matrix (Figure 3C) ----
theme_order <- cocc_to1 %>% ggplot() +
  geom_tile(aes(x=order, y=theme, fill=count)) +
  labs(x = "", y = "", fill = "Co-occurrence") +
  scale_x_discrete(labels = c("Blattodea", "Coleoptera", "Diptera",
                              "Ephemeroptera", "Hemiptera", "Hymenoptera",
                              "Lepidoptera", "Odonata", "Orthoptera", "Trichoptera"))+
  scale_y_discrete(limits = rev,
                   position = "right",
                   labels = c("Life History, Physiological & Behavioural Adaptations",
                              "Invasive Species",
                              "Insect Taxonomy & Natural History",
                              "Insect Pests & Biological Control",
                              "Insect Genetics & Phylogeny",
                              "Insect Disease Vectors",
                              "Insect Conservation & Ecology",
                              "Forensic Entomology",
                              "Edible Insects & Ethnoentomology")) +
  scale_fill_material("pink") +
  theme_minimal() +
  theme(text = element_text(family = "Roboto"),
        axis.text = element_text(size = 20),
        legend.key.width = unit(1.2, 'cm'),
        legend.title = element_text(size = 18),
        legend.text = element_text(size = 18),
        legend.position = "bottom",
        axis.text.x = element_text(angle = 90,
                                   vjust = 0.5,
                                   hjust = 0.95))
theme_order # Figure 3C

### Plot study country & research theme matrix (Figure 3D) ----
cocc_ct1$country <- factor(cocc_ct1$country,
                           levels = c("Brunei", "Cambodia", "Indonesia", "Laos", "Malaysia",
                                      "Myanmar", "Philippines", "Singapore",
                                      "Thailand", "Timor-Leste", "Vietnam"))

country_theme <- cocc_ct1 %>% ggplot() +
  geom_tile(aes(x=country, y=theme, fill=count)) +
  scale_x_discrete(labels = c("Brunei", "Cambodia", "Indonesia", "Laos", 
                              "Malaysia", "Myanmar", "Philippines", "Singapore", 
                              "Thailand", "Timor-Leste", "Vietnam")) +
  labs(x = "", y = "", fill = "Co-occurrence") +
  scale_y_discrete(limits = rev,
                   position = "right",
                   labels = c("Life History, Physiological & Behavioural Adaptations",
                              "Invasive Species",
                              "Insect Taxonomy & Natural History",
                              "Insect Pests & Biological Control",
                              "Insect Genetics & Phylogeny",
                              "Insect Disease Vectors",
                              "Insect Conservation & Ecology",
                              "Forensic Entomology",
                              "Edible Insects & Ethnoentomology")) +
  scale_fill_material("deep-orange") +
  theme_minimal() +
  theme(text = element_text(family = "Roboto"),
        axis.text = element_text(size = 20),
        legend.key.width = unit(2, 'cm'),
        legend.title = element_text(size = 18),
        legend.text = element_text(size = 18),
        legend.position = "bottom",
        axis.text.x = element_text(angle = 90,
                                   vjust = 0.5,
                                   hjust = 0.95))
country_theme # Figure 3D

### Plot study country & insect order matrix (Figure 3E) ----
cocc_co1$country <- factor(cocc_co1$country,
                           levels = c("Brunei", "Cambodia", "Indonesia", "Laos", "Malaysia",
                                      "Myanmar", "Philippines", "Singapore",
                                      "Thailand", "Timor-Leste", "Vietnam"))

country_order <- cocc_co1 %>% ggplot() +
  geom_tile(aes(x=country, y=order, fill=count)) +
  labs(x = "", y = "", fill = "Co-occurrence") +
  scale_x_discrete(labels = c("Brunei", "Cambodia", "Indonesia", "Laos", 
                              "Malaysia", "Myanmar", "Philippines", "Singapore", 
                              "Thailand", "Timor-Leste", "Vietnam")) +
  scale_y_discrete(limits = rev,
                   position = "right",
                   labels = c("Trichoptera",
                              "Orthoptera",
                              "Odonata",
                              "Lepidoptera",
                              "Hymenoptera",
                              "Hemiptera",
                              "Ephemeroptera",
                              "Diptera",
                              "Coleoptera",
                              "Blattodea")) +
  scale_fill_material("teal") +
  theme_minimal() +
  theme(text = element_text(family = "Roboto"),
        axis.text = element_text(size = 20),
        
        legend.key.width = unit(1.2, 'cm'),
        legend.title = element_text(size = 18),
        legend.text = element_text(size = 18),
        legend.position = "bottom",
        axis.text.x = element_text(angle = 90,
                                   vjust = 0.5,
                                   hjust = 0.95))
country_order # Figure 3E