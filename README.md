# getdata

 run_analysis.R
 Susan Lively Klug : 7/26/2015

## Coursera : Getting and Cleaning Data rprog-030 : requirements

 1. "Step One" Merges the training and the test sets to create one data set

 2. "Step Two" Extracts only the measurements on the mean and standard 
 	deviation for each measurement.

 3. "Step Three" Uses descriptive activity names to name the activities 
 	in the data set

 4. "Step Four" Appropriately labels the data set with descriptive variable 
 	names.

 5. "Step Five" From the data set in step 4, creates a second, independent 
 	tidy data set with the average of each variable for each activity 
	and each subject.

## Notes :
 I did not follow the requirements in a step by step order as some of the
 requirements logically were more easily understood by being done earlier.
 The code includes comments for the starting and ending of the "Step"s which
 are embedded within other steps.  You can do a text search for 
 "Step One" to find the beginning and ending of Step One, etc.
 


## You can find the Data for the project here

 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## For the full description of the data

 http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Your directory structure must look like this:

 Data is in several text format files in two directories, test and train
 ./UCI HAR Dataset
    README.txt, activity_labels.txt, features.txt, features_info.txt
 ./UCI HAR Dataset/train
    X_test.txt, subject_test.txt, y_test.txt
    ./Inertial Signals # extraneous data not needed for this project
 ./UCI HAR Dataset/test
    X_test.txt, subject_test.txt, y_test.txt
    ./Inertial Signals # extraneous data not needed for this project

required libraries
library(dplyr)
library(reshape2)
