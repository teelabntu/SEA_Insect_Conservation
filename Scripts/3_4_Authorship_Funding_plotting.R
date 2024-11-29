####### Identifying the knowledge and capacity gaps in Southeast Asian insect conservation
####### Author: Xin Rui Ong
####### (3 & 4) Authorship & Funding - Plotting

# Description ----
## This script is for the plotting of our authorship and funding data:
## Figure 4A: Proportion of authorship and funding sources by study country
## Figure 4B: Proportion of authorship and funding sources by year
## Files from Zenodo (https://doi.org/10.5281/zenodo.11195326): "Curated_Datasets.zip"

# Setup: Load packages ----
library(tidyverse)
library(data.table)
library(patchwork)
windowsFonts(Roboto=windowsFont("Roboto Condensed"))

# Read data ----
authors <- 
  read.csv("Curated_Datasets/3_Authorship.csv",
           header = T) # Authorship information (derived from primary literature records)
funding <- 
  read.csv("Curated_Datasets/4_Funding.csv",
           header = T) # Funding information (derived from primary literature records)

authors <- data.table(authors)  # convert to data.table
funding <- data.table(funding)  # convert to data.table

# Plot proportion of authorship and funding sources by study country (Figure 4A) ----
## Prepare data
author_loc <- authors %>% filter(Year != "2024")
fund_loc <- funding %>% filter(Funding_Region != "NA",
                               Year != "2024")

author_loc_co <- author_loc[, .(study_country_author_region=tstrsplit(study_country_author_region,";",fixed=T)), 
                            by=Author_ID]
author_loc_co <- as_tibble(author_loc_co)  # convert data.table to tibble
author_loc_co$study_country_author_region <- as.character(author_loc_co$study_country_author_region)

fund_loc_co <- fund_loc[, .(study_country_funding_region=tstrsplit(study_country_funding_region, ";",fixed=T)), 
                        by=SN]
fund_loc_co <- as_tibble(fund_loc_co)  # convert data.table to tibble
fund_loc_co$study_country_funding_region <- as.character(fund_loc_co$study_country_funding_region)

study_countries <- c("Brunei", "Cambodia", "Timor-Leste", "Indonesia", "Laos", 
                     "Malaysia", "Myanmar", "Philippines", "Singapore", 
                     "Thailand", "Vietnam")
localities <- c("study_country", "SEA", "other_regions")

## Create co-occurrence matrices
author_loc_cocc <- crossprod(table(author_loc_co[1:2]))  
author_loc_cocc <- as.data.frame(author_loc_cocc)
study_cntry <- rownames(author_loc_cocc)
author_loc_cocc <- cbind(study_cntry,author_loc_cocc)
rownames(author_loc_cocc) <- NULL
author_loc_cocc1 <- melt(author_loc_cocc)
author_loc_cocc1 <- author_loc_cocc1 %>% 
  rename(author_loc = variable,
         count = value)

author_loc_cocc1 <- filter(author_loc_cocc1, study_cntry %in% study_countries)
author_loc_cocc1 <- filter(author_loc_cocc1, author_loc %in% localities)
author_loc_cocc2 <- author_loc_cocc1 %>%
  filter(count != 0) %>%
  group_by(study_cntry) %>%
  mutate(freq = (count/sum(count))*100)

fund_loc_cocc <- crossprod(table(fund_loc_co[1:2]))  
fund_loc_cocc <- as.data.frame(fund_loc_cocc)
study_cntry <- rownames(fund_loc_cocc)
fund_loc_cocc <- cbind(study_cntry,fund_loc_cocc)
rownames(fund_loc_cocc) <- NULL
fund_loc_cocc1 <- melt(fund_loc_cocc)
fund_loc_cocc1 <- fund_loc_cocc1 %>% 
  rename(fund_loc = variable,
         count = value)

fund_loc_cocc1 <- filter(fund_loc_cocc1, study_cntry %in% study_countries)
fund_loc_cocc1 <- filter(fund_loc_cocc1, fund_loc %in% localities)
fund_loc_cocc2 <- fund_loc_cocc1 %>%
  filter(count != 0) %>%
  group_by(study_cntry) %>%
  mutate(freq = (count/sum(count))*100)

## Authorship plot ----
author_loc_cocc2$author_loc <- 
  factor(author_loc_cocc2$author_loc,
         levels = c("other_regions",
                    "SEA",
                    "study_country"))

