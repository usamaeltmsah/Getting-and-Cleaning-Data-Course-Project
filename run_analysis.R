library(dplyr)
# download zip file containing data if it hasn't already been downloaded
zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
}

# unzip zip file containing data if data directory doesn't already exist
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
  unzip(zipFile)
}


features <- read.table(dataPath, col.names = c("n","functions"))
activity_labels <- read.table(dataPath, col.names = c("code", "activity"))

x_test <- read.table(dataPath, col.names = features$functions)
y_test <- read.table(dataPath, col.names = "code")

x_train <- read.table(dataPath, col.names = features$functions)
y_train <- read.table(dataPath, col.names = "code")

subject_test <- read.table(dataPath, col.names = "subject")
subject_train <- read.table(dataPath, col.names = "subject")


activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")


humanActivity <- rbind(
  cbind(subject_train, x_train, y_train),
  cbind(subject_test, x_test, y_test)
)

rm(subject_train, x_train, y_train, 
   subject_test, x_test, y_test)

colnames(humanActivity) <- c("subject", features[, 2], "activity")

Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

importantColumns <- grepl("subject|activity|mean|std", colnames(humanActivity))

humanActivity <- humanActivity[, importantColumns]

humanActivity$activity <- factor(humanActivity$activity, levels = activities[, 1], labels = activities[, 2])

humanActivityCols <- colnames(humanActivity)

humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)

humanActivityCols <- gsub("^f", "frequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "timeDomain", humanActivityCols)
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)

humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

colnames(humanActivity) <- humanActivityCols

humanActivityMeans <- humanActivity %>% 
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(humanActivityMeans, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)
