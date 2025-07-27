h2o_train <- function(data, 
                      max_models       = 80, 
                      max_runtime_secs = 2880, 
                      rashomon_perc    = 0.05) {
  h2o.init()
  if(class(data$Class) != "factor"){
    data$Class          <- as.factor(data$Class)
  }
  data_h2o            <- as.h2o(data)
  
  x                   <- setdiff(names(data), "Class")
  y                   <- "Class"
  
  splits              <- h2o.splitFrame(data = data_h2o, ratios = 0.8, seed = 1234)
  train               <- splits[[1]]
  test                <- splits[[2]]
  
  aml_model <- h2o.automl(
    x                 = x, 
    y                 = y,
    training_frame    = train,
    leaderboard_frame = test,
    max_models        = max_models,
    max_runtime_secs  = max_runtime_secs,
    seed              = 1234
  )
  
  model_ids  <- as.vector(aml_model@leaderboard$model_id)
  model_aucs <- data.frame(model = character(), auc = numeric())
  
  for (model_id in model_ids) {
    model <- h2o.getModel(model_id)
    perf  <- h2o.performance(model, newdata = test)
    auc   <- h2o.auc(perf)[[1]]
    model_aucs <- rbind(model_aucs, data.frame(model = model_id, auc = auc))
  }
  
  max_auc    <- max(model_aucs$auc)
  threshold  <- max_auc - (max_auc * rashomon_perc)
  top_models <- dplyr::filter(model_aucs, auc >= threshold)
  
  pred_list      <- list()
  expected_nrow  <- nrow(test)
  
  for (model_id in top_models$model) {
    model <- h2o.getModel(model_id)
    preds <- as.data.frame(h2o.predict(model, test)[, "p1"])
    
    if (nrow(preds) == expected_nrow) {
      colnames(preds) <- model_id
      pred_list[[model_id]] <- preds
    } else {
      warning(paste("Model", model_id, "Prediction length mismatch, skipped."))
    }
  }
  
  predictions_df <- do.call(cbind, pred_list)
  
  return(predictions_df)
}