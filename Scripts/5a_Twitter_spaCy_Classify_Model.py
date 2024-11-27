####### Identifying the knowledge and capacity gaps in Southeast Asian insect conservation
#######  Author: Tan Mei Yi Belle 
####### (5a) Twitter - spaCy classifier

## Description:
## This script is for the assigning of taxonomic groups to Twitter #conservation posts using the spaCy classifier.
## The script will include sections that detects and filters out non-English texts, as well as sort and categorise posts according to the topic taxonomy. 
## Other packages used that are within Python Standard Library: re, ast, pathlib
## Ensure that the pre-trained english pipeline (i.e. en_core_web_sm) from spacy is installed (python -m spacy download en_core_web_sm)
## Youtube tutorial that I referenced: https://www.youtube.com/watch?v=7PD48PFL9VQ&t=1071s
## Files from Zenodo (https://zenodo.org/records/14227113) - "Twitter_spacy.zip", "spacy-model-best.zip", "SEA_Insect_Conservation_Quantitative_Review_Dataset_v3.xlsx"

# {python}
## Importing relevant libraries
from spacy.tokens import DocBin
import spacy
import pandas as pd 
import re
import ast
## These libraries are for the training part of the code. 
from pathlib import Path
from spacy.cli.init_config import fill_config
from spacy.cli.train import train
## Libraries for evaluating
from spacy.cli.evaluate import evaluate

# Step 1. Training the spaCy classifier
## Read training dataset (Refer to Supplementary Materials 1 for more information on datasets)
train_data = pd.read_csv("data//twitter_spaCy_train_data.csv")

## Clean datasets using optimized English pipeline from spaCy: Remove stopwords, non-alphabetical letters, and change all to small caps
nlp = spacy.load("en_core_web_sm")

cleaned_text_df = pd.DataFrame()
stopwords = spacy.lang.en.stop_words.STOP_WORDS
stopwords_to_add = {"save", "saving", "saved",  "conservation", "conserve", "conserving", "conserved", "intl", "conservationorg", "thewcs", "wwf", "natgeowild", "thenatureconservancy", "org", "ipbes", "ifaw", "ifawglobal", "seashepherdglobal", "seashepherd", "unbiodiversity", "verified"}
stopwords |= stopwords_to_add

for i in range(0, len(train_data)):
  # Have to use .index because numbers change after removing non-en data
  text_to_read = train_data['text'][i]
  if type(text_to_read) == float: 
    cleaned_text_df = cleaned_text_df._append(pd.DataFrame({"NA"}), ignore_index=True)
  else: 
    # Remove all non-alphabetical letters 
    text_alpha = re.sub('[^a-zA-Z]', ' ', text_to_read)
    # Change all letters to small caps 
    text_lower = text_alpha.lower()
    # Split the caption into tokens
    text_tokens = text_lower.split()
    # Remove stopwords 
    text_stoprm = [word for word in text_tokens if word not in stopwords]
    # Rejoin non-stopwords words together 
    text_cleaned = ' '.join(text_stoprm)
    cleaned_text_df = cleaned_text_df._append(pd.DataFrame({text_cleaned}), ignore_index=True)
  
cleaned_text_df.columns = ['cleaned_text'] # Rename column to cleaned_text

cleaned_train_data = cleaned_text_df.join(train_data['category']) # Join the cleaned_text_df with the categories from training data

training_data = cleaned_train_data

data_tuples = training_data.to_records(index=False) # Dataset needs to be in tuples so we will convert the pandas dataframe into an array of tuples. 

