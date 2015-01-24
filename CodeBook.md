# getting_and_cleaning_data
# Coursera Course:  Getting and Cleaning Data Code Book

## Assignment

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

### Smartphone Accelerometer and Gyroscope Data
The data linked to below represents data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here is the data for the project: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Variables

### From the downloaded README
The acceleration signal was separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ). Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. The angular velocity vector measured by the gyroscope are radians/second. The data was already normalized and bounded within [-1,1]

Where are set of variables that were estimated from these signals: 

 * mean(): Mean value
 * std(): Standard deviation
 * mad(): Median absolute deviation 
 * max(): Largest value in array
 * min(): Smallest value in array
 * and more

So for example variable `tBodyAcc-mean()-Z` is "normalized mean body acceleration on Z axis in certain time window"



## Data

The downloaded and unzip files consist of:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

The Download also contains an Inertial Signals directory whose contents can be ignored for this assignment.



## Transformation


#### Loading
The run_analysis.R script contiains a load_readings function that takes a directory name.  That function
1) loads the 'X' file containing the main data set.
2) Adds column names to the data set from the features.txt file
3) Replaces '()-' charachters in the column names with underscores to support R programming calls.
4) Adds subject_ids to the data set from the 'subject' file.
5) Adds activites to the data set from the 'Y' file. 

#### Merging
After loading, The test and train data sets are merged into an R data.frame .

    full_phone_readings = rbind(load_readings('test'),load_readings('train'))
    
#### Filter
The assignment is only interested in mean() and std() columns
NOTE: meanFreq is a weigted avereage and not included here, 
angles computed from vecotors containing means are not included either.

    cols = grep("\\_mean(\\_|$)|\\_std(\\_|$)|activity|subject",column_names,value=T)
    phone_activity_stats = full_phone_readings[,cols]
  
### Descriptive Names
Activitiy labels from the activity_labels.txt file are added to the activity colum using a R factor.

## Independent Tidy Data Set

The data.frame is converted to an R data.table to take advantage of grouping functionality.

    mean_by_activity_and_subject = activity_table[,lapply(.SD,mean),by = c('subject_id','activity')]
    
This results in 180 rows (30 subjects x 6 Activites) and 68 columns (66 variables + subject + activity.) , with each row containing the mean over each subject and activity combination for each of the 66 variables. 


##License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
