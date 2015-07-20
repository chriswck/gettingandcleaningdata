---
title: "README"
output: html_document
---
##README.md for run_analysis.R
###A line-by-line dissection


```{r, echo = FALSE}
feats <- readLines("UCI Har Dataset/features.txt")
vars_index <- grep("(mean\\(\\)|std\\(\\))", feats)
vars_names <- grep("(mean\\(\\)|std\\(\\))", feats, value = TRUE)
```
This reads "features.txt" and returns:
*An index of columns that corresponds to the mean and std variables
*The names of those columns

```{r, echo = FALSE}
DESCRIPTION <- c("Subjects from 1 to 30", "Six activities: walking, walking up, walking down, sitting, standing, laying", vars_names)
for (i in seq_along(vars_names)) {
  vars_names[i] <- sub("^[0-9]+ [a-zA-z]+", paste0("var",i), vars_names[i])
}
temp <- gsub("-mean\\(\\)", ".m", vars_names)
temp <- gsub("-std\\(\\)", ".s", temp)
vars_names <- gsub("-", ".", temp)
VARIABLE <- vars_names
codebook <- cbind(VARIABLE, DESCRIPTION)
write.table(codebook, file = "codebook.txt", sep=" ", row.names = FALSE)
```
This names the variables into a more compact form, separated with ".", such that:
*Simplified variable label
*Mean or standard deviation variable
  +".m" = mean
  +".s" = standard deviation
*The axis X, Y or Z
After that, a codebook is written

```{r, echo = FALSE}
test_sub <- read.table("UCI Har Dataset/test/subject_test.txt")
colnames(test_sub) <- "subject"
test_y <- read.table("UCI Har Dataset/test/y_test.txt")
activity <- test_y[1:nrow(test_y),]
activity <- gsub(1, "walking", activity)
activity <- gsub(2, "walking up", activity)
activity <- gsub(3, "walking down", activity)
activity <- gsub(4, "sitting", activity)
activity <- gsub(5, "standing", activity)
activity <- gsub(6, "laying", activity)
test_y <- as.data.frame(activity)
```
This reads the subject list and activity list. And then relabelling the activities in numbers to the actual activity name. While there should be more efficient means to relabel the activities, I decided it would take more time than if I just typed it out. I attmpted to use the operator %>% to chain the commands, but it seems to only work when the dataframe is the first argument(?), which in the case of gsub() is the third.

```{r, echo = FALSE}
x <- read.table("UCI Har Dataset/test/X_test.txt", nrows=5)
x_classes <- lapply(x, class)
test_x <- read.table("UCI Har Dataset/test/X_test.txt", colClasses=x_classes)
test_x <- select(test_x, vars_index)
colnames(test_x) <- vars_names
full_test <- cbind(test_sub, test_y, test_x)
```
This reads the actual datapoints from "X_test.txt". As the dataset is massive, only the first 5 rows were read in so that classes of each column can be determined. And then the entire dataset is read by applying those determined column classes to speed up the reading.
And then combining all three dataframes:
*Subject list
*Acitivty list
*Datapoint values

```{r, echo = FALSE}
train_sub <- read.table("UCI Har Dataset/train/subject_train.txt")
colnames(train_sub) <- "subject"
train_y <- read.table("UCI Har Dataset/train/y_train.txt")
activity <- train_y[1:nrow(train_y),]
activity <- gsub(1, "walking", activity)
activity <- gsub(2, "walking up", activity)
activity <- gsub(3, "walking down", activity)
activity <- gsub(4, "sitting", activity)
activity <- gsub(5, "standing", activity)
activity <- gsub(6, "laying", activity)
train_y <- as.data.frame(activity)
x <- read.table("UCI Har Dataset/train/X_train.txt", nrows=5)
x_classes <- lapply(x, class)
train_x <- read.table("UCI Har Dataset/train/X_train.txt", colClasses=x_classes)
library(dplyr)
train_x <- select(train_x, vars_index)
colnames(train_x) <- vars_names
full_train <- cbind(train_sub, train_y, train_x)
```
The same thing is done for the training dataset.

```{r, echo = FALSE}
full <- rbind(full_train, full_test)
final <- aggregate(. ~ subject + activity, full, mean)
write.table(final, file = "final_summarized_output.txt", sep =" ", row.names = FALSE)
```
This puts together the training and testing dataset, and then the mean values are found by each subject and each activity using aggregate(). Output is then written as .txt file.

```{r}
final[1:12:,1:5]
```
Selected output for your reference