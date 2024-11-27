####### Identifying the knowledge and capacity gaps in Southeast Asian insect conservation
####### Author: Xin Rui Ong
####### (1a) Insect Occurrence - Coordinate Cleaner

# Description ----
## This script is for the processing of raw occurrence data obtained from GBIF.
## Raw datasets are obtained through GBIF's Occurrence Download. Refer to DOIs listed in Table S1 in Supplementary Materials 1 for more information.
## Files from Zenodo (https://zenodo.org/records/14227113) - "GBIF_Raw_Insect_Occurrences.zip".

# Setup: Load packages ----
library(tidyverse)
library(CoordinateCleaner)

# Read and combine raw data ----
## Source: "GBIF_Raw_Insect_Occurrences.zip"
IDN <- read.csv("data/GBIF_IDN.csv") # 2001 to 2022 occurrence records from Indonesia
MYS <- read.csv("data/GBIF_MYS.csv") # 2001 to 2022 occurrence records from Malaysia
SGP <- read.csv("data/GBIF_SGP.csv") # 2001 to 2022 occurrence records from Singapore
THA <- read.csv("data/GBIF_THA.csv") # 2001 to 2022 occurrence records from Thailand
SEA_7 <- read.csv("data/GBIF_PHL_BRN_KHM_VNM_TLS_MMR_LAO.csv") # 2001 to 2022 occurrence records from Philippines, Brunei, Cambodia, Vietnam, Timor-Leste, Myanmar, Laos
SEA_2023 <- read.csv("data/GBIF_SEA_2023.csv") # 2023 occurrence records from all 11 Southeast Asian countries

combined <- rbind(IDN, MYS, SGP, THA, SEA_7, SEA_2023)

# Clean data ----
## Remove records without coordinates
combined <- combined %>%
              filter(!is.na(decimalLongitude))%>%
              filter(!is.na(decimalLatitude))

combined$countryCode <-  countrycode(combined$country,
                                     origin =  'iso2c',
                                     destination = 'iso3c')

## Filter out and view problematic records using clean_coordinates function in CoordinateCleaner package
flags <- 
  clean_coordinates(x = combined, 
                    lon = "decimalLongitude", 
                    lat = "decimalLatitude",
                    countries = "countryCode",
                    species = "order",
                    tests = c("capitals",
                              "centroids",
                              "equal",
                              "gbif",
                              "institutions",
                              "zeros",
                              "countries"))

## Exclude problematic records from main dataset
combined_cleaned <- combined[flags$.summary,] 
combined_cleaned <- combined_cleaned %>% filter(countryCode != "CHN")
## 130,118 problematic records removed

## Refer to the "(1) Insect Occurrence" tab of "SEA_Insect_Conservation_Quantitative_Review_Dataset_v2.xlsx" for cleaned occurrence records.