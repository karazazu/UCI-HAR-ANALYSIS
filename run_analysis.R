# Task
# You should create one R script called run_analysis.R that does the following.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# program initialization
#
libs <- c('data.table', 'dplyr', 'plyyr' , 'tidyr')
lapply(libs, require, character.only = T)



# 1.
# Merge the training and the test sets
myurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("data")) 
   dir.create("data")

 download.file(myurl, destfile="./data/Dataset.zip", method="curl")
 unzip("data/Dataset.zip", exdir="./data", overwrite = T)
 
 # Get and merge the 'training' and 'test' data sets
 #
 train_x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
 train_y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
 names(train_y) <- 'activity'
 train_subj <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
 names(train_subj) <- 'subject'
 # NB. number of obs match - 7352 (str(train..))
 # Merge the two datasets
 train_df <-  cbind(train_x, train_subj, train_y)
 train_df <- tbl_df( train_df)                           # convert to dplyr table df - for easier manipulation
 
 test_x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
 test_y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
 names(test_y) <- 'activity'
 test_subj <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
 names(test_subj) <- 'subject'
 test_df <- cbind(test_x, test_subj, test_y)
 
 # merge both train and test data
 # structure of each df is the same, but different number of obs - 7352 v 2947
 data_df <- rbind(train_df, test_df)
 
 
 # 2.
 # Extract only the measurements on the mean and standard deviation for each measurement
 #  figure out the columns we want.
 cols <- read.table("./data/UCI HAR Dataset/features.txt")
 names(cols) <- c('id', 'name')
 mycols <- c(as.vector(cols[, "name"]))
 mycolids <- grepl("mean|std", mycols) & !grepl("meanFreq", mycols)
 my_data_df <- data_df[, mycolids]                         # cut down the set of columns
 my_data_df <- tbl_df(my_data_df)
 
 # 3.
 # Use descriptive activity names to name the activities in the data set
 activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)
 names(activities) <- c("id", "name")
 
 # add the text description of the activity as a new column, from the 'name' column on the 2nd table
 my_data_df <- inner_join(my_data_df, activities, by = c("activity"= "id"))
 # delete the redundant activity column
 my_data_df <- my_data_df[, !names(my_data_df)=="activity"]
 # rename descriptive name column to 'activity'
 my_data_df <- rename(my_data_df, c("name"="activity"))
 
 
 
# 4. Appropriately label the data set with descriptive variable names.
# to replace the dataset V1, V2 etc with appropriate domain equivalents
 
 raw_names <- mycols[mycolids]               # list of coloumn descriptions in scope
                                             # global replace problem name fragments
 raw_names <- gsub("\\(\\)", "", raw_names)
 raw_names <- gsub("Acc", "-acceleration", raw_names)
 raw_names <- gsub("(Jerk|Gyro)", "-\\1", raw_names)
 raw_names <- gsub("Mag", "-Magnitude", raw_names)
 raw_names <- gsub("BodyBody", "Body", raw_names)
 raw_names <- gsub("^t(.*)$", "\\1-time", raw_names)
 raw_names <- gsub("^f(.*)$", "\\1-frequency", raw_names)
 raw_names <- tolower(raw_names)
 names(my_data_df) <- c(raw_names, 'subject', 'activity')
 
 
 # 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
 
 tidy_df <- tbl_df(my_data_df) %>%
   group_by(activity, subject) %>%
   summarise_each(funs(mean)) %>%
   gather(measurement, mean, -activity, -subject)          #this step puts the data into tidy data -long format
 
 # Save the data into the file
 write.csv(tidy_df, file="tidy_df.csv", row.names=F)
 