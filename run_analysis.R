# load necessary libraries 
library(tidyr)
library(dplyr)

#read requisite files from the zip file

temp <- "getdata_projectfiles_UCI HAR Dataset.zip"

#read test data
datay_test <- read.table(unz(temp,"UCI HAR Dataset/test/y_test.txt"))
datax_test <- read.table(unz(temp,"UCI HAR Dataset/test/X_test.txt"))
datasubject_test <- read.table(unz(temp,"UCI HAR Dataset/test/subject_test.txt"))
#read train data
datay_train <- read.table(unz(temp,"UCI HAR Dataset/train/y_train.txt"))
datax_train <- read.table(unz(temp,"UCI HAR Dataset/train/X_train.txt"))
datasubject_train <- read.table(unz(temp,"UCI HAR Dataset/train/subject_train.txt"))

#read labels
features_raw <- read.table(unz(temp,"UCI HAR Dataset/features.txt"))
activityLabels <- read.table(unz(temp,"UCI HAR Dataset/activity_labels.txt"))

#===========end of read==========

#======= assigning proper data labels to avoid confusion
activityLabelColName <- c("ActivityLabel")
participantLabelColName <- c("ParticipantLabel")

colnames(datay_test) <- activityLabelColName
colnames(datasubject_test) <- participantLabelColName
colnames(datay_train) <- activityLabelColName
colnames(datasubject_train) <- participantLabelColName
#======= end of assogning proper data labels


#========combining all test and train data into a single data frame
#combine requisite columns
df_test <- cbind(datasubject_test,datay_test,datax_test)
df_train <- cbind(datasubject_train,datay_train,datax_train)

#combine rows into a single data frame
df <- bind_rows(df_train,df_test)
#=======end of combining into one data frame

#========== tidying up supplementary labels and column names
#tidying up activity labels
colnames(activityLabels) <- c("ActivityLabel","ActivityName")

#tidying up features
#clean up the set of features
features <- mutate(features_raw,MeasurementLabel=paste("V",V1,sep=""))
features <- features[,2:3]

colnames(features)[1] <- "MeasurementName"
#tidy up the format
features$MeasurementName = gsub("-|\\(\\)-",".",features$MeasurementName)
#now the only "()" left are at string end. Remove both () and ) at string end
features$MeasurementName = gsub("\\(\\)|\\)$|\\)","",features$MeasurementName)
#clean up remaining entries
features$MeasurementName = gsub("\\(|,",".",features$MeasurementName)
#===================end of tidying up supplementary labels and column names 

#===========rename dataframe columns, clean up the data frame, remove original data frame
#assign cleaned up descriptive labels to data frame column names
colnames(df) <- as.character(colnames(df))
colnames(df)[3:563] <- features$MeasurementName

#make a pruned dataframe with only relevant columns
df_pruned <- bind_cols(df[,1:2],select(df,contains("mean")),select(df,contains("std")))
#remove the original data frame from memory since no longer needed
rm(df)

#add descriptive activity labels
df_pruned <- merge(df_pruned,activityLabels,by.x = "ActivityLabel", by.y = "ActivityLabel")
#================== end of rename dataframe columns, clean up the data frame, remove original data frame


#========= final data frame as per step 4 with tidy data for pertinent measurements (only containing mean and standard deviation)
df_pruned <- df_pruned %>% select(ParticipantLabel,ActivityName,tBodyAcc.mean.X:fBodyBodyGyroJerkMag.std) %>% rename(SubjectLabel = ParticipantLabel)

#========= final data frame as per step 5.  independent tidy data set with the average of each variable for each activity and each subject.
mean_data <- df_pruned %>% gather(MeasName, MeasValue,-ActivityName,-SubjectLabel) %>%  
                      group_by(SubjectLabel,ActivityName,MeasName)  %>% 
                      summarize(MeanValue = mean(MeasValue)) %>% spread(MeasName,MeanValue)

#write output
write.table(mean_data,"mean_values_by_activity_and_participant.txt", row.names = FALSE)





