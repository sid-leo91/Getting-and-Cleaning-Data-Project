
library(reshape2)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "~/Desktop/Coursera/GetClean.zip", method = "curl")

unzip("~/GetClean.zip")

###### Train Data #########

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                            sep = '\n', col.names = "subject")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = '\t', col.names = "X")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = '\n', col.names = "Y")


###### Test Data #########
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                           sep = '\n', col.names = "subject")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = '\t', col.names = "X")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = '\n', col.names = "Y")


# Loading the text file containing features list
features <- read.table("./UCI HAR Dataset/features.txt", sep = '\n', col.names = "Features")
features$Features <- sub("[0-9]* ", "",features$Features)

vector_indexes <- sort(union(grep("mean[^Freq]", features$Features), grep("std()", features$Features)))

#Editing feature names
selected_features <- features$Features[vector_indexes]
selected_features <- gsub("[-()]","",selected_features)
selected_features <- gsub("mean","Mean",selected_features)
selected_features <- gsub("std","Std",selected_features)
selected_features <- gsub("BodyBody","Body",selected_features)

# Combing datasets
Y_X.train <- cbind(subject_train,Y_train, X_train)
Y_X.test <- cbind(subject_test,Y_test, X_test)
df <- rbind(Y_X.train, Y_X.test)

# Extracing the mean() and std() elements from the list of features
for(i in 1:nrow(df)) {
  row_vectors <- df[i,3]
  vector_split <- strsplit(as.character(row_vectors), " ")
  vector_split <- vector_split[[1]][-which(vector_split[[1]] == "")]
  selected_vector <- vector_split[vector_indexes]
  for(j in 1:66){
    df[i, j+3] <- selected_vector[j]
  }
}

# renaming the columns
colnames(df)[1] <- "Subject"
colnames(df)[2] <- "Activity"
colnames(df)[4:69] <- selected_features

#Removing the third column which is a list of all featues
df <- df[,-3]

#Converting features columns from character to numeric
df[,3:68] <- as.data.frame(sapply(df[,3:68], function(x) as.numeric(x)))

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",
                              col.names = c("X","activity"))

# Labelling the activities as appropriate
df$Activity <- factor(df$Activity, levels = activity_labels[,1], labels = activity_labels[,2])


#Average of each variable for each avivity and subject
df.melted <- melt(df, id = c("Subject", "Activity"))
tidy_data <- dcast(df.melted, Subject + Activity ~ variable, mean)

write.table(tidy_data, "./DataScience/Course3_Project/tidy_data.txt", row.names = F)
