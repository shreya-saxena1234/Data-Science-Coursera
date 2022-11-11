# run_analysis.R

#0. prepare LIBs
library(reshape2)


# STEP 1: Fetch dataset from web
raw_Data_Dir <- "./rawData"
raw_Data_Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
raw_Data_Filename <- "rawData.zip"
raw_Data_DFn <- paste(raw_Data_Dir, "/", "rawData.zip", sep = "")
data_Dir <- "./data"

if (!file.exists(raw_Data_Dir)) {
    dir.create(raw_Data_Dir)
    download.file(url = raw_Data_Url, destfile = raw_Data_DFn)
}
if (!file.exists(data_Dir)) {
    dir.create(data_Dir)
    unzip(zipfile = raw_Data_DFn, exdir = data_Dir)
}


# STEP 2: Merge {train, test} data set
# refer: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# train data
x_train <- read.table(paste(sep = "", data_Dir, "/UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(paste(sep = "", data_Dir, "/UCI HAR Dataset/train/Y_train.txt"))
s_train <- read.table(paste(sep = "", data_Dir, "/UCI HAR Dataset/train/subject_train.txt"))

# test data
x_test <- read.table(paste(sep = "", data_Dir, "/UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(paste(sep = "", data_Dir, "/UCI HAR Dataset/test/Y_test.txt"))
s_test <- read.table(paste(sep = "", data_Dir, "/UCI HAR Dataset/test/subject_test.txt"))

# merge {train, test} data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)


#3. load feature & activity info
# feature info
feature <- read.table(paste(sep = "", data_Dir, "/UCI HAR Dataset/features.txt"))

# activity labels
a_label <- read.table(paste(sep = "", data_Dir, "/UCI HAR Dataset/activity_labels.txt"))
a_label[,2] <- as.character(a_label[,2])

# STEP 3: Extract feature (cols & name)s named 'mean, std'
selected_Cols <- grep("-(mean|std).*", as.character(feature[,2]))
selected_Col_Names <- feature[selected_Cols, 2]
selected_Col_Names <- gsub("-mean", "Mean", selected_Col_Names)
selected_Col_Names <- gsub("-std", "Std", selected_Col_Names)
selected_Col_Names <- gsub("[-()]", "", selected_Col_Names)


# STEP 4: Extract data by cols & using descriptive name
x_data <- x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
allData$Subject <- as.factor(allData$Subject)


# STEP 5. Generate tidy data set
melt_Data <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(melt_dData, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)
