run_analysis<-function(){
        
        library(plyr)
        ## features.txt contains the methods used to generate the output for the variable (column).
        
        features<-read.table("features.txt")
        ## Read the subject, x/y test and train data 
        
        ## Test data
        subject_test<-read.table("subject_test.txt", header=F)
        x_test_set<-read.table("X_test.txt")
        y_test_set<-read.table("y_test.txt")
        
        ##Train data
        subject_train<-read.table("subject_train.txt")
        x_train_set<-read.table("X_train.txt")
        y_train_set<-read.table("y_train.txt")
        
        ## Read Activity data and set the column names 
        activity<-read.table("activity_labels.txt")
        names(activity)<-c("id", "activity")
        
        ## Create an index that points to the location of the std() and mean() features within the data.
        ## Only return the location where the match is in the form of "mean()" and "std()".
        idx <- grep("mean\\(\\)|std\\(\\)", features$V2)
        
        ## Return all the columns containing std() and mean() from the x_test data
        ## Using the index, return the columns that contains a match. I choose to first isolate these before 
        ## binding with the subject and y (activity) data.
        
        x_test_filtered<-x_test_set[,idx]

        ## Next bind the columns for the y_test data with the filtered x_test data.
        
        x_y_test<-cbind(y_test_set,x_test_filtered)
        
        ## Finally, bind the columns of the subject data with the x/y test data.  This creates a wider dataframe.
        ## The data.frame now contains subject, y_test (activity data), and x_test (std and means).
       
        testraw<-cbind(subject_test,x_y_test)
        
        ## Perform the same steps on the training data.
        x_train_filtered<-x_train_set[,idx]
        
        x_y_train<-cbind(y_train_set, x_train_filtered)
        
        trainraw<-cbind(subject_train,x_y_train)
  
        ## Now that I have the results for both test and train data, 
        ## use row bind to bind the results together to make a single data frame
        ## This creates a longer dataframe
        dataraw<-rbind(testraw,trainraw)
        
        ## Next, assign the names 'subject' and 'activity_id' as well as the features names to the dataframe. 
        ## Using the existing feature names for the columns will make it easier to change to desciptive names when renaming
        
        names(dataraw)<-c("subject","activity_id",as.character(features$V2[idx]))
        
        ##Now replace the activity_id with the activity labels which describes what action the subject was performing
        
        mergedata<-merge(activity,dataraw, by.x="id", by.y="activity_id", all=T )
        
        ## Rename the columns using the descriptions from featrures_info.txt
        ## The value "t" will transform to "Time"
        ## The value "f" will transform to "Frequency"
        ## The value "Gyro" will transform to "Gyroscope"
        ## The value "Acc" will transform to "Accelerometer"
        ## The value "Mag" will transform to "Magnitude"
        ## The value BodyBody" will transofrm to "Body"
        ## The value "std" will transform to "StandardOfDeviation"
        ## The value "mean" will transform to "Mean"
        ## The value "()" will be removed
        ## The value "-" will be removed
        
        names(mergedata) <- gsub("^t","Time",names(mergedata))
        names(mergedata) <- gsub("^f","Frequency",names(mergedata))
        names(mergedata) <- gsub("Gyro","Gyroscope",names(mergedata))
        names(mergedata) <- gsub("Acc","Accelerometer",names(mergedata))
        names(mergedata) <- gsub("Mag","Magnitude",names(mergedata))
        names(mergedata) <- gsub("BodyBody","Body",names(mergedata))
        names(mergedata) <- gsub("std","StandardOfDeviation",names(mergedata))
        names(mergedata) <- gsub("mean","Mean",names(mergedata))
        names(mergedata) <- gsub("\\(\\)","",names(mergedata))
        names(mergedata) <- gsub("-","",names(mergedata))
        
        ## Make the X,Y,and Z stand out 
        
        names(mergedata) <- gsub("X$","_X",names(mergedata))
        names(mergedata) <- gsub("Y$","_Y",names(mergedata))
        names(mergedata) <- gsub("Z$","_Z",names(mergedata))
        
        ## Don't need the column 'id' of the activity any longer.
        ## Set to NULL instead of creating a subset. This will save memory space.
        
        mergedata$id <- NULL
        
        ## Last, create a tidy dataset and write to disk. After looking at the data in the exercise
        ## summing was the only way I came up with tidying the data. This creates a dataframe where for 
        ## each subject sums the measurement of the activity. I did not see a way to narrow the columns.
        ## Byut combining the subjects for each activity did shorten the data.
        
        mergegroup<-ddply(mergedata,.(activity,subject), numcolwise(mean,na.rm=T))
        
        ## Write the dataframe. 
        write.table(mergegroup, "averages.txt", sep = "," , row.names = FALSE, quote = FALSE)
}