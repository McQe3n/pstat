library(caret) 
library(dplyr)
library(rattle) 
library(rpart) 

train$isFraud <- as.factor(train$isFraud)
test$isFraud <- as.factor(test$isFraud)

decisionTreeModel <- train(isFraud~.,method="rpart",data=train) 

fancyRpartPlot(decisionTreeModel$finalModel)  

test$pred <- predict(decisionTreeModel,test)  
test = test %>% mutate(accurate = 1*(isFraud == pred))
table(test$pred,test$isFraud) 
sum(test$accurate)/nrow(test) 
