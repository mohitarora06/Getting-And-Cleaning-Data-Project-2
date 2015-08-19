#Script for Getting and processing data course project

#Setting the reference path
path <- file.path("UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)


#Uploading data for both training and testing 
dataTest <- read.table(file.path(path,"/test/X_test.txt"), header = FALSE)
dataTrain <- read.table(file.path(path,"/train/X_train.txt"), header = FALSE)


#Uploading activities for both training and testing 
dataActivityTrain <- read.table(file.path(path, "/train/y_train.txt"), header = FALSE)
dataActivityTest <- read.table(file.path(path, "/test/y_test.txt"), header = FALSE)


#Uploading subjects data for both training and testing 
dataSubjectTrain <- read.table(file.path(path, "/train/subject_train.txt"), header = FALSE)
dataSubjectTest <- read.table(file.path(path, "/test/subject_test.txt"), header = FALSE)

#Merging test and training data
datafeatures <- rbind(dataTrain, dataTest)
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataSubjects <- rbind(dataSubjectTrain, dataSubjectTest)


#Setting name of the data 
colnames(dataActivity) = c("Activity")
colnames(dataSubjects) = c("Subject")

#Uploading names for the features 
namesOfFeature <- read.table(file.path(path, "features.txt"), header = FALSE)
colnames(datafeatures) = namesOfFeature$V2

#Extracting the columns with mean and standard deviation of the data
datafeaturesReq <- datafeatures[, grep("mean\\(\\)|std\\(\\)", colnames(datafeatures))]


#Combining Features, activity and subject data together
allData <- cbind(dataActivity, dataSubjects, datafeaturesReq)


#Uploading names of activity 
activityNames <- read.table(file.path(path, "activity_labels.txt"), header = FALSE)
colnames(activityNames) <- c("Activity", "ActivityNames") 


#Merging activity names according to activity numbers
allData <- merge(activityNames, allData , by="Activity", all.x=TRUE)


#Replacing names of the variables to appropriate names respectively
# 1) t - Time 2) f- frequency 3) Acc- Acceleration 4) Mag - Magnitude 5) mean- Mean 6) sd - SD 7) Gyro- Gyroscope

names(allData) <- gsub("^t", "time", names(allData))
names(allData) <- gsub("^f", "frequency", names(allData))
names(allData) <- gsub("mean", "Mean", names(allData))
names(allData) <- gsub("sd", "SD", names(allData))
names(allData) <- gsub("Acc", "Accelerometer", names(allData))
names(allData) <- gsub("Mag", "Magnitude", names(allData))
names(allData) <- gsub("Gyro", "Gyroscope", names(allData))


#creating clean data with the average of each variable based on activity and subject
tidyData <- aggregate(.~ Activity + Subject + ActivityNames, allData, mean)
write.table(tidyData, "tidyData.txt", row.names = FALSE)