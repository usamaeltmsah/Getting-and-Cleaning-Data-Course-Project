library(dplyr)

x_test <- read.table("/media/usama/F/NTL/Data Science/UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("/media/usama/F/NTL/Data Science/UCI HAR Dataset/test/y_test.txt", col.names = "code")

x_train <- read.table("/media/usama/F/NTL/Data Science/UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("/media/usama/F/NTL/Data Science/UCI HAR Dataset/train/y_train.txt", col.names = "code")

subject_test <- read.table("/media/usama/F/NTL/Data Science/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("/media/usama/F/NTL/Data Science/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

features <- read.table("/media/usama/F/NTL/Data Science/UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity_labels <- read.table("/media/usama/F/NTL/Data Science/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
 
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)

  Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

tidy_data <- Merged_Data %>% 
  select(subject, code, contains("mean"), contains("std"))

tidy_data$code <- activity_labels[tidy_data$code, 2]

names(tidy_data)[2] = "activity"

names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))

final_data <- tidy_data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(final_data, "final_data.txt", row.name=FALSE)
  
str(final_data)
