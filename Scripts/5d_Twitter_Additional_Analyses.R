####### Identifying the knowledge and capacity gaps in Southeast Asian insect conservation
####### Author: Xin Rui Ong
####### (5X) Twitter #conservation posts - Additional Analyses (Bootstrapped dataset & trend comparisons)

# Description ----
## This script details our bootstrapping and trend comparison analyses for Twitter dataset.
## Files from Zenodo (https://zenodo.org/records/14227113): SEA_Insect_Conservation_Quantitative_Review_Dataset_v3.xlsx

# Setup: Load packages ----
library(readxl)
library(tidyverse)
library(zoo)
library(wordcloud2)
library(ggwordcloud)
windowsFonts(Roboto=windowsFont("Roboto Condensed"))

# Read data ----
conservation_posts <- 
  read_excel("data/SEA_Insect_Conservation_Quantitative_Review_Dataset_v3.xlsx",
             sheet = "(5-1) Twitter") # Twitter #conservation posts with assigned taxonomic group (see xxx for spaCy classifier script)
conservation_posts$Day_Posted <- 
  format(conservation_posts$Day_Posted, format="%m-%d")

# Create datasets for plotting ----
## Bootstrapped dataset of 1,500 randomly selected posts per year
set.seed(1234)
conservation_posts_BS <- 
  conservation_posts %>%  
  group_by(Year) %>%
  sample_n(1500, replace = T)

conservation_posts_count_BS <- 
  conservation_posts_BS %>%
  group_by(Year, Category2) %>%
  summarise(count = n()) %>%
  mutate(freq = (count/sum(count)) * 100)

## Create filtered datasets of the next four most common hashtags other than #conservation
#### Identify top most common hashtags
hashtag_pat <- "#[a-zA-Z0-9_-ー\\.]+"
hashtag <- str_extract_all(conservation_posts$Caption, hashtag_pat)
hashtag_word <- unlist(hashtag)
hashtag_word <- tolower(hashtag_word)
hashtag_word <- gsub("[[:punct:]ー]", "", hashtag_word)
hashtag_count <- table(hashtag_word)
top_hastags <- sort(hashtag_count, decreasing = TRUE)[1:5]
top_hastags

# Create datasets for each identified hashtags
## #wildlife posts
wildlife <- filter(conservation_posts,
                   grepl('#wildlife', Caption))
wildlife_date <- 
  wildlife %>% 
  group_by(Category2,
           Day_Posted) %>%
  summarise(count = n())

wildlife_date_moving_average <- 
  wildlife_date %>%
  mutate(count_weekly = 
           rollmean(count,
                    k = 7,
                    fill = NA)) %>%
  ungroup()

## #nature posts
nature <- filter(conservation_posts,
                 grepl('#nature', Caption))
nature_date <- 
  nature %>% 
  group_by(Category2,
           Day_Posted) %>%
  summarise(count = n())

nature_date_moving_average <- 
  nature_date %>%
  mutate(count_weekly = 
           rollmean(count,
                    k = 7,
                    fill = NA)) %>%
  ungroup()

## #biodiversity posts
biodiversity <- filter(conservation_posts,
                       grepl('#biodiversity', Caption))
biodiversity_date <- 
  biodiversity %>% 
  group_by(Category2,
           Day_Posted) %>%
  summarise(count = n())

biodiversity_date_moving_average <- 
  biodiversity_date %>%
  mutate(count_weekly = 
           rollmean(count,
                    k = 7,
                    fill = NA)) %>%
  ungroup()

## #environment posts
environment <- filter(conservation_posts,
                      grepl('#environment', Caption))
environment_date <- 
  environment %>% 
  group_by(Category2,
           Day_Posted) %>%
  summarise(count = n())

environment_date_moving_average <- 
  environment_date %>%
  mutate(count_weekly = 
           rollmean(count,
                    k = 7,
                    fill = NA)) %>%
  ungroup()

# Plots ----
## Percentage of #conservation posts (Bootstrapped) across taxonomic groups and years (Figure S1) ----
conservation_BS_plot <- 
  conservation_posts_count_BS %>% 
  ggplot(aes(x = Year,
             y = freq,
             fill = Category2)) +      
  geom_bar(position = "stack",
           stat = "identity") +
  theme_minimal() +
  labs(x = "", y = "% of #conservation posts \n (Bootstrapped)",
       fill = "") +
  scale_fill_manual(values = c("#F38400",
                               "#F3C300",
                               "#eae2b7",
                               "#2c6e49",
                               "#b4b4b4"),
                    labels = c("Insects",
                               "Other Invertebrates",
                               "Vertebrates",
                               "Plants",
                               "Undefined Groups")) +
  scale_x_continuous(breaks = seq(from = 2009,
                                  to = 2022,
                                  by = 1)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 0.5, vjust = 0.5),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.background = element_rect(fill = "white",
                                        color = NA),
        legend.position = "top",
        text = element_text(family = "Roboto",
                            size = 32)) +
  guides(fill = guide_legend(title.position = "top", title.hjust = 0.5)) 
conservation_BS_plot # Figure S1