author_country_prop <- author_loc_cocc2 %>% 
  ggplot(aes(x = forcats::fct_rev(study_cntry),
             y = freq,
             fill = author_loc)) +      
  geom_bar(position = "stack",
           stat = "identity",
           width = 0.6) +
  theme_minimal() +
  labs(x = "", y = "", fill = "") +
  scale_fill_manual(values = c("#F6A600FF",
                               "#222222FF",
                               "#0067A5FF"),
                    labels = c("From other regions",
                               "From Southeast Asia",
                               "From study country")) +
  scale_y_reverse() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.background = element_rect(fill = "white",
                                        color = NA),
        text = element_text(family = "Roboto",
                            size = 16),
        legend.position = "none") +
  coord_flip()
author_country_prop

## Funding plot ----
fund_loc_cocc2$fund_loc <- 
  factor(fund_loc_cocc2$fund_loc,
         levels = c("other_regions",
                    "SEA",
                    "study_country"))

fund_country_prop <- fund_loc_cocc2 %>% 
  ggplot(aes(x = forcats::fct_rev(study_cntry),
             y = freq,
             fill = fund_loc)) +      
  geom_bar(position = "stack",
           stat = "identity",
           width = 0.6) +
  theme_minimal() +
  labs(x = "", y = "", fill = "", title = "") +
  scale_fill_manual(values = c("#F6A600FF",
                               "#222222FF",
                               "#0067A5FF"),
                    labels = c("From other regions",
                               "From Southeast Asia",
                               "From study country")) +
  theme(axis.text.x = element_text(),
        axis.text.y = element_text(hjust = 0.5, vjust = 0.5),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.background = element_rect(fill = "white",
                                        color = NA),
        text = element_text(family = "Roboto",
                            size = 16),
        legend.position = "none") +
  coord_flip()
fund_country_prop

## Combined plot (Figure 4A) ----
fund_author_country_prop <-  (author_country_prop + fund_country_prop )
fund_author_country_prop # Figure 4A

# Plot proportion of authorship and funding sources by year (Figure 4B) ----
## Determine proportion of determined localities by year
authors_summary <-
  authors %>% filter(Year != "2024") %>%
  group_by(Year, Author_Locality) %>%
  summarise(count = n())

fund_summary <-
  funding %>% filter(Year != "2024") %>%
  filter(Funding_Region != "NA") %>%
  group_by(Year, Funding_Region) %>%
  summarise(count = n())

## Calculate proportions
authors_prop <- authors_summary %>%
  group_by(Year) %>%
  mutate(freq = (count / sum(count)) * 100)
authors_prop$Author_Locality <- 
  factor(authors_prop$Author_Locality,
         levels = c("other_regions",
                    "SEA",
                    "study_country"))

fund_prop <- fund_summary %>%
  group_by(Year) %>%
  mutate(freq = (count / sum(count)) * 100)

fund_prop$Funding_Region <- 
  factor(fund_prop$Funding_Region,
         levels = c("other_regions",
                    "SEA",
                    "study_country"))

## Authorship plot ----
author_prop_f <- authors_prop %>% 
  ggplot(aes(x = forcats::fct_rev(as.factor(Year)),
             y = freq,
             fill = Author_Locality)) +      
  geom_bar(position = "stack",
           stat = "identity",
           width = 0.7) +
  theme_minimal() +
  labs(x = "", y = "% of Authors", fill = "") +
  scale_fill_manual(values = c("#F6A600FF",
                               "#222222FF",
                               "#0067A5FF"),
                    labels = c("From other regions",
                               "From Southeast Asia",
                               "From study country")) +
  scale_y_reverse() +
  theme(axis.text.y = element_blank(),
        axis.ticks.x = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.background = element_rect(fill = "white",
                                        color = NA),
        text = element_text(family = "Roboto",
                            size = 16),
        legend.position = "bottom") +
  coord_flip()
author_prop_f

## Funding plot ----
fund_prop_f <- fund_prop %>% 
  ggplot(aes(x = forcats::fct_rev(as.factor(Year)),
             y = freq,
             fill = Funding_Region)) +      
  geom_bar(position = "stack",
           stat = "identity",
           width = 0.7) +
  theme_minimal() +
  labs(x = "", y = "% of Funding Sources", fill = "") +
  scale_fill_manual(values = c("#F6A600FF",
                               "#222222FF",
                               "#0067A5FF"),
                    labels = c("From other regions",
                               "From Southeast Asia",
                               "From study country")) +
  theme(axis.text.x = element_text(),
        axis.text.y = element_text(hjust = 0.5, vjust = 0.5),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.background = element_rect(fill = "white",
                                        color = NA),
        text = element_text(family = "Roboto",
                            size = 16),
        legend.position = "bottom") +
  coord_flip()
fund_prop_f

## Combined plot (Figure 4B) ----
fund_author_prop <- (author_prop_f + fund_prop_f) +
  plot_layout(guides = 'collect') & theme(legend.position = 'bottom')
fund_author_prop # Figure 4B