## Procecss training data to be usable for training textcat
### Start by defining function make_docs
def make_docs(data_tuples): 
  # create an empty list 
  docs = []
  # identifying all the categories in the row of data so that the function will know which ones to recognise. 
  for text, category in nlp.pipe(data_tuples, as_tuples=True): 
    ## Giving the data a binary code for the categories (this serves as the input for training the spacy model)
    if category == "Insects":
      text.cats["Insects"] = 1
      text.cats["Plants"] = 0
      text.cats["Other Invertebrate Groups"] = 0
      text.cats["Birds"] = 0
      text.cats["Fish"] = 0
      text.cats["Amphibians & Reptiles"] = 0
      text.cats["Mammals"] = 0
      text.cats["Undefined Groups"] = 0
      text.cats["Others"] = 0
      ## Then repeat this classification for the other categories. 
    elif category == "Plants": 
      text.cats["Insects"] = 0
      text.cats["Plants"] = 1
      text.cats["Other Invertebrate Groups"] = 0
      text.cats["Birds"] = 0
      text.cats["Fish"] = 0
      text.cats["Amphibians & Reptiles"] = 0
      text.cats["Mammals"] = 0
      text.cats["Undefined Groups"] = 0
      text.cats["Others"] = 0    
    elif category == "Other Invertebrate Groups":    
      text.cats["Insects"] = 0
      text.cats["Plants"] = 0
      text.cats["Other Invertebrate Groups"] = 1
      text.cats["Birds"] = 0
      text.cats["Fish"] = 0
      text.cats["Amphibians & Reptiles"] = 0
      text.cats["Mammals"] = 0
      text.cats["Undefined Groups"] = 0
      text.cats["Others"] = 0  
    elif category == "Birds":     
      text.cats["Insects"] = 0
      text.cats["Plants"] = 0
      text.cats["Other Invertebrate Groups"] = 0
      text.cats["Birds"] = 1
      text.cats["Fish"] = 0
      text.cats["Amphibians & Reptiles"] = 0
      text.cats["Mammals"] = 0
      text.cats["Undefined Groups"] = 0
      text.cats["Others"] = 0  
    elif category == "Fish":      
      text.cats["Insects"] = 0
      text.cats["Plants"] = 0
      text.cats["Other Invertebrate Groups"] = 0
      text.cats["Birds"] = 0
      text.cats["Fish"] = 1
      text.cats["Amphibians & Reptiles"] = 0
      text.cats["Mammals"] = 0
      text.cats["Undefined Groups"] = 0
      text.cats["Others"] = 0  
    elif category == "Amphibians & Reptiles":      
      text.cats["Insects"] = 0
      text.cats["Plants"] = 0
      text.cats["Other Invertebrate Groups"] = 0
      text.cats["Birds"] = 0
      text.cats["Fish"] = 0
      text.cats["Amphibians & Reptiles"] = 1
      text.cats["Mammals"] = 0
      text.cats["Undefined Groups"] = 0
      text.cats["Others"] = 0  
    elif category == "Mammals":       
      text.cats["Insects"] = 0
      text.cats["Plants"] = 0
      text.cats["Other Invertebrate Groups"] = 0
      text.cats["Birds"] = 0
      text.cats["Fish"] = 0
      text.cats["Amphibians & Reptiles"] = 0
      text.cats["Mammals"] = 1
      text.cats["Undefined Groups"] = 0
      text.cats["Others"] = 0  
    elif category == "Undefined Groups":        
      text.cats["Insects"] = 0
      text.cats["Plants"] = 0
      text.cats["Other Invertebrate Groups"] = 0
      text.cats["Birds"] = 0
      text.cats["Fish"] = 0
      text.cats["Amphibians & Reptiles"] = 0
      text.cats["Mammals"] = 0
      text.cats["Undefined Groups"] = 1
      text.cats["Others"] = 0  
    elif category == "Others":        
      text.cats["Insects"] = 0
      text.cats["Plants"] = 0
      text.cats["Other Invertebrate Groups"] = 0
      text.cats["Birds"] = 0
      text.cats["Fish"] = 0
      text.cats["Amphibians & Reptiles"] = 0
      text.cats["Mammals"] = 0
      text.cats["Undefined Groups"] = 0
      text.cats["Others"] = 1
    docs._append(text)
  return(docs)

## Step 2. Create the training texts for the spacy train module. Here, we used the same dataset (i.e. data_tuples) to create our train and valid spaCy files.
# Example code:
# train_docs = make_docs(data_tuples)
# doc_bin = DocBin(docs=train_docs)
# doc_bin.to_disk("INSERT PATH")
# Refer to "train.spacy" and "valid.spacy".

