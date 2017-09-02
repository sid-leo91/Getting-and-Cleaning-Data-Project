# Getting-and-Cleaning-Data-Project

This is the course project for the Getting and Cleaning Data Coursera course. The R script, run_analysis.R, does the following:

1. Download the dataset from the directory
2. Loads the activity, feature and subject info from the text files
3. Finds the indexes and features names of the mean and std features only
4. Merges the two datasets
5. Extracts the mean and std features from the list of features and arranges them in separate rows
6. Converts the activity from number to its desciptive name
7. Cleans the column names and gives appropriate column names for every variable
8. Creates a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.

The end result is shown in the file tidy_data.txt.
