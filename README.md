---
title: "README"
output: html_document
---



This repository coontains the assignment for 'Getting and Cleaning Data'.

It consists of an R script for performing work on the UCI HAR Dataset (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The script, "run_analysis.R"",  downloads the data to a local directory, and processes it as follows:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

To run the code, use 'source' as follows:

```{r}
source("run_analysis.R")
```

The tidied data set, in CSV format, is written to a file called 

```{r}
tidy_df.csv
```

There is also a Codebook in this repository which describes the variables in the data set and the transform carried out.