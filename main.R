#paysim_ds.csv is simulated data, 11 variables, 69 988 820 elements (observations).
#Data describes observations of transactions for fraud detection.
#Remove nameOrig and nameDest, irrelevant & breaks log regression.

#paysim <- read.csv("paysim_ds.csv", head = TRUE, sep = ",")
#paysim <- read.csv("paysim_ds.csv")
paysim <- paysim_ds       #load data set either by using import function ot read.csv
summary(paysim)           #get more information about data set

#~~~~~~[check for missing values]
#isna <- is.na(paysim_ds) #returnsx boolean
sum(is.na(paysim_ds))     #check for missing elements, returns NA if there are any and sums them

#~~~~~~[take a random sample from main data set]
#run sample_df.R

#~~~~~~[partition data into train & test]
#run data_partitioning.R

#~~~~~~[check correlation between variables]
#run check_corr.R

#~~~~~~[logistic regression using train set and test model using test set]
#run log_reg.R

#~~~~~~[decision tree on all variables]
#run dectree.R
