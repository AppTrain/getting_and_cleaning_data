
library("data.table")
library("reshape2")

# setwd("UCI HAR Dataset")

load_readings <- function(dir) {
  # features.txt stores the column names for the data in x_text.txt
  # So read column names into a vector
  column_names = as.vector(read.csv('features.txt',F,sep="")[,2])
  # Then use that vector to create a data.frame
  phone_readings = read.csv(paste(dir,"/X_",dir,".txt",sep=""), F, sep="", col.names=column_names)
  # STEP 4: Label Data Set 
  # The col.names option above alters column names slightly
  # this next step clears that up, and gives the variables readable and descriptive 
  # names.
  colnames(phone_readings) <- gsub("_$","",gsub("[^1-z]+","_",column_names))
  # Now read the id numbers for activities and subjects
  activity = read.csv(paste(dir,"/y_",dir,".txt",sep=""), F, sep="")[,1]
  subject_id = read.csv(paste(dir,"/subject_",dir,".txt",sep=""), F, sep="")[,1]
  #and slap those vectors right onto the phone_readings data.frame
  phone_readings = cbind(phone_readings,cbind(activity,subject_id))
}

capitalize <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}


# Step 1: Merge test and training sets
full_phone_readings = rbind(load_readings('test'),load_readings('train'))

# Step 2: Extract only mean and std of each measurement
# NOTE meanFreq is a weigted avereage and not included here, 
# angles computed from vecotors containing means are not included either.
# Grab colum names from the full data.frame
column_names = colnames(full_phone_readings)
#now grab the ones with 'mean()'or 'std()', also need activity and subject
cols = grep("\\_mean(\\_|$)|\\_std(\\_|$)|activity|subject",column_names,value=T)

phone_activity_stats = full_phone_readings[,cols]

#Step 3: Use Descriptive Activity Names
# First change the activity column to a factor
phone_activity_stats$activity <- as.factor(phone_activity_stats$activity)
# Then apply the descriptive names from the text file to the new factor column.
# Longest command in this file here, but might as well tidy up the names here 
levels(phone_activity_stats$activity) = sapply(as.vector(tolower(
        gsub("_"," ",read.csv("activity_labels.txt",sep="",F)[,2]))),capitalize)

# STEP 4: Label Data Set 
# This step is handled in the load_readings method.  So now
# the variable names have no R control chars such as '-' or '()'
# So this line of code will now work:
# phone_activity_stats$fBodyGyro_std_Z
# While this one would not have worked:
# phone_activity_stats$fBodyGyro-std()-Z
# Some may prefer to go with all camelCase or all underscore,
# but I prefer to leave the reading names on camel case, and use the 
# underscores to indicate methods called on those readings.
# Anyway the phone_activity_stats data.frame 
print(head(phone_activity_stats))

# Code below was for an alternate solution not grouping the data

# if (F)
# {  
#   activities = melt(phone_activity_stats,id=c("activity","subject_id"))  
# act = dcast(activities,activity ~ variable,mean)
# subject = dcast(activities,subject_id ~ variable,mean)
# acts = t(act)
# subs = t(subject)
# # The getting there data.frame is the solution to listing averages separately for each 
# # activity and subject.One possible way to interpret the assignment.  Unless thos turns out to be
# # the recomended way, I'll leave this dataset alone for now.
# getting_there = cbind(acts,subs)
# }



# # Have the answer, Literally tidying up now
# if (F) {
# colnames(getting_there) = getting_there[1,]
# getting_there = getting_there[-1,]
# getting_there = cbind(row.names(getting_there),getting_there)
# row.names(getting_there) <- NULL 
# colnames(getting_there)[1] = "Smartphone Measurement"
# # decided to leave underscores for easier access to the table variables from R
# #colnames(getting_there) = gsub("_"," ",colnames(getting_there))
# colnames(getting_there) = tolower(colnames(getting_there))
# colnames(getting_there) = sapply(colnames(getting_there),capitalize)
# colnames(getting_there) = gsub("(\\d+)","Subject_\\1",colnames(getting_there))
# 
# write.table(getting_there,"answer.txt",row.name=FALSE)
# }


# The other interpretation is to assume the instructors wanted 'group by' functionality 
# of the subjects and activites.

#STEP 5:  Create an independent tidy data set 
# with the average of each variable for each activity and each subject.
activity_table = data.table(phone_activity_stats)[order(subject_id,activity)]
# data.table works nicely for running group_by querries, lapply of mean over the subset (.SD)
# gets the answer quickly.
mean_by_activity_and_subject = activity_table[,lapply(.SD,mean),by = c('subject_id','activity')]

write.table(mean_by_activity_and_subject,"grouped_answer.txt",row.names=FALSE)
