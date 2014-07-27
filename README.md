CleaningData-project1
=====================
***********************************************************************************************

Getting and Cleaning Data - Project 1

Version 1.0

***********************************************************************************************

Tom Huffman
Tampa, FL

***********************************************************************************************
The Project 1 is designed to familaize the student with the process of getting and cleaning unstructured
data. The files used were of a previous experiment perfomed by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, and Luca Oneto SmartLab in Italy. They measured the actyivities of 30 subjects performing different activities. Project 1 uses the files produced from this experiment to cleanse and reshape.

"average.txt"" - output of tidy data

"CodeBookproject1.md"" - project1 code book
***********************************************************************************************

The program used to perform the cleansing is run_analysis.R. It assumes all files are located in same folder as the program.
The program first reads the features.txt file and then read all the associated test and train files into the program. 
Next the program reads the activity file and relabels the columns to id, and activiy.

The directions for the project states that it only wants the measurements of Mean and Standard of Deviation. The features file contains information for which columns represent this data so I created an index of those locations.

The subject, X, and y files were not combined immediately. The index was used on the X file to filter only the mean() and std() measures. Then the subject and y data were bound to the filtered X data.
This process was done for both test and train samples.

Once the combined dataframe was created, an rbind was used to combined the test and train data into a single dataframe. 
The names of the dataframe were renamed to "subject" and "activity" along with assigning the names from the feature file. Assigning the names from the feature file will make it easier to relabel the columns with more meanigful names later.

A merge of the combined test/train  and the activity file created a dataset that contain the data that associates activity for the subject with measurement. 

Relabeled the measurement columns to meaninigful names. The structure is as follows:
        The value "t" will transform to "Time"
        The value "f" will transform to "Frequency"
        The value "Gyro" will transform to "Gyroscope"
        The value "Acc" will transform to "Accelerometer"
        The value "Mag" will transform to "Magnitude"
        The value BodyBody" will transofrm to "Body"
        The value "std" will transform to "StandardOfDeviation"
        The value "mean" will transform to "Mean"
        The value "()" will be removed
        The value "-" will be removed

Used ddply function to tidy the data by consolidating the subjects a single activity. For example, instead of having multiple entries for a subject for an activity like WALKING, there is a sum for LAYING,SITTING,STANDING,WALKING,WALKING_DOWNSTAIRS, and WALKING_UPSTAIRS. 

write.table was used to create the avareage.txt file. Use read.table to read the information back into R.
