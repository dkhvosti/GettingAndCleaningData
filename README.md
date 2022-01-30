# GettingAndCleaningData

The data represent data collected from the accelerometers from the Samsung Galaxy S smartphone in a study of 30 participants. Description of the original data is available here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data are contained in a zip archive
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The script does the following (assuming that the zip file has already been downloaded into working directory):

1. Merges the training and the test sets to create a single data set.
Test dataset within
UCI HAR Dataset/test/

Train dataset
UCI HAR Dataset/train/

2. Reads feature and activity descriptive labels
Features
UCI HAR Dataset/features.txt

Activity labels
UCI HAR Dataset/activity_labels.txt

3. Tidies the feature names to remove "-", parentheses, commas

4. Extracts only the features on the mean and standard deviation for each measurement.
I.e., features that contain the "mean" and "std" in feature name
 
5. Tidies up the dataset (reorders columns, arranges rows) 

   
6. Uses descriptive activity names to name the activities in the data set


7. From the data set in step 6, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