## Date-specific trends of the next four most common hashtags (Figure S2) ----
### Number of insect #conservation & #wildlife posts ----
wildlife_date_insects <- 
  ggplot() + 
  geom_line(data = (wildlife_date %>% 
                      filter(Category2 == "Insects")),
            aes(x = Day_Posted,
                y = count,
                group = Category2),
            size = 1,
            alpha = 0.2,
            colour = c("#F38400")) +
  geom_line(data = (wildlife_date_moving_average %>% 
                      filter(Category2 == "Insects")),
            aes(x = Day_Posted,
                y = count_weekly,
                group = Category2),
            colour = c("#F38400"),
            size = 1) +
  labs(y = "No. of insect #conservation\n& #wildlife posts", x = "") +
  scale_x_discrete(breaks = c("01-01", "02-01", "03-01", "04-01", "05-01",
                              "06-01", "07-01", "08-01", "09-01", "10-01",
                              "11-01", "12-01"),
                   labels = c("Jan", "Feb", "Mar", "Apr" , "May", "Jun",
                              "Jul", "Aug", "Sep", "Oct", "Nov" , "Dec")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        legend.position = "none",
        panel.background = element_rect(fill = "white",
                                        color = NA),
        panel.grid.minor.x = element_blank(),
        text = element_text(family = "Roboto",
                            size = 18))
wildlife_date_insects

### Number of insect #conservation & #nature posts ----
nature_date_insects <- 
  ggplot() + 
  geom_line(data = (nature_date %>% 
                      filter(Category2 == "Insects")),
            aes(x = Day_Posted,
                y = count,
                group = Category2),
            size = 1,
            alpha = 0.2,
            colour = c("#F38400")) +
  geom_line(data = (nature_date_moving_average %>% 
                      filter(Category2 == "Insects")),
            aes(x = Day_Posted,
                y = count_weekly,
                group = Category2),
            colour = c("#F38400"),
            size = 1) +
  labs(y = "No. of insect #conservation\n& #nature posts", x = "") +
  scale_x_discrete(breaks = c("01-01", "02-01", "03-01", "04-01", "05-01",
                              "06-01", "07-01", "08-01", "09-01", "10-01",
                              "11-01", "12-01"),
                   labels = c("Jan", "Feb", "Mar", "Apr" , "May", "Jun",
                              "Jul", "Aug", "Sep", "Oct", "Nov" , "Dec")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        legend.position = "none",
        panel.background = element_rect(fill = "white",
                                        color = NA),
        panel.grid.minor.x = element_blank(),
        text = element_text(family = "Roboto",
                            size = 18))
nature_date_insects

### Number of insect #conservation & #biodiversity posts ----
biodiversity_date_insects <- 
  ggplot() + 
  geom_line(data = (biodiversity_date %>% 
                      filter(Category2 == "Insects")),
            aes(x = Day_Posted,
                y = count,
                group = Category2),
            size = 1,
            alpha = 0.2,
            colour = c("#F38400")) +
  geom_line(data = (biodiversity_date_moving_average %>% 
                      filter(Category2 == "Insects")),
            aes(x = Day_Posted,
                y = count_weekly,
                group = Category2),
            colour = c("#F38400"),
            size = 1) +
  labs(y = "No. of insect #conservation\n& #biodiversity posts", x = "") +
  scale_x_discrete(breaks = c("01-01", "02-01", "03-01", "04-01", "05-01",
                              "06-01", "07-01", "08-01", "09-01", "10-01",
                              "11-01", "12-01"),
                   labels = c("Jan", "Feb", "Mar", "Apr" , "May", "Jun",
                              "Jul", "Aug", "Sep", "Oct", "Nov" , "Dec")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        legend.position = "none",
        panel.background = element_rect(fill = "white",
                                        color = NA),
        panel.grid.minor.x = element_blank(),
        text = element_text(family = "Roboto",
                            size = 18))
biodiversity_date_insects

### Number of insect #conservation & #environment posts ----
environment_date_insects <- 
  ggplot() + 
  geom_line(data = (environment_date %>% 
                      filter(Category2 == "Insects")),
            aes(x = Day_Posted,
                y = count,
                group = Category2),
            size = 1,
            alpha = 0.2,
            colour = c("#F38400")) +
  geom_line(data = (environment_date_moving_average %>% 
                      filter(Category2 == "Insects")),
            aes(x = Day_Posted,
                y = count_weekly,
                group = Category2),
            colour = c("#F38400"),
            size = 1) +
  labs(y = "No. of insect #conservation\n& #environment posts", x = "") +
  scale_x_discrete(breaks = c("01-01", "02-01", "03-01", "04-01", "05-01",
                              "06-01", "07-01", "08-01", "09-01", "10-01",
                              "11-01", "12-01"),
                   labels = c("Jan", "Feb", "Mar", "Apr" , "May", "Jun",
                              "Jul", "Aug", "Sep", "Oct", "Nov" , "Dec")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        legend.position = "none",
        panel.background = element_rect(fill = "white",
                                        color = NA),
        panel.grid.minor.x = element_blank(),
        text = element_text(family = "Roboto",
                            size = 18))
environment_date_insects
