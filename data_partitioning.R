drows = nrow(paysim_s)  #get number of rows

smple_size = floor(0.7 * (drows - 2))

# set the seed to make partition reproductible
set.seed(1) #return the same random value

train.ind = sample(seq_len(drows),size = smple_size) #seq_len generates sequence
paysim_s$nameOrig = NULL
paysim_s$nameDest = NULL
train = paysim_s[train.ind,]
test = paysim_s[-train.ind,]