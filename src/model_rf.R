require(randomForest)

rm(list=ls())
source('src/evaluation.R')

members <- read.csv('working_data/member_features.csv', header=TRUE)

init_time <- Sys.time() # for timing this run

# subset for training
numTraining <- 1000
training <- members[1:numTraining,][-1] #don't include member id: add [-1]
test <- members[(numTraining+1):nrow(members),]

# run random frest
mtry <- 1
ntree <- 250
print(paste(numTraining, 'training; ', mtry, 'mtry;', ntree, 'ntree'))
forumula <- actual_days_y2 ~ .
model.rf <- randomForest(forumula, data = training, mtry = mtry, ntree = ntree, importance = TRUE, proximity = TRUE)

# investigate RF results:
#  model.rf
#  plot(model.rf, lty = 1)
#  varImpPlot(model.rf)
#  MDSplot(model.rf, training$actual_days_y2)
#  plot(margin(model.rf, training$actual_days_y2))
#  abline(h = 0)

print(Sys.time() - init_time) #show elapsed time

test$predicted_days <- predict(model.rf, test)
# poor-man's classifier: threshold for predicting non-zero value
test[test$predicted_days < 1,]$predicted_days <- 0 

print(total_error(test$predicted_days, test$actual_days_y2))