## Step 3. Train the spaCy model using a modified config file "config_modified.cfg". Set the correct paths for the model output and datasets (train.spacy; valid.spacy), see https://spacy.io/usage/training#quickstart.
## This step will take awhile. Alternatively, you may download "model-best.zip" (i.e. the best performing classifier) for subsequent steps.
train(config_path=Path("data//config_modified.cfg"), output_path=Path("data//spacy_model"), overrides={"paths.train": "data//train.spacy", "paths.dev": "data//valid.spacy"}) 

## Step 4. Evaluating the best performing classifier
# Read test dataset & trained spaCy model
cleaned_test_data = pd.read_csv("data//twitter_spaCy_test_data.csv")

# Download and unzip "spacy-model-best.zip" for the best performing classifier
# In the config.cfg file in the "model-best" folder, ensure that the paths to the "train" and "dev" are set to where you have stored the "train.spacy" and "valid.spacy" files.
my_nlp = spacy.load("data//spacy_model-best//model-best")

pred_df = pd.DataFrame(columns=['pred_dict', 'pred_cat'], index=range(0,len(cleaned_test_data)))

# Assign categories to each post in the test dataset
for t in range(0, len(cleaned_test_data)):
  text_to_classify = cleaned_test_data['cleaned_text'][t]
  # If else to classify NaN data as Others 
  if type(text_to_classify) == float:
    pred_df['pred_dict'][t] = ['NA']
    pred_df['pred_cat'][t] = "Others"
  else:
    # Run cleaned_text through new model 
    doc = my_nlp(text_to_classify)
    # obtain all values for each of the categories (probability that the model thinks this text belongs to the category)
    pred_df['pred_dict'][t] = doc.cats
    # Predicting category based on highest probability
    predictions = doc.cats.values()
    max_value = max(predictions)
    predicted_key = {i for i in doc.cats if doc.cats[i]==max_value}
    predicted_cat = ''.join(predicted_key)
    # Store this predicted category as pred_cat in df
    pred_df['pred_cat'][t] = predicted_cat

# Join both df together 
spaCy_eval = cleaned_test_data.join(pred_df)
# Refer to "test_spaCy_twitter_eval.csv" for test dataset with assigned categories

# If you had not run the above code, please run the below line to call the spaCy_eval data (i.e. test dataset with assigned categories). 
spaCy_eval = pd.read_csv("data//test_spaCy_twitter_eval.csv")

## Determine the evaluation metrics for this model
## Since it is a multiclass classification, I need to get the TP, FP, TN and FN for each class and calculate the precision, accuracy, recall and specificity
cats = list(doc.cats.keys())
eval_metrics = pd.DataFrame(columns=['category', 'TP', 'FP', 'TN', 'FN', 'accuracy', 'precision', 'recall', 'specificity'], index=range(0,len(cats)))

for c in range(0, len(cats)): 
  category = cats[c]
  eval_metrics['category'][c] = category
  # TP = spaCy recognise as category and I recognise as category 
  TP = len(spaCy_eval.index[(spaCy_eval['pred_cat']==category) & (spaCy_eval['category']==category)])
  eval_metrics['TP'][c] = TP
  # FP = spaCy recognise as category and I recognise as not category 
  FP = len(spaCy_eval.index[(spaCy_eval['pred_cat']==category) & (spaCy_eval['category']!=category)])
  eval_metrics['FP'][c] = FP
  # TN = spaCy recognise as not category and I recognise as not category 
  TN = len(spaCy_eval.index[(spaCy_eval['pred_cat']!=category) & (spaCy_eval['category']!=category)])
  eval_metrics['TN'][c] = TN
  # FN = spaCy recognise as not category and I recognise as category 
  FN = len(spaCy_eval.index[(spaCy_eval['pred_cat']!=category) & (spaCy_eval['category']==category)])
  eval_metrics['FN'][c] = FN
  
  sum = TP+TN+FP+FN
  # Check 
  if sum != len(spaCy_eval): 
    print("ERROR, NOT EQUIVALENT")
    break 
  
  # Calculate accuracy [% of correct predictions]
  try: 
    accuracy = (TP+TN)/(TP+TN+FP+FN)
  except ZeroDivisionError: 
    accuracy = 0
  eval_metrics['accuracy'][c] = accuracy
  # Calculate precision [% of positive predictions correct]
  try: 
    precision = TP/(TP+FP)
  except ZeroDivisionError: 
    precision = 0
  eval_metrics['precision'][c] = precision
  # Calculate recall [% of correct positive predictions]
  try: 
    recall = TP/(TP+FN)
  except ZeroDivisionError: 
    recall = 0
  eval_metrics['recall'][c] = recall
  # Calculate specificity [% of correct negative predictions]
  try: 
    specificity=TN/(TN+FP)
  except ZeroDivisionError: 
    specificity = 0
  eval_metrics['specificity'][c] = specificity  
## Refer to "test_spaCy_twitter_eval_metrics.csv" for evaulation results.
  
## Step 5. Run spaCy classifiers using different Area Under the Curve (AUC) thresholds to determine appropriate thresholds for to classify the category based on the probabilities produced by the model.
## For context, the model produces a probability of which each taxonomic category is applicable. Sample of model output: '{'Insects': 0.003, 'Plants': 0.002, 'Other Invertebrate Groups': 0.013, 'Birds': 0.004, 'Fish': 0.013, 'Amphibians & Reptiles': 0.008, 'Mammals': 0.025, 'Undefined Groups': 0.148, 'Others': 0.781}
## In the above Lines 188-205, the determination for most appropriate category was deemed by adopting the maximum probability among the categories. 
## In the below, we will evaluate different thresholds to compare against the "maximum" method that we had adopted above. 
## As there could be a case where more than 1 category is above the threshold, we assign that text as "Undefined Groups"
## Vice versa, where there are cases that none of the categories cross the threshold, we assign that text as "Others"

## Read evaluation data. 
ran_data = pd.read_csv("data//test_spaCy_twitter_eval.csv")

all_eval_metrics = pd.DataFrame()
summary_eval_metrics = pd.DataFrame()

for t in range(10, 100, 5):
  threshold = t/100
  alt_pred = pd.DataFrame(columns=['alt_cat'], index=range(0,len(ran_data)))
  
  for p in range(0, len(ran_data)):
    predictions = ran_data['pred_dict'][p]
    predictions = ast.literal_eval(predictions)
    # Get dict of categories and values that are above the threshold
    try: 
      alt_cats = {key:val for key, val in predictions.items() if val > threshold}
    except AttributeError: 
      alt_cats = ["Others"]
    # If more than 1 category above threshold, assign Undefined Groups
    if len(alt_cats) > 1: 
      alt_cat = "Undefined Groups"
    # If less than 1 category above threshold, assign Others
    elif len(alt_cats) < 1: 
      alt_cat = "Others"
    else: 
      try: 
        alt_cat = {key for key, val in alt_cats.items()}
      except AttributeError:
        alt_cat = alt_cats
      # Make into string
      alt_cat = ''.join(alt_cat)
    alt_pred['alt_cat'][p] = alt_cat
  
  new_data = ran_data.join(alt_pred)
  eval_metrics = pd.DataFrame(columns=['threshold', 'category', 'TP', 'FP', 'TN', 'FN', 'accuracy', 'precision', 'recall', 'specificity', 'fpr'], index=range(0,len(predictions)))
  
  for c in range(0, len(predictions)):
    eval_metrics['threshold'][c] = threshold
    categories = list(predictions.keys())
    category = categories[c]
    eval_metrics['category'][c] = category
    # TP = threshold recognise as category and I recognise as category 
    TP = len(new_data.index[(new_data['alt_cat']==category) & (new_data['category']==category)])
    eval_metrics['TP'][c] = TP
    # FP = spaCy recognise as category and I recognise as not category 
    FP = len(new_data.index[(new_data['alt_cat']==category) & (new_data['category']!=category)])
    eval_metrics['FP'][c] = FP
    # TN = spaCy recognise as not category and I recognise as not category 
    TN = len(new_data.index[(new_data['alt_cat']!=category) & (new_data['category']!=category)])
    eval_metrics['TN'][c] = TN
    # FN = spaCy recognise as not category and I recognise as category 
    FN = len(new_data.index[(new_data['alt_cat']!=category) & (new_data['category']==category)])
    eval_metrics['FN'][c] = FN
    
    sum = TP+TN+FP+FN
    # Check 
    if sum != len(new_data): 
      print("ERROR, NOT EQUIVALENT")
      break 
    
    # Calculate accuracy [% of correct predictions]
    try: 
      accuracy = (TP+TN)/(TP+TN+FP+FN)
    except ZeroDivisionError:  
      accuracy = 0
    eval_metrics['accuracy'][c] = accuracy
    # Calculate precision [% of positive predictions correct]
    try: 
      precision = TP/(TP+FP)
    except ZeroDivisionError: 
      precision = 0
    eval_metrics['precision'][c] = precision
    # Calculate recall [% of correct positive predictions]
    try: 
      recall = TP/(TP+FN)
    except ZeroDivisionError:  
      recall = 0
    eval_metrics['recall'][c] = recall
    # Calculate specificity [% of correct negative predictions]
    try: 
      specificity=TN/(TN+FP)
    except ZeroDivisionError:  
      specificity = 0
    eval_metrics['specificity'][c] = specificity
    try: 
      fpr = FP/(FP+TN)
    except ZeroDivisionError:
      fpr = 0
    eval_metrics['fpr'][c] = fpr
    
  ## Add these eval metrics to the all_eval_metrics
  all_eval_metrics = all_eval_metrics._append(eval_metrics, ignore_index = True)
  ## Get average of eval_metrics of all categories
  eval_mean = eval_metrics.mean() 
  summary_eval_metrics = summary_eval_metrics._append(eval_mean, ignore_index=True)

## Refer to "threshold_spaCy_all_eval_metrics_twitter.csv" for the evaluation metrics for each category.
## Refer to "threshold_spaCy_summary_eval_metrics_twitter.csv" for the evaluation for each threshold (averaged across categories).

summary_eval_metrics = pd.read_csv("data//threshold_spaCy_summary_eval_metrics_twitter.csv")

## From here, you may plot the ROC curve to identify the most appropriate threshold. 
## As we have the various eval_metrics, we may also simply compare the metrics accordingly across the thresholds and against the "maximum" method.

## Step 6. Applying the trained spaCy classifer all download #conservation posts for categorization
# Read data
conservation_posts = pd.read_excel("data//SEA_Insect_Conservation_Quantitative_Review_Dataset_v3.xlsx", sheet_name = "(5-1) Twitter")
list(conservation_posts) # view column headers

# Load the trained classifier
my_nlp = spacy.load("data//spacy_model//model-best")

conservation_posts["Category"] = "NA" 

# Assign categories to each #conservation post
# This will take awhile due to the large number of posts. You may run these codes on another dataset.
for t in range(0,len(test_data)): 
  text_to_classify = conservation_posts["Cleaned_Caption"][t]
  if type(text_to_classify) == float:
    conservation_posts["Category"][t] = "Others"
  else: 
    # Running text through the new model I created 
    doc = my_nlp(text_to_classify)
    # Obtaining all values for each of the categories 
    predictions = doc.cats.values()
    # Finding out which category has the highest probability
    max_value = max(predictions)
    # Denoting the category with the highest probability as the predicted category for the text. The highest probability method was evaluated and determined to be the best after testing other thresholds through the AUC-ROC methods. For the code and results of the evaluation conducted, please refer to the codes below or the data found within the spaCy_model_evaluation_data folder. 
    predicted_key = {i for i in doc.cats if doc.cats[i]==max_value}
    # Using join to change it to a nice string like the other datasets
    predicted_cat = ''.join(predicted_key)
    # Storing the data on file
    conservation_posts["Category"][t] = predicted_cat
