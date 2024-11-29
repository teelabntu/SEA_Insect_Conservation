####### Identifying the knowledge and capacity gaps in Southeast Asian insect conservation
####### Author: Xin Rui Ong
####### (2a) Primary Literature - Topic Modelling

# Description ----
## This script details our topic modelling analysis.
## Here, we generated topic models to determine the main topics covered based on the abstracts from the primary literature.
## Files from Zenodo (https://doi.org/10.5281/zenodo.11195326): "Curated_Datasets.zip"

# Setup: Load packages ----
library(readxl)
library(tidyverse)
library(stm)

# Read data ----
pri_lit <- 
  read_excel("Curated_Datasets/2_Primary_Literature.xlsx") # Cleaned primary literature records

# Prepare data for topic modelling - Derived from each paper's abstract
insect_stm_ab <-textProcessor(pri_lit$Abstract, metadata = pri_lit)
insect_stm_out_ab <-prepDocuments(insect_stm_ab$documents, insect_stm_ab$vocab, insect_stm_ab$meta)

# Run topic models with varying number of topics (k) ----
insect_fit_ab10 <-stm(insect_stm_out_ab$documents,
                      insect_stm_out_ab$vocab,
                      K = 10,
                      prevalence = ~ year,
                      max.em.its = 75,
                      data = insect_stm_out_ab$meta,
                      init.type = "Spectral")
insect_fit_ab15 <-stm(insect_stm_out_ab$documents,
                      insect_stm_out_ab$vocab,
                      K = 15,
                      prevalence = ~ year,
                      max.em.its = 75,
                      data = insect_stm_out_ab$meta,
                      init.type = "Spectral")
insect_fit_ab20 <-stm(insect_stm_out_ab$documents,
                      insect_stm_out_ab$vocab,
                      K = 20,
                      prevalence = ~ year,
                      max.em.its = 75,
                      data = insect_stm_out_ab$meta,
                      init.type = "Spectral")
insect_fit_ab25 <-stm(insect_stm_out_ab$documents,
                      insect_stm_out_ab$vocab,
                      K = 25,
                      prevalence = ~ year,
                      max.em.its = 75,
                      data = insect_stm_out_ab$meta,
                      init.type = "Spectral")
insect_fit_ab30 <-stm(insect_stm_out_ab$documents,
                      insect_stm_out_ab$vocab,
                      K = 30,
                      prevalence = ~ year,
                      max.em.its = 75,
                      data = insect_stm_out_ab$meta,
                      init.type = "Spectral")
insect_fit_ab35 <-stm(insect_stm_out_ab$documents,
                      insect_stm_out_ab$vocab,
                      K = 35,
                      prevalence = ~ year,
                      max.em.its = 75,
                      data = insect_stm_out_ab$meta,
                      init.type = "Spectral")
# view topics
labelTopics(insect_fit_ab10)
labelTopics(insect_fit_ab15)
labelTopics(insect_fit_ab20)
labelTopics(insect_fit_ab25)
labelTopics(insect_fit_ab30)
labelTopics(insect_fit_ab35)

# Extract topic scores for topic model with k = 30
topic_scores <- insect_fit_ab30$theta
topic_scores_30 <- as.data.frame(topic_scores)
analysed <- insect_stm_out_ab$meta
assigned_30topics <- cbind(analysed, topic_scores_30)

## Results of topic modelling analysis are summarized in Table S4 of Supplementary Materials 2.