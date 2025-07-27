data <- bank_marketing
bank_automl <- h2o_train(data)

matching_rows <- match(
  do.call("paste", data),
  do.call("paste", as.data.frame(bank_automl$test))
)

matching_rows <- na.omit(matching_rows)
ld <- local_density(data)
ld_test <- ld[matching_rows,]

diff <- apply(bank_automl$preds, 1, function(x) max(x) - min(x))

library(ggplot2)
ggplot(data = data.frame(lof = ld_test$local_density,
                         dif = diff),
         aes(x = log(lof), 
             y = dif)) + 
  geom_point() + 
  theme_bw()
