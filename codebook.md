---
title: "codebook.md"
output: html_document
---

This codebook describes the output and transformations performed by the analysis cript, "run_analysis.R".

The output of the script can be accessed by reading the CSV file:

```{r}
data <- read.csv("tidy_df.csv")
```


The script combines, aggregates and tidies raw telemetry data from a number of separate files, containing data from smart phone sensors.

The script outputs a csv file containing a reduced set of data containing means and standsrd deviations for each of the variables.  These are further grouped by activity and subject to give summary statistics.

Once data is gathered and merged in from the various files, the data is changed as follows:

```{r}
 raw_names <- gsub("\\(\\)", "", raw_names)
 raw_names <- gsub("Acc", "-acceleration", raw_names)
 raw_names <- gsub("(Jerk|Gyro)", "-\\1", raw_names)
 raw_names <- gsub("Mag", "-Magnitude", raw_names)
 raw_names <- gsub("BodyBody", "Body", raw_names)
 raw_names <- gsub("^t(.*)$", "\\1-time", raw_names)
 raw_names <- gsub("^f(.*)$", "\\1-frequency", raw_names)
 raw_names <- tolower(raw_names)
```

The list of variables is as follows:

```{r}
body-acceleration-mean-x-time                   body-acceleration-mean-y-time                   body-acceleration-mean-z-time                  
body-acceleration-std-x-time                    body-acceleration-std-y-time                    body-acceleration-std-z-time                   
gravity-acceleration-mean-x-time                gravity-acceleration-mean-y-time                gravity-acceleration-mean-z-time               
gravity-acceleration-std-x-time                 gravity-acceleration-std-y-time                 gravity-acceleration-std-z-time                
body-acceleration-jerk-mean-x-time              body-acceleration-jerk-mean-y-time              body-acceleration-jerk-mean-z-time             
body-acceleration-jerk-std-x-time               body-acceleration-jerk-std-y-time               body-acceleration-jerk-std-z-time              
body-gyro-mean-x-time                           body-gyro-mean-y-time                           body-gyro-mean-z-time                          
body-gyro-std-x-time                            body-gyro-std-y-time                            body-gyro-std-z-time                           
body-gyro-jerk-mean-x-time                      body-gyro-jerk-mean-y-time                      body-gyro-jerk-mean-z-time                     
body-gyro-jerk-std-x-time                       body-gyro-jerk-std-y-time                       body-gyro-jerk-std-z-time                      
body-acceleration-magnitude-mean-time           body-acceleration-magnitude-std-time            gravity-acceleration-magnitude-mean-time       
gravity-acceleration-magnitude-std-time         body-acceleration-jerk-magnitude-mean-time      body-acceleration-jerk-magnitude-std-time      
body-gyro-magnitude-mean-time                   body-gyro-magnitude-std-time                    body-gyro-jerk-magnitude-mean-time             
body-gyro-jerk-magnitude-std-time               body-acceleration-mean-x-frequency              body-acceleration-mean-y-frequency             
body-acceleration-mean-z-frequency              body-acceleration-std-x-frequency               body-acceleration-std-y-frequency              
body-acceleration-std-z-frequency               body-acceleration-jerk-mean-x-frequency         body-acceleration-jerk-mean-y-frequency        
body-acceleration-jerk-mean-z-frequency         body-acceleration-jerk-std-x-frequency          body-acceleration-jerk-std-y-frequency         
body-acceleration-jerk-std-z-frequency          body-gyro-mean-x-frequency                      body-gyro-mean-y-frequency                     
body-gyro-mean-z-frequency                      body-gyro-std-x-frequency                       body-gyro-std-y-frequency                      
body-gyro-std-z-frequency                       body-acceleration-magnitude-mean-frequency      body-acceleration-magnitude-std-frequency      
body-acceleration-jerk-magnitude-mean-frequency body-acceleration-jerk-magnitude-std-frequency  body-gyro-magnitude-mean-frequency             
body-gyro-magnitude-std-frequency               body-gyro-jerk-magnitude-mean-frequency         body-gyro-jerk-magnitude-std-frequency         
body-acceleration-jerk-magnitude-mean-frequency body-acceleration-jerk-magnitude-mean-time ... gravity-acceleration-std-z-time
```

The means of the summarized variable measurements (above) are computed, and finally the script puts the data into long format by doing a pivot operation using dplyr::gather; then saved to the CSV file.