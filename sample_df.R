s_size = 100000
s_rows = 1:s_size

set.seed(1)

paysim_s <- paysim_ds[sample(s_rows,s_size),]
paysim_s$isFlaggedFraud=NULL
#paysim_s
#summary(paysim_s)
