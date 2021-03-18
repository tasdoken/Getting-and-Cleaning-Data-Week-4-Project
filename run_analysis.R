Getting and Cleaning Data Course Project
Öznur TAŞDÖKEN
Date: 18.03.2021

1.step: 
install.packages("dplyr")
install.packages("data.table")
Load packages
library(data.table)
library(dplyr)

step 1: Download the dataset
if(!file.exists("./getcleandata")){dir.create("./getcleandata")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./getcleandata/projectdataset.zip")

# Unzip the dataset
unzip(zipfile = "./getcleandata/projectdataset.zip", exdir = "./getcleandata")


step 2. Merge the training and test datasets
 # read training data
trainingSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(dataPath, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(dataPath, "train", "y_train.txt"))

# read test data
testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataPath, "test", "X_test.txt"))
testActivity <- read.table(file.path(dataPath, "test", "y_test.txt"))

# read features, don't convert text labels to factors
features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)
  ## note: feature names (in features[, 2]) are not unique
  ##       e.g. fBodyAcc-bandsEnergy()-1,8

# read activity labels
activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")

step 3:  Merge the training and the test sets to create one data set
concatenate individual data tables to make single data table
humanActivity <- rbind(
  cbind(trainingSubjects, trainingValues, trainingActivity),
  cbind(testSubjects, testValues, testActivity)
)

# remove individual data tables to save memory
rm(trainingSubjects, trainingValues, trainingActivity, 
   testSubjects, testValues, testActivity)

# assign column names
colnames(humanActivity) <- c("subject", features[, 2], "activity")

step 4: Extracting only the measurements on the mean and sd for each measurement
      
      #  Reading column names
        colNames <- colnames(finaldataset)
        
      #  Create vector for defining ID, mean, and sd
        mean_and_std <- (grepl("activityID", colNames) |
                         grepl("subjectID", colNames) |
                         # THIS WAS COPIED FROM https://github.com/wdluft/getting-and-cleaning-data-week-4-project
# SHOULD NOT BE ACCEPTED AS A NEW SUBMISSION
                         grepl("mean..", colNames) |
                         grepl("std...", colNames)
        )
        
      #  Making nessesary subset
        setforMeanandStd <- finaldataset[ , mean_and_std == TRUE]
        
        
        
  step 5:    Create a second, independent tidy set with the average of each variable for each activity and each subject   
   # group by subject and activity and summarise using mean
humanActivityMeans <- humanActivity %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

# output to file "tidy_data.txt"
write.table(humanActivityMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)     










