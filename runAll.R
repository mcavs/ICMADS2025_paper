setwd("/Users/mustafacavus/Desktop/ICMADS'25")

source("import_datasets.R")
source("h2o_train.R")
source("calculate_metrics.R")

setwd("/Users/mustafacavus/Desktop/ICMADS'25/pred_rds")

AER     <- h2o_train(data = AER_credit_card_data)
saveRDS(AER, "AER.rds")

bank    <- h2o_train(data = bank_marketing)
saveRDS(bank, "bank.rds")

german  <- h2o_train(data = german_credit)
saveRDS(german, "german.rds")

give    <- h2o_train(data = give_me)
saveRDS(give, "give.rds")

hmeq    <- h2o_train(data = hmeq)
saveRDS(hmeq, "hmeq.rds")

loan    <- h2o_train(data = loan_data)
saveRDS(loan, "loan.rds")

poland3 <- h2o_train(data = poland_year3)
saveRDS(poland3, "poland3.rds")

poland5 <- h2o_train(data = poland_year5)
saveRDS(poland5, "poland5.rds")

taiwan  <- h2o_train(data = taiwan_credit)
saveRDS(taiwan, "taiwan.rds")