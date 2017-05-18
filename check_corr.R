attach(paysim_s) #attach sampled data
library(corrplot)
#is.na(isFlaggedFraud)
corr <- cor(paysim_s[,unlist(lapply(paysim_s, is.numeric))])
corrplot(corr,method="number")
corrplot(corr,method="circle")
detach(paysim_s)