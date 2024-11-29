####### Identifying the knowledge and capacity gaps in Southeast Asian insect conservation
####### Author: Xin Rui Ong
####### (5c) Twitter #conservation posts - Plotting

# Description ----
## This script is for the plotting of our Twitter data.
## Figure 5A (overlay): Number of #conservation posts per year
## Figure 5A: Percentage of #conservation posts across taxonomic groups and years
## Figure 5B: Wordcloud of top 20 occurring words in insect #conservation posts
## Figure 5C: Number of insect #conservation posts across calendar days
## Figure 5D: Word clouds of positive, neutral and negative sentiments in insect #conservation posts
## Files from Zenodo (https://doi.org/10.5281/zenodo.11195326): "Curated_Datasets.zip"

# Setup: Load packages ----
library(tidyverse)
library(zoo)
library(wordcloud2)
library(ggwordcloud)
windowsFonts(Roboto=windowsFont("Roboto Condensed"))

# Read data ----
conservation_posts <- 
  read.csv("Curated_Datasets/5_1_Twitter.csv",
           header = T) # Twitter #conservation posts with assigned taxonomic group

insect_conservation_posts <- 
  read.csv("Curated_Datasets/5_2_Twitter_Insects.csv",
           header = T) # Twitter insect #conservation posts with assigned sentiments

conservation_posts$Day_Posted <- 
  format(conservation_posts$Day_Posted, format="%m-%d")
insect_conservation_posts$Day_Posted <- 
  format(insect_conservation_posts$Day_Posted, format="%m-%d")

# Create datasets for plotting ----
## Number and percentage of #conservation posts across the taxonomic groups and years ----
conservation_posts_summary <-
  conservation_posts %>%
  group_by(Year, Category2) %>%
  summarise(count = n()) %>%
  mutate(freq = (count/sum(count)) * 100)

conservation_posts_summary$Category2 <-
  factor(conservation_posts_summary$Category2,
         levels = c("Insects",
                    "Other Invertebrate Groups",
                    "Vertebrates",
                    "Plants",
                    "Undefined Groups"))

conservation_posts_total_year <-
  conservation_posts %>%
  group_by(Year) %>%
  summarise(count = n())

## Dataset for word cloud of top 20 occurring words in insect #conservation posts ----
insect_captions <- 
  insect_conservation_posts %>%
  select(Cleaned_Caption) %>% 
  separate_rows(Cleaned_Caption, sep=" ")

insect_captions_freq <- 
  insect_captions %>%
  group_by(Cleaned_Caption) %>%
  tally()

# Exclude non-topic words from the top 20 words by changing their freq to 0
insect_captions_freq$n[insect_captions_freq$Cleaned_Caption=="http"] <- 0
insect_captions_freq$n[insect_captions_freq$Cleaned_Caption=="https"] <- 0
insect_captions_freq$n[insect_captions_freq$Cleaned_Caption=="t"] <- 0
insect_captions_freq$n[insect_captions_freq$Cleaned_Caption=="co"] <- 0
insect_captions_freq$n[insect_captions_freq$Cleaned_Caption=="s"] <- 0
insect_captions_freq$n[insect_captions_freq$Cleaned_Caption=="rt"] <- 0
insect_captions_freq$n[insect_captions_freq$Cleaned_Caption=="w"] <- 0
insect_captions_freq$n[insect_captions_freq$Cleaned_Caption=="amp"] <- 0
insect_captions_freq$n[insect_captions_freq$Cleaned_Caption=="ly"] <- 0

# Obtain top 20 words for insect #conservation posts
top20_insect <- insect_captions_freq %>%
  arrange(desc(n)) %>%
  slice(1:20)

## Datasets for word clouds of positive, neutral and negative sentiments in insect #conservation posts ----
insect_captions_sentiments <- 
  insect_conservation_posts %>%
  select(Cleaned_Caption, Overall_Caption_Sentiment) %>% 
  separate_rows(Cleaned_Caption, sep=" ")

insect_captions_sentiments_freq <- 
  insect_captions_sentiments %>%
  group_by(Cleaned_Caption, Overall_Caption_Sentiment) %>%
  tally()

## Exclude non-topic words and words that occur across all 3 sentiments by changing their freq to 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="http"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="https"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="t"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="co"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="s"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="c"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="rt"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="w"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="amp"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="ly"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="bees"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="bee"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="butterfly"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="insects"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="butterflies"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="insect"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="quqypj"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="u"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="wsz"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="m"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="uk"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="pollinator"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="pollinators"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="monarch"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="savethebees"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="species"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="wildlife"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="biodiversity"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="e"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="ecology"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="environment"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="habitat"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="honey"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="honeybees"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="nature"] <- 0
insect_captions_sentiments_freq$n[insect_captions_sentiments_freq$Cleaned_Caption=="science"] <- 0

