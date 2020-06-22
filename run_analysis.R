# Set the working directory
setwd("C:/Users/ASG/Desktop/Peer-graded Assignment Getting and Cleaning Data Course Project")

# Load the required packages
LoadRequiredPackages <- function() {
  # Load the required packages.
  if (!require('pacman')) {
    install.packages('pacman')
  }
  pacman::p_load(data.table, dplyr, dtplyr, readr, tidyr)
}

# Load the data
dataset.dir <- 'UCI HAR Dataset'
if (!dir.exists(dataset.dir)) {
  dataset.url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  temp <- tempfile()
  download.file(dataset.url, temp)
  unzip(temp)
}

# Read the data and tidy up test and train sets
# Read data files for X
path.train  <-  file.path(dataset.dir, 'train')
x_train_data  <- read.table(file.path(path.train, 'X_train.txt'))
path.test  <-  file.path(dataset.dir, 'test')
x_test_data <- read.table(file.path(path.test, 'X_test.txt'))
# Read data files for y
y_train_data  <- read.table(file.path(path.train, 'y_train.txt') , col.names = "Activity", colClasses = "factor")
y_test_data <- read.table(file.path(path.test, 'y_test.txt') , col.names = "Activity", colClasses = "factor")

# Read subject files
subject_train  <-  read.table(file.path(path.train, 'subject_train.txt'), col.names = "Subject", colClasses = "factor")
subject_test  <-  read.table(file.path(path.test, 'subject_test.txt') , col.names = "Subject", colClasses = "factor")

# Load feature names
feature_names  <-  read.table(file.path(dataset.dir, 'features.txt'),
                              col.names = c("feature_number", "feature_label"),
                              stringsAsFactors = FALSE)
# Make sure the labels follow the order of the column number (not really needed,
# given the content of the actual features.txt, but it could be required if the
# file changes)
feature_names  <-  feature_names[order(feature_names$feature_number), ]

# 1. Merge the training and the test sets to create one data set. 
# The call to rbind simply puts one dataset after the other, keeping the order
# This is possible because both tables have the same variables
full_dataset <- rbind(x_train_data, x_test_data)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
# Create a vector with the indexes of the variable names including "mean" or "std" in the name
subset_columns <- grep("mean|std", feature_names$feature_label)
# Extract those variables from full_dataset
selected_dataset <- full_dataset[, subset_columns]
# Add the activity labels and subject names in the first and second columns
selected_dataset <- cbind(rbind(y_train_data, y_test_data), 
                          rbind(subject_train, subject_test), selected_dataset)

# 3. Use descriptive activity names to name the activities in the data set
# Load activity names from the file
activity_labels  <-  read.table(file.path(dataset.dir, 'activity_labels.txt'),
                                col.names = c("Activity_number", "Activity_label"),
                                colClasses = c("integer", "factor"))
# Make sure the labels follow the order of the number in the first column
activity_labels  <-  activity_labels[order(activity_labels$Activity_number), ]
# Assign the descriptive labels to the factors
levels(selected_dataset$Activity)  <-  activity_labels$Activity_label

# 4. Appropriately labels the data set with descriptive variable names.
# When feature_names$feature_label were assigned to names()
# the first 2 columns of selected_dataset were preserved, as they
# already were correct
# Replace ^t with Time
names(selected_dataset)[3:length(names(selected_dataset))] <- 
  gsub("^t", "Time", feature_names$feature_label[subset_columns])
# Replace ^f with Frequency
names(selected_dataset) <- gsub("^f", "Frequency", names(selected_dataset))
# Replace Acc with Acceleration
names(selected_dataset) <- gsub("Acc", "Acceleration", names(selected_dataset), fixed = TRUE)
# Replace Mag with Magnitude
names(selected_dataset) <- gsub("Mag", "Magnitude", names(selected_dataset), fixed = TRUE)
# Replace jerk with Jerk (for consistency)
names(selected_dataset) <- gsub("jerk", "Jerk", names(selected_dataset), fixed = TRUE)
# Eliminate ()
names(selected_dataset) <- gsub("()", "", names(selected_dataset), fixed = TRUE)


# 5. Create a 2nd, separate tidy data set with the average of each variable for each activity and subject.
# The suffix "variable_mean" is added to each variable name
library(magrittr)
tidy_dataset <- selected_dataset %>%
  dplyr::group_by (Activity, Subject) %>%
  dplyr::summarise_all(list(variable_mean = mean))

# Write the result to the file tidy_dataset.txt with column headers
write.table(tidy_dataset, file = "tidy_dataset.txt", col.names = TRUE, row.names = FALSE)
test_dataset <- read.table("tidy_dataset.txt", header = TRUE)
View(test_dataset)

