####### Identifying the knowledge and capacity gaps in Southeast Asian insect conservation
#######  Author: Tan Mei Yi Belle 
####### (5b) Twitter - VADER Sentiment Analysis

## Description:
## This script is for determining the sentiments of captions in insect #conservation posts from Twitter using the VADER sentiment analysis.
## VADER is pre-trained and created with the intention of using it for social media data. The VADER model produces a likelihood of sentiments (positive, negative or neutral).
## The model produces a compound score and the sentiments are assigned based on the following thresholds: positive >= 0.05, -0.05 > neutral > 0.05, negative <= -0.05. 
## Note that the VADER model was performed on raw captions as punctuations and word shape (e.g. caps) are used to determine sentiments. 
## Sources: https://towardsdatascience.com/the-most-favorable-pre-trained-sentiment-classifiers-in-python-9107c06442c6; https://pypi.org/project/vaderSentiment
## Files from Zenodo (https://doi.org/10.5281/zenodo.11195326): "Curated_Datasets.zip"

# {python}
## Importing relevant libraries
import pandas as pd
import re
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
import spacy 
from spacy.language import Language
from spacy_langdetect import LanguageDetector
# Create a factory for language detector first. Source code: https://github.com/Abhijit-2592/spacy-langdetect/issues/6
@Language.factory("language_detector")
def create_language_detector(nlp, name):
  return LanguageDetector(language_detection_function=None)
# Detect the language of the captions to sort out English texts. Code was adapted from: https://towardsdatascience.com/4-python-libraries-to-detect-english-and-non-english-language-c82ad3efd430 
## Start off by adding the LanguageDetector as a pipe to the processing pipeline
nlp = spacy.load("en_core_web_sm")
nlp.add_pipe("language_detector")

## Create Vader Sentiment analyser
analyser = SentimentIntensityAnalyzer()

## Read data
insect_conservation_posts = pd.read_csv("Curated_Datasets//5_2_Twiiter_Insects.csv")
list(insect_conservation_posts) # View column headers

all_caption_sentiment_new = []
caption_compound_score_new = []
caption_pos_score_new = []
caption_neu_score_new = []
caption_neg_score_new = []

## Run VADER Sentiment analyzer on raw captions across all insect #conservation posts
for i in range(0, len(insect_conservation_posts)): 
  ## For every row, I need to pull the caption out from the dictionary
  caption = insect_conservation_posts['Raw_Caption'][i]
    
  ## Determine sentiment of caption
  caption_score = analyser.polarity_scores(caption)
  caption_compound = caption_score['compound']
  caption_pos = caption_score['pos']
  caption_neu = caption_score['neu']
  caption_neg = caption_score['neg']
  if caption_compound >= 0.05:
    caption_sentiment = 'pos'
  elif caption_compound <= -0.05:
    caption_sentiment = 'neg'
  else:
    caption_sentiment = 'neu'
  
  all_caption_sentiment_new.append(caption_sentiment)
  caption_compound_score_new.append(caption_compound)
  caption_pos_score_new.append(caption_pos)
  caption_neu_score_new.append(caption_neu)
  caption_neg_score_new.append(caption_neg)
  
# Save calculated VADER scores  
insect_conservation_posts['caption_sentiment_new'] = all_caption_sentiment_new
insect_conservation_posts['caption_compound_score'] = caption_compound_score_new
insect_conservation_posts['caption_pos_score'] = caption_pos_score_new
insect_conservation_posts['caption_neu_score'] = caption_neu_score_new
insect_conservation_posts['caption_neg_score'] = caption_neg_score_new
