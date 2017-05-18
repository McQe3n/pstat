attach(train)

glm.fit = glm(isFraud ~ amount + newbalanceOrig + newbalanceDest, family = binomial)

detach(train)

attach(test)

glm.reg_probTest = predict(glm.fit,test,type = "response")
glm.reg_predTest = rep(0,nrow(test))
glm.reg_predTest[glm.reg_probTest>.05]=1
table(glm.reg_predTest,isFraud)
mean(glm.reg_predTest == isFraud)
sum(glm.reg_predTest)/sum(isFraud)
#summary(glm.fit) # interpret data
detach(test)