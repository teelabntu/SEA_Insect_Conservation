# Identifying the knowledge and capacity gaps in Southeast Asian insect conservation

## About

This repository contains computer codes for analyses and figure production associated with the paper titled "**Identifying the knowledge and capacity gaps in Southeast Asian insect conservation**".

These were performed using **R Version 4.4.1** and **Python Version 3.10.4**.

# Getting Started

Before running the codes, please download the accompanying data from Zenodo (<https://zenodo.org/records/14227113>).

## Required Packages

**R Packages**

-   readxl (version 1.4.3)
-   tidyverse (version 2.0.0)
-   data.table (version 1.14.10)
-   CoordinateCleaner (version 3.0.1)
-   stm (version 1.3.6.1)
-   patchwork (version 1.1.3)
-   zoo (version 1.8-12)
-   ggwordcloud (version 0.6.1)
-   wordcloud2 (version 0.2.1)

**Python Packages**

-   pandas (version 1.5.1)
-   spaCy (version 3.5.0)
    -   en_core_web_sm (version 3.5.0) - spaCy's optimized pipeline for English text
-   spaCy_langdetect (version 0.1.2)
-   vaderSentiment (version 3.3.2)

# Usage

All codes/scripts are provided in the **Scripts** folder.

-   Insect occurrence
    -   1a_Insect_Occurrence_cleaning.R: Processing of raw insect occurrence data obtained from GBIF
    -   1b_Insect_Occurrence_plotting.R: Plotting of cleaned insect occurrence records from GBIF
-   Primary literature
    -   2a_Primary_Literature_topic_models.R: Topic modelling analysis of primary literature
    -   2b_Primary_Literature_plotting.R: Plotting of curated primary literature data
-   Authorship and funding
    -   3_4_Authorship_Funding_plotting.R: Plotting of curated authorship and funding data
-   Twitter
    -   5a_Twitter_spaCy_Classify_Model.py: Assigning of taxonomic groups to Twitter #conservation posts using the spaCy classifier
    -   5b_Twitter_VADER.py: Determinining sentiments of captions in insect #conservation posts from Twitter using the VADER sentiment analysis
    -   5c_Twitter_plotting.R: Plotting of curated #conservation posts from Twitter.
    -   5d_Twitter_Additional_Analyses.R: Bootstrapping and trends comparison analysis of Twitter data.

# Contact

Xin Rui Ong: @xinruiong.bsky.social
