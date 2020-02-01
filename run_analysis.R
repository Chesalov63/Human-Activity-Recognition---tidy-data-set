## Run function 'prepareTidyDS()' without any parameters.


## function 'getlabels' loads and prepares table of activity labels
getlabels <- function(){
        activities <- read.table("UCI HAR Dataset/activity_labels.txt")
        activities$V2 <- as.character(activities$V2)
        colnames(activities) <- c("id", "activity")
        return(activities)
}

## function 'getvarnames' loads and prepares table of variable names
getvarnames <- function(){
        features <- read.table("UCI HAR Dataset/features.txt")
        features$V2 <- as.character(features$V2)
        colnames(features) <- c("id", "varname")
        return(features)
}

## This is main function. 'prepareTidyDS' creates tidy data set 
## and saves it in text file 'tidyDS.txt' in the 'UCI HAR Dataset' catalog 
## extracted from zip-file. This catalog should be in the working directory.

prepareTidyDS <- function(){
        
        library(dplyr)
        library(reshape2)
        
        ## Read label names for activities and featues
        activities <- getlabels()
        features <- getvarnames()
        
        ## Read test data set (9 volunteers, 2947 observations)
        stest <- read.table("UCI HAR Dataset/test/subject_test.txt")
        xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
        ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
        print("test data input done")
        
        ## Read train data set (21 volunteers, 7352 observations)
        strain <- read.table("UCI HAR Dataset/train/subject_train.txt")
        xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
        ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
        print("training data input done")
        
        ## Merge the training and the test sets to create one data set
        sfull <- rbind(stest,strain); colnames(sfull) <- "volunteer"
        xfull <- rbind(xtest,xtrain)
        yfull <- rbind(ytest,ytrain);  colnames(yfull) <- "id"
        
        rm(list=c("stest", "strain", "xtest", "xtrain", "ytest", "ytrain"))
        
        ## Extract only the measurements on the mean and standard deviation 
        shortlist <- grep("mean..-[XYZ]|std..-[XYZ]|mean..$|std..$",
                          features$varname)
        fullDS <- cbind(sfull, yfull, xfull[,shortlist])
        print("Merge done")
        
        ## Use descriptive activity names to name the activities in the data set
        fullDS <- inner_join(fullDS, activities, by = "id")
        fullDS <- select(fullDS, volunteer, activity, 3:68)
 
        ## Appropriately label the data set with descriptive variable names
        colnames(fullDS)[3:68] <- features$varname[shortlist]
        
        ## Melt columns 3:68, those values should be in rows not columns
        meltDS <- melt(fullDS, id=1:2)
        print("Melt done")
        
        rm(list=c("fullDS", "sfull", "xfull", "yfull", "shortlist"))
        
        ## Calculate average of each variable for each activity and each subject 
        meltDS <- group_by(meltDS, volunteer, activity, variable)
        tidyDS <- summarize(meltDS, meanvalue = mean(value))
        
        ## write tidy data in the text file without row names
        write.table(tidyDS, "UCI HAR Dataset/tidyDS.txt", row.name=FALSE)
        print("tidyDS file is ready!")
}
