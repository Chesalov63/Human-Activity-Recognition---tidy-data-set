---
title: "CodeBook for UCI HAR - tidy data set"
author: "Vasily Chesalov"
date: "01 02 2020"
output: html_document
---

The purpose of this file is to describe the variables of tidy data set 
and transformations performed to clean up the data.

## Description of 'tidyDS.txt'

Variable | Explanation | Values or data type
------------- | ------------- | -------------
volunteer  | code number of volunteer participating in experiment  | 1:30
activity  | activity performed in experiment  | WALKING,  WALKING_UPSTAIRS,  WALKING_DOWNSTAIRS,  SITTING,  STANDING,  LAYING
variable  | features derived from accelerometer and gyroscope raw signals (66 features)  | character
meanvalue  | average values of each feature measurements (time-series) for each activity and each volunteer  | numbers in the range from -1 to 1

## Data manipulation performed

### Analysis of original data set

Original data are not tidy, because:

1. The result of experiment is spread over multiple files, with time-series information about subjects and activities stored separately.
2. Column headers in measurement sets are values (feature names), not variable names

### Merging

Observations in original data set are separated in testing and training sets.  
Each set is time-series of measurements across 561 features, linked to subjects and activities 
First, we read those sets into separate data frames:

* stest, xtest, ytest for testing set
* strain, xtrain, ytrain for training set

Both sets has the same variables (columns) but different number of observations (rows). 
We `rbind` appropriate files (subjects, measures, activities):

* sfull, xfull, yfull - this is full set of time-series but still separated in 3 synchronized data frames

Then we `cbind` three data frames in one to reconstruct all linked values in one row.
We include only measurements on the mean and standard deviation. 
To identify such columns we use search pattern:
`grep("mean..-[XYZ]|std..-[XYZ]|mean..$|std..$", features$varname)`,
where `features` is a data frame with feature labels (1st column is "id", 2nd column is "varname" - character vectors with names of the features)

The result is `fullDS` data frame with:

* 68 columns (volunteer, activity id, and 66 features)
* 10299 observations

List of 66 feature IDs is stored in the `shortlist` vector.

### Activity names

We had read activity names in the data frame `activities` (1st column is "id", 2nd column is "activity" - character vectors with names of the activities).

To add descriptive activity names we join `fullDS` and `activities` by the column "id".
Then we reorder the columns with `select`, now 2nd column is descriptive activity names.
The column with numeric "id" is no more needed, we exclude it.

### Feature names

We had read feature names in the data frame `features` (1st column is "id", 2nd column is "varname" - character vectors with variable names for features).

We rename columns in the `fullDS` using `colnames`, based on `shortlist` (IDs for features that we have actually extracted).

### Create tidy data set with averages

To create tidy data frame we use melting. Columns 1:2 of `fullDS` are already variables, so called "colvars". We `melt` columns 3:68 and create "tall" data frame `meltDS`, where all columns with features are converted into 2 variables: "variable" that contains feature names, and "value" that contains the concatenated data values from the previously separate columns.

Now we need to count averages of the time-series for each feature, activity, and volunteer. This is done by 
`group_by(meltDS, volunteer, activity, variable)`,  
and then `summarize(meltDS, meanvalue = mean(value))` to count averages of groups. 

The result is `tidyDS`, which we write into text file "tidyDS.txt" in the "UCI HAR Dataset" catalog.