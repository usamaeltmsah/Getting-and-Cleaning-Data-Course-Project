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
    
    features <- read.table(file.path(dataPath, "features.txt"), col.names = c("n","functions"))
    activity_labels <- read.table(file.path(dataPath, "activity_labels.txt"), col.names = c("code", "activity"))
    
    subject_test <- read.table(file.path(dataPath, "test", "subject_test.txt"))
    subject_train <- read.table(file.path(dataPath, "train", "subject_train.txt"))
    
    x_train <- read.table(file.path(dataPath, "train", "X_train.txt"), col.names = features$functions)
    y_train <- read.table(file.path(dataPath, "train", "y_train.txt"), col.names = "code")
    
    x_test <- read.table(file.path(dataPath, "test", "X_test.txt"), col.names = features$functions)
    y_test <- read.table(file.path(dataPath, "test", "y_test.txt"), col.names = "code")
    
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
