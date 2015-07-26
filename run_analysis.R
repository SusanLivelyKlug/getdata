#
# run_analysis.R
# Susan Lively Klug : 7/26/2015
# Coursera : Getting and Cleaning Data rprog-030
#
# 1. "Step One" Merges the training and the test sets to create one data set
# 2. "Step Two" Extracts only the measurements on the mean and standard deviation
#    for each measurement.
# 3. "Step Three" Uses descriptive activity names to name the activities in the data set
# 4. "Step Four" Appropriately labels the data set with descriptive variable names.
# 5. "Step Five" From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.
#
# Data for the project from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# full description for the data
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# Data is in several text format files in two directories, test and train
# ./UCI HAR Dataset
#    README.txt, activity_labels.txt, features.txt, features_info.txt
# ./UCI HAR Dataset/train
#    X_test.txt, subject_test.txt, y_test.txt
#    ./Inertial Signals # extraneous data not needed for this project
# ./UCI HAR Dataset/test
#    X_test.txt, subject_test.txt, y_test.txt
#    ./Inertial Signals # extraneous data not needed for this project
#
library(dplyr)
library(reshape2)

#
# run the script in the directory with the Dataset and the subdirectories
# train and test.  Here we set up the paths for the filenames
# The script must be in the ./UCI HAR Dataset directory, or change the path
# here.
#
path <- "./"

trainpath <- paste(path, "train/", sep="")
train_sub_fname <- paste(trainpath, "subject_train.txt", sep="")
train_data_fname <- paste(trainpath, "X_train.txt", sep="")
train_activity_fname <- paste(trainpath, "y_train.txt", sep="")

testpath <- paste(path, "test/", sep="")
test_sub_fname <- paste(testpath, "subject_test.txt", sep="")
test_data_fname <- paste(testpath, "X_test.txt", sep="")
test_activity_fname <- paste(testpath, "y_test.txt", sep="")

##
##   Step One:  Merge the training and the test sets to create one data set
##
##--------------------------------------------------------------------------
#
#    subjects_train, subjects_test
# get the ID numbers of each subject in train and test
#
subjects_train <- read.table(train_sub_fname)
subjects_test  <- read.table(test_sub_fname)

#
#    activity_nums_train, activity_nums_test
# get the activity numbers for train and test
#
activity_nums_train <- read.table(paste(trainpath, "y_train.txt", sep=""))
activity_nums_test <- read.table(paste(testpath, "y_test.txt", sep=""))

#
#    bind the subjects with their activities
#
sub_train <- cbind(subjects_train, activity_nums_train)
colnames(sub_train) <- c("subject", "activity")
sub_tests <- cbind(subjects_test, activity_nums_test)
colnames(sub_tests) <- c("subject", "activity")

#
#    reading in the big data tables
#
train_data <- read.table(train_data_fname)
test_data <- read.table(test_data_fname)
##
## Step Four: Appropriately labels the data set
##   with descriptive variable names.
## note: doing step four here makes completion of step one and two simple.
##--------------------------------------------------------------------------
#    column_labels: all of the readings
#    set the column names to meaningful words from the features.txt
#
column_labels <- read.table("./features.txt")
colnames(train_data) <- column_labels$V2
colnames(test_data) <- column_labels$V2
##
## This completes Step Four-------------------------------------------------
##

#
# bind the train data with the train subjects/activities data
#
train_data <- cbind(sub_train, train_data)
test_data <- cbind(sub_tests, test_data)


#
# bind the complete train set with the complete test set
# (the sets now have names, activities together)
#
all_data <- rbind(test_data,train_data)
##
## This completes Step One---------------------------------------------------
##

##
##   Step Two: Extracts only the measurements on the
##         mean and standard deviation for each measurement."
##
##--------------------------------------------------------------------------
#
# Use the column select features of data tables to only take
# the columns that contain "mean()" and "std()". Analyzed data
# in features.txt by hand to determine the regular expression
# needed.  Do this (Step 2) here to reduce the number of columns
# to bind for the final data frame for Step 1.
# Requirements for Step 2 are : only the measurements on the mean
# and standard deviation for each measurement.
# Therefore we eliminate *meanFreq()*, and angle(*Mean) as well as
# column that is not "subject", "activity", or contains "mean()" or "std" in
# the column label.  This could potentially be done more efficiently done
# at an earlier step.
all_data <-all_data[,grep("subject|activity|*mean\\(\\)*|*std*",names(all_data))]
##
##  This completes Step Two-------------------------------------------------
##

##
##   Step Three: Uses descriptive activity names to name the
##        activities in the data set
##
##--------------------------------------------------------------------------
#
#    activity names
# activity_labels.txt use for pretty data
#
activity_names <- read.table(paste(path, "activity_labels.txt", sep=""))
activity_names[] <- lapply(activity_names, as.character)
a <- activity_names$V2
for(i in 1:6) {
     all_data$activity[all_data$activity==i] <- a[i]
}
# This completes Step Three-------------------------------------------------

##
##   Step Five: From the data set in step 4, creates a second, independent
##   tidy data set with the average of each variable for each activity and
##   each subject.
##
##--------------------------------------------------------------------------
#    I am presuming the "data set in step 4" is the complete combined data
#    with the appropriate labels and descriptive activities in place. I did
#    my Step 4 out of order, but we are ready for Step 5 now.
#    summarize the data by the activity done per subject
#    taking the average of the activity.
#
tidy_data <- all_data %>% group_by(subject,activity) %>% summarise_each(funs(mean))
##
## This completes Step Five-------------------------------------------------
##



#
#  Some kind of feedback that the script has run is always nice
#
print("Analysis complete, tidy data dimensions=")
res <- dim(tidy_data)
print(res)

write.table(tidy_data, "./tidy_data.txt", row.names=FALSE)

print("table written as text file ./tidy_data.txt")