# Get top 20 words for each category
top20_insect_sentiment <-
  insect_captions_sentiments_freq %>%
  group_by(Overall_Caption_Sentiment) %>%
  arrange(desc(n)) %>%
  slice(1:20)

## Number of insect #conservation posts across calendar days ----
insect_conservation_posts_summary <-
  insect_conservation_posts %>%
  group_by(Day_Posted) %>%
  summarise(count = n()) 

## Calculate weekly moving average to smooth out time series ----
moving_average <- 
  insect_conservation_posts_summary %>%
  mutate(count_weekly = rollmean(count,
                                 k = 7,
                                 fill = NA)) %>%
  ungroup()

# Plots ----
## Number of #conservation posts across years (Figure 5A: overlay) ----
conservation_posts_trend <- 
  conservation_posts_total_year %>%
  ggplot(aes(x = Year, y = count)) +
  geom_point(size = 6, color = "black") +
  geom_line(color = "black", size = 1.3) +
  scale_x_continuous(breaks = seq(from = 2001,
                                  to = 2022,
                                  by = 1)) +
  labs(x = "",
       y = "",
       fill = "") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 0.5, vjust = 0.5),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.background = element_rect(fill = "white",
                                        color = NA),
        text = element_text(family = "Roboto",
                            size = 16),
        legend.position = "none")
conservation_posts_trend # Figure 5A: overlay

## Percentage of #conservation posts across taxonomic groups and years (Figure 5A) ----
conservation_posts_taxa_year <- 
  conservation_posts_summary %>% 
  ggplot(aes(x = Year,
             y = freq,
             fill = Category2)) +      
  geom_bar(position = "stack",
           stat = "identity") +
  theme_minimal() +
  labs(x = "", y = "% of #conservation posts", fill = "") +
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
conservation_posts_taxa_year # Figure 5A

## Wordcloud of top 20 occurring words in insect #conservation posts (Figure 5B) ----
insect_wordcloud <- 
  top20_insect %>% 
  ggplot(aes(label = Cleaned_Caption,
             size = n)) +
  geom_text_wordcloud_area(family = "Roboto",
                           shape = "square",
                           colour = "#F38400") +
  scale_size_area(max_size = 30,
                  trans = power_trans(1/.7)) +
  theme_minimal()
insect_wordcloud # Figure 5B

## Number of insect #conservation posts across calendar days (Figure 5C) ----
insect_conservation_day <- ggplot() + 
  geom_line(data = insect_conservation_posts_summary,
            aes(x = Day_Posted,
                y = count,
                group = 1),
            linewidth = 1,
            alpha = 0.2,
            colour = c("#F38400")) +
  geom_line(data = moving_average,
            aes(x = Day_Posted,
                y = count_weekly,
                group = 1),
            colour = c("#F38400"),
            linewidth = 1) +
  labs(y = "No. of insect #conservation posts", x = "") +
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
insect_conservation_day # Figure 5C

## Word clouds of positive, neutral and negative sentiments in insect #conservation posts (Figure 5D) ----
insect_sentiment_pos <- 
  top20_insect_sentiment %>% 
  filter(Overall_Caption_Sentiment == "pos") %>% 
  ggplot(aes(label = Cleaned_Caption,
             size = n)) +
  geom_text_wordcloud_area(family = "Roboto",
                           colour = c("#386641"),
                           shape = "square") +
  scale_size_area(max_size = 60,
                  trans = power_trans(1/.7)) +
  theme_minimal()
insect_sentiment_pos

insect_sentiment_neu <- 
  top20_insect_sentiment %>% 
  filter(Overall_Caption_Sentiment  == "neu") %>% 
  ggplot(aes(label = Cleaned_Caption,
             size = n)) +
  geom_text_wordcloud_area(family = "Roboto",
                           colour = c("#ffbe0b"),
                           shape = "square") +
  scale_size_area(max_size = 60, trans = power_trans(1/.7)) +
  theme_minimal()
insect_sentiment_neu

insect_sentiment_neg <- 
  top20_insect_sentiment %>% 
  filter(Overall_Caption_Sentiment == "neg") %>% 
  ggplot(aes(label = Cleaned_Caption,
             size = n)) +
  geom_text_wordcloud_area(family = "Roboto",
                           colour = c("#9a031e"),
                           shape = "square") +
  scale_size_area(max_size = 60,
                  trans = power_trans(1/.7)) +
  theme_minimal()
insect_sentiment_neg
