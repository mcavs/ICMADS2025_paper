calculate_metrics <- function(pred){
  f_R_labels   <- ifelse(pred[[1]] > 0.5, 1, 0)
  
  other_labels <- predictions_df[, -1, drop = FALSE] |> 
    apply(2, function(col) ifelse(col > 0.5, 1, 0))
  
  n_models     <- ncol(other_labels)
  n_obs        <- nrow(other_labels)
  
  disagree_mat <- sweep(other_labels, 1, f_R_labels, FUN = "!=")
  discrepancy  <- max(colSums(disagree_mat) / n_obs)
  obscurity    <- mean(rowSums(disagree_mat) / n_models)  
  
  return(list(discrepancy = discrepancy, obscurity = obscurity))
}
