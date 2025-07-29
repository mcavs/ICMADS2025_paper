library(ggplot2)
library(dplyr)

max_deviation_plot <- function(data, data_name, delta = 0.20){
  # data: A DataFrame containing predictions from all models.
  # delta: The deviation threshold (default is 0.20 or 20%).
  
  # Extract baseline model predictions
  baseline_predictions <- data[,1]
  
  # Exclude the baseline column to get competitor predictions
  competitor_predictions <- data[,-1]
  
  # Calculate the maximum deviation from the baseline for each observation
  max_deviation_values <- numeric(nrow(data))
  for (i in 1:nrow(data)) {
    if(dim(data)[2] == 2){
      max_deviation_values[i] <- max(abs(competitor_predictions[i] - baseline_predictions[i]))
    } else {
      max_deviation_values[i] <- max(abs(as.numeric(competitor_predictions[i, ]) - baseline_predictions[i]))
    }
  }
  
  # Create a data frame for plotting
  df_plot <- data.frame(
    Max_Deviation = max_deviation_values
  )
  
  # Sort the data frame by Max_Deviation
  df_plot_sorted <- df_plot |>
    arrange(Max_Deviation) |>
    # Create a normalized ID for the X-axis (from 0 to 1)
    mutate(Normalized_ID = (1:n() - 1) / (n() - 1))
  
  # Identify ambiguous examples and calculate the percentage
  ambiguous_examples <- df_plot_sorted |>
    filter(Max_Deviation >= delta)
  
  ambiguity_percentage <- (nrow(ambiguous_examples) / nrow(df_plot_sorted)) * 100
  
  # Find the starting percentile rank for the ambiguous region
  threshold_percentile_start <- if (nrow(ambiguous_examples) > 0) {
    min(ambiguous_examples$Normalized_ID)
  } else {
    1
  }
  
  df_plot_sorted <- cbind(df_plot_sorted, name = rep(data_name, dim(df_plot_sorted)[1]))
  
  # Plot the right-side graph
  plot <- ggplot(df_plot_sorted, aes(x = Normalized_ID, y = Max_Deviation)) +
    geom_col(fill = "#595959", color = NA, width = 1 / nrow(df_plot_sorted)) + # Column plot for max deviation
    geom_hline(yintercept = delta, color = "#ffc001", linetype = "solid", size = 0.8) + # Delta threshold line
    
    # Shade the ambiguous region
    geom_rect(aes(xmin = threshold_percentile_start, xmax = 1, ymin = 0, ymax = 1),
              fill = "#f5e0a3", alpha = 0.006) +
    
    labs(
      x = "Percentile Rank of Observations",
      y = expression(max(abs(g(x[i]) - g[0](x[i])))) # Using LaTeX for the formula
    ) +
    theme_bw(base_size = 16) +
    # Set y-axis breaks and labels as percentages
    scale_y_continuous(
      breaks = c(0.25, 0.50, 0.75, 1.00),
      labels = c("0.25", "0.50", "0.75", "1"),
      limits = c(0, 1), 
      expand = expansion(mult = c(0, 0))
    ) +
    # Set x-axis breaks and labels as percentages
    scale_x_continuous(
      breaks = c(0.25, 0.50, 0.75, 1.00),
      labels = c("25%", "50%", "75%", "100%"),
      limits = c(0, 1), 
      expand = expansion(mult = c(0, 0))
    ) +
    # Add annotation for the ambiguous region (A_delta,epsilon)
    annotate("text", x = 0.99, y = 0.99,
             label = bquote(A[delta*","*epsilon](g[0],S) == .(paste0(round(ambiguity_percentage, 1), "%"))),
             hjust = 1, vjust = 1, size = 5, color = "black") +
    # Yeni eklenen kısım: Delta değerini yatay sarı çizginin yanına yazdır
    annotate("text", x = 0.01, y = delta, # X ekseninin en sağına yakın, Y ekseninde delta değeri
             label = bquote(delta == .(paste0(sprintf("%.2f", delta)))),
             hjust = 0, vjust = -0.5, # Sağa hizala, hafif yukarı kaydır
             color = "black", size = 5) +
    facet_grid(~ name)
  
  return(plot)
}

plot_aer  <- max_deviation_plot(data = AER, data_name = "CreditCard", delta = 0.20)
  plot_aer  <- plot_aer + labs(x = NULL)  +
    theme(
      axis.text.x  = element_blank(),   
      axis.ticks.x = element_blank(),
      axis.text.y  = element_text(size = 14)
    )
  
plot_bank <- max_deviation_plot(bank, data_name = "Bank_marketing", delta = 0.20)
  plot_bank <- plot_bank + labs(x = NULL, y = NULL) +
    theme(
      axis.text.x  = element_blank(),   
      axis.ticks.x = element_blank(),
      axis.text.y  = element_blank(),   
      axis.ticks.y = element_blank()
    )
  
plot_germ <- max_deviation_plot(german, data_name = "German_credit", delta = 0.20)
  plot_germ <- plot_germ + labs(x = NULL, y = NULL) +
    theme(
      axis.text.x  = element_blank(),   
      axis.ticks.x = element_blank(),
      axis.text.y  = element_blank(),   
      axis.ticks.y = element_blank()
    ) 
  
plot_give <- max_deviation_plot(give, data_name = "Give_me_credit", delta = 0.20)
  plot_give <- plot_give + labs(x = NULL)  +
    theme(
      axis.text.x  = element_blank(),   
      axis.ticks.x = element_blank(),
      axis.text.y  = element_text(size = 14)
    ) 
  
plot_hmeq <- max_deviation_plot(hmeq, data_name = "HMEQ", delta = 0.20)
  plot_hmeq <- plot_hmeq + labs(x = NULL, y = NULL) +
    theme(
      axis.text.x  = element_blank(),   
      axis.ticks.x = element_blank(),
      axis.text.y  = element_blank(),   
      axis.ticks.y = element_blank()
    ) 
  
plot_loan <- max_deviation_plot(loan, data_name = "Loan_data", delta = 0.20)
  plot_loan <- plot_loan + labs(x = NULL, y = NULL) +
    theme(
      axis.text.x  = element_blank(),   
      axis.ticks.x = element_blank(),
      axis.text.y  = element_blank(),   
      axis.ticks.y = element_blank()
    ) 
  
plot_pol3 <- max_deviation_plot(poland3, data_name = "Poland_year3", delta = 0.20)
  plot_pol3  <- plot_pol3 +
    theme(
      axis.text.x  = element_text(size = 14),   
      axis.text.y  = element_text(size = 14)   
    ) 
  
plot_pol5 <- max_deviation_plot(poland5, data_name = "Poland_year5", delta = 0.20)
  plot_pol5 <- plot_pol5 + labs(y = NULL) +
    theme(
      axis.text.y  = element_blank(),   
      axis.ticks.y = element_blank(),
      axis.text.x  = element_text(size = 14)
    )
  
plot_taiw <- max_deviation_plot(taiwan, data_name = "Taiwan_credit", delta = 0.20)
  plot_taiw <- plot_taiw + labs(y = NULL) +
    theme(
      axis.text.y  = element_blank(),   
      axis.ticks.y = element_blank(),
      axis.text.x  = element_text(size = 14)
    )
  
library(patchwork)

(plot_aer | plot_bank | plot_germ) /
  (plot_give | plot_hmeq | plot_loan) / 
    (plot_pol3 | plot_pol5 | plot_taiw) 
  
  
