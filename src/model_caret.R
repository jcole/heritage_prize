rm(list=ls())
source('src/evaluation.R')

library(doMC)
registerDoMC()
getDoParWorkers()
require(foreach) #parallel library

require(caret)

members <- read.csv('working_data/member_features.csv', header=TRUE)
members$member_id = NULL

members$actual_days_y2_is_0 = as.factor(members$actual_days_y2 == 0)
members$actual_days_y2 = NULL #remove so its not used to predict. should just exclude in formula

# subset for training
set.seed(1) # this will guarantee the same subsets every time

classColumnName = 'actual_days_y2_is_0'
classColIndex = which(names(members) == classColumnName)
classColumn = members[, classColIndex]

#TODO - force things to numeric?

for (currCol in 1:ncol(members))
{
  if (classColIndex != currCol) {
    #perhaps be more graceful here, ints vs floats etc
    members[[currCol]] = as.numeric(members[[currCol]])
  }
}


#IMPORTANT- stratify the test/training sets on answers for actual days
trainingIndexes = createDataPartition(classColumn, p = 0.10, list=FALSE)
train = members[trainingIndexes,]
trainClass = classColumn[trainingIndexes]
test = members[-trainingIndexes,]
testClass = classColumn[-trainingIndexes]

# Do the training
tuneGrid = createGrid('knn', len=2, train) #shortcut the mtry search space for now
#there is a formula interface too
trControl = trainControl(workers=2)
model = train( actual_days_y2_is_0 ~ . , data = train, method = "knn",tuneGrid=tuneGrid, trControl=trControl)
    
# look at prediction on training set
train$predicted_days <- predict(model, train)
total_error(train$predicted_days, train[[classColumnName]])

# look at predictions on test set
test$predicted_days <- predict(model, test)
total_error(test$predicted_days, test$actual_days_y2)

#testX needs to have the predicted value excluded because that's already happened internal to the model for the training set
# and the dims should match
#NOTE this code seems to work best for continuous variables.
#predVals = extractPrediction(list(model), testX = test[,-classColIndex], testY=testClass)
#plotObsVsPred(predVals)

confusionMatrix(predict(model,test), test[[classColumnName]])