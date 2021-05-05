# Final project - group 18 - R for Bio Data Science

## Description
This project investigates breast cancer data using tools learned during the course "R for Bio Data Science" at DTU. It will contain the raw and tidy data, and several analysis methods, add some more...

## Data
Raw data can be found in the folder /data/_raw and otherwise on this [link](https://www.kaggle.com/piotrgrabo/breastcancerproteomes). 

It contains three data files, but we chose only to use two of them:
File: *77_cancer_proteomes_CPTAC_itraq.csv* 
- Contains gene expression data (12553 observations) from 77 cancer patients and 3 healthy persons. 

File: *clinical_data_breast_cancer.csv* 
- Contains clinical data from the 77 cancer patients (not the 3 healthy), such as age, gender, tumor class etc. 

File: *PAM50_proteins.csv* 
- We decided not use this data, since we did not need the information it could provide in order to make the analysis we wanted. It is somewhat a dictionary of the genes, their names and ID's. 

## Use
In order to execute the full data analysis and generate final plots, including the presentation, the script *00doit.R* from folder */R* should be run. The presentation will appear in the folder */doc*. 

## Dependencies
Following packages has been used:
- tidyverse
- stringr
- broom
- purrr
- UPDATE THIS WHEN WE ARE DONE