library(caret) 
library(dplyr)
library(rattle) 
library(rpart) 

train$isFraud <- as.factor(train$isFraud)
test$isFraud <- as.factor(test$isFraud)

decisionTreeModel <- train(isFraud~.,method="rpart",data=train) # model with all variables on the training subset

fancyRpartPlot(decisionTreeModel$finalModel) # fancy plot

test$pred <- predict(decisionTreeModel,test) # get predictions
test = test %>% mutate(accurate = 1*(isFraud == pred))
table(test$pred,test$isFraud) # confusion matrix
sum(test$accurate)/nrow(test) # accuracy %