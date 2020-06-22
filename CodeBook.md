The run_analysis.R script performs the data preparation and then followed by the 5 steps required as described in the course project’s definition.

        Dataset downloaded and extracted under the folder called UCI HAR Dataset
        The following lists the datast files used:

            features.txt - names of the features

            activity_labels.txt - names and ids of the activities

            X_train.txt - training observations of volunteers

            subject_train.txt - the ids of each volunteer related to each of the observations in X_train.txt.

            y_train.txt - the ids of the activity related to each observation in the X training set

            X_test.txt - test observations of the volunteers

            subject_test.txt - the ids of the volunteers in the X test set

            y_test.txt - the ids of the activity for the X_test set observations

        The data processing makes the following transformations to the original dataset:

            Step 1. Merges the training and the test sets to create one data set.

            Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.

            Step 3. Uses descriptive activity names to name the activities in the data set
                    Entire numbers in code column of the tidy_dataset replaced with corresponding activity taken from second column of the activities variable

            Step 4. Appropriately labels the data set with descriptive activity names.
                    Replace Acc with Acceleration
                    Replace jerk with Jerk
                    Replace Mag with Magnitude
                    Replace ^f with Frequency
                    Replace ^t with Time

            Step 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
                    tidy_dataset.txt (180 rows, 88 columns) is created by summarizing tidy_dataset, taking the means of each variable for each activity and each subject, after grouped by subject and activity.
