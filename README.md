# Human Activity Recognition - tidy data set

This is a project aimed at creating tidy data set from UCI Human Activity 
Recognition Using Smartphones Data Set available here:
[linked phrase](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

To execute tidying you should do following steps:
1. Extract catalog "UCI HAR Dataset" in your working directory
2. Open R code "run_analysis.R" and source it.
        + Three functions will be created - prepareTidyDS, getlabels, getvarnames
3. Run prepareTidyDS()
        + As a result of analysis, "tidyDS.txt" will be created in the catalog "UCI HAR Dataset"
        
All the transformations are explaned in the codebook "CodeBook.md"