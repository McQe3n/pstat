attach(train)

lg_fit = glm(isFraud ~ amount + newbalanceOrig + newbalanceDest, family = binomial)

detach(train)

attach(test)

lg_reg_probTest = predict(lg_fit,test,type = "response")
lg_reg_predTest = rep(0,nrow(test))
lg_reg_predTest[lg_reg_probTest>.05]=1
table(lg_reg_predTest,isFraud)
mean(lg_reg_predTest == isFraud)
sum(lg_reg_predTest)/sum(isFraud)
#summary(lg_fit) # interpret data
detach(test)
