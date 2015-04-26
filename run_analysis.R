#Columnames

setwd("C:/Users/KiHr/Desktop/UCI HAR Dataset")

features <- read.table("features.txt")

#Import trainingset and add columnnames

setwd("C:/Users/KiHr/Desktop/UCI HAR Dataset/train")

trainX <- read.table("X_train.txt")
trainy <- read.table("y_train.txt")
trainSubject <- read.table("subject_train.txt")

colnames(trainX) <- features[,2]
colnames(trainy) <- c("Activity_id")
colnames(trainSubject) <- c("Subject_id")

train <- cbind(trainy, trainSubject, trainX)

#Import testset 

setwd("C:/Users/KiHr/Desktop/UCI HAR Dataset/test")

testX <- read.table("X_test.txt")
testy <- read.table("y_test.txt")
testSubject <- read.table("subject_test.txt")

colnames(testX) <- features[,2]
colnames(testy) <- c("Activity_id")
colnames(testSubject) <- c("Subject_id")

test <- cbind(testy, testSubject, testX)

#Merge trainingset and testset to one dataset

dataCombined <- rbind(train,test)

#Extract only measurements with mean and standard deviation

colNames <- colnames(dataCombined)
columnsRelevant <- (grepl("Activity..",colNames) | grepl("Subject..",colNames) | grepl("..-mean..",colNames) & !grepl("..-meanFreq..",colNames)| grepl("..-std..",colNames))

dataRelevant <- dataCombined[, columnsRelevant]

#Add activity labels to the activity_id

setwd("C:/Users/KiHr/Desktop/UCI HAR Dataset")

activityLabels <- read.table("activity_labels.txt", col.names=c("Activity_id", "Activity_label"))

datasetTidy <- merge(dataRelevant, activityLabels, by="Activity_id")

#Only show the averages per activity_label
datasetMeanTidy <- aggregate(datasetTidy, by=list(Activity = datasetTidy$Activity_label, Subject=datasetTidy$Subject_id), mean)

#Activity_id & Subject_id should be deleted, therefor I ran the following code, one by one.
datasetMeanTidy[,3] = NULL
datasetMeanTidy[,3] = NULL

#Export created tidy dataset as txt
write.table(datasetMeanTidy, "tidyDataset.txt", sep="\t")

