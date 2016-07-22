## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## 1.  Merges the training and the test sets to create one data set.
if (!require("data.table")) {
  install.packages("data.table")
}

require("data.table")

## Downloading and extracting the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile = "GetData.zip")
unzip("GetData.zip")

## Reading Test Data
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/Y_test.txt")
subTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Reading Train Data
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
subTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Binding Test and Train Data
X <- rbind(xTest,xTrain)
Y <- rbind(yTest,yTrain)
Sub <- rbind(subTest,subTrain)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## Reading features and activity
features<-read.table("UCI HAR Dataset/features.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt")

## getting feature indeces with mean() and std() in the names
index<-grep("mean\\(\\)|std\\(\\)", features[,2])

## length of features
length(index)

## getting variables with mean and std in X
X<-X[,index]

## checking dimensions for the new subset
dim(X)

## 3. Uses descriptive activity names to name the activities in the data set

## Replacing the numeric values with lookup values from activity.txt
## Tthis does not re-arange Y
Y[,1]<-activity[Y[,1],2]

## verifying the result with head() method
head(Y)

## 4. Appropriately labels the data set with descriptive activity names.
## Get Names for Variables
names<-features[index,2]

## Updating he column names fir the new dataset
names(X)<-names
names(Sub)<-"SubjectID"
names(Y)<-"Activity"

## Merging the three variables to form a new dataset
CleanedData<-cbind(Sub, Y, X)

## verifying the result with head() method for the first five columns
head(CleanedData[,c(1:4)])

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

CleanedData <- data.table(CleanedData)
## features average by subject and activity
TidyData <- CleanedData[, lapply(.SD, mean), by = 'SubjectID,Activity']

## checking dimensions for the new subset
dim(TidyData)

## Writing TidyData dataset into a file Tidy.txt
write.table(TidyData,file="Tidy.txt",row.names = FALSE)

## verifying the result with head() method for the first five columns and ten rows.
head(TidyData[order(SubjectID)][,c(1:4), with = FALSE],10) 
