    library(dplyr)
    
      # download zip file containing data if it hasn't already been downloaded
      zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      zipFile <- "UCI HAR Dataset.zip"
      
      if (!file.exists(zipFile)) {
        download.file(zipUrl, zipFile, mode = "wb")
      }
      
      # unzip zip file containing data if data directory doesn't already exist
      dataPath <- paste(getwd(), "UCI HAR Dataset", sep = "/")
  
      if (!file.exists(dataPath)) {
        unzip(zipFile)
      }
      
      features <- read.table(paste(dataPath, "features.txt", sep = "/"), col.names = c("n","functions"))
      activities <- read.table(paste(dataPath, "activity_labels.txt", sep = "/"), col.names = c("code", "activity"))
      subject_test <- read.table(paste(dataPath, "test/subject_test.txt", sep = "/"), col.names = "subject")
      x_test <- read.table(paste(dataPath, "test/X_test.txt", sep = "/"), col.names = features$functions)
      y_test <- read.table(paste(dataPath, "test/y_test.txt", sep = "/"), col.names = "code")
      subject_train <- read.table(paste(dataPath, "train/subject_train.txt", sep = "/"), col.names = "subject")
      x_train <- read.table(paste(dataPath, "train/X_train.txt", sep = "/"), col.names = features$functions)
      y_train <- read.table(paste(dataPath, "train/y_train.txt", sep = "/"), col.names = "code")
        
      X <- rbind(x_train, x_test)
      Y <- rbind(y_train, y_test)
      Subject <- rbind(subject_train, subject_test)
      Merged_Data <- cbind(Subject, Y, X)
      
      TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
      
      TidyData$code <- activities[TidyData$code, 2]
      
      head(TidyData)
      names(TidyData)[2] = "activity"
      names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
      names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
      names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
      names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
      names(TidyData)<-gsub("^t", "Time", names(TidyData))
      names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
      names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
      names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
      names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
      names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
      names(TidyData)<-gsub("angle", "Angle", names(TidyData))
      names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))
      
