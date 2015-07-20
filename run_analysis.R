feats <- readLines("UCI Har Dataset/features.txt")
vars_index <- grep("(mean\\(\\)|std\\(\\))", feats)
vars_names <- grep("(mean\\(\\)|std\\(\\))", feats, value = TRUE)

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
x <- read.table("UCI Har Dataset/test/X_test.txt", nrows=5)
x_classes <- lapply(x, class)
test_x <- read.table("UCI Har Dataset/test/X_test.txt", colClasses=x_classes)
test_x <- select(test_x, vars_index)
colnames(test_x) <- vars_names
full_test <- cbind(test_sub, test_y, test_x)

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


full <- rbind(full_train, full_test)
final <- aggregate(. ~ subject + activity, full, mean)
write.table(final, file = "final_summarized_output.txt", sep =" ", row.names = FALSE)