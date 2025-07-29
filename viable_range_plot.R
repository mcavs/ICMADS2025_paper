library(ggplot2)
library(dplyr)

viable_range_plot <- function(data, data_name){
  # Calculate the difference between the highest and lowest value for each row
  row_diffs <- apply(data, 1, function(x) max(x) - min(x))
  
  # Calculate the minimum value for each row
  row_mins <- apply(data, 1, min)
  
  # Create a data frame for ggplot2
  df_plot <- data.frame(
    Original_ID    = 1:length(row_diffs),       # Original observation ID
    Difference     = row_diffs,                 # Difference value for each row
    Baseline_value = data[, 1] - row_mins, # Newly calculated baseline value
    name           = rep(data_name, length(row_mins))
  )
  
  # Sort the data frame by height (Difference column)
  df_plot_sorted <- df_plot |>
    arrange(Difference) |>
    # Create normalized ID for the X-axis (from 0 to 1)
    mutate(Normalized_ID = (1:n() - 1) / (n() - 1)) # (ID - min_ID) / (max_ID - min_ID)
  # For 1 to 100 observations, it's (ID - 1) / 99
  
  # Draw the bar plot and points
  plot <- ggplot(df_plot_sorted, aes(x = Normalized_ID, 
                                     y = Difference)) +        # Use Normalized_ID for x-axis
    geom_col(fill  = "grey", 
             color = NA, 
             width = 1 / nrow(df_plot_sorted)) +       # Adjust bar width
    #geom_point(aes(y = Baseline_value), 
    #           color = "red", 
    #           size  = 0.5, 
    #           alpha = 0.6) + # Points
    labs(
      title = "",
      x = "Percentile Rank of Observations", 
      y = expression(abs(V[epsilon](x[i]))) 
    ) +
    theme_bw(base_size = 16) +
    theme(
      strip.text = element_text(
        family   = "Courier")
    ) +
    # Set breaks and labels for the Y-axis
    scale_y_continuous(
      breaks = c(0.25, 0.50, 0.75, 1.00), # Values to be marked on the Y-axis
      labels = c("0.25", "0.50", "0.75", "1"), # Labels corresponding to these values
      limits = c(0, 1),
      expand = expansion(mult = c(0, 0))
    ) +
    # Set breaks and labels for the X-axis
    scale_x_continuous(
      breaks = c(0.25, 0.50, 0.75, 1.00), # Values to be marked on the X-axis
      labels = c("25%", "50%", "75%", "100%"), # Labels corresponding to these values
      limits = c(0, 1),
      expand = expansion(mult = c(0, 0)) 
    ) + 
    facet_grid(~ name)
  return(plot)
}

plot_aer  <- viable_range_plot(data = AER, data_name = "CreditCard")
plot_aer  <- plot_aer + labs(x = NULL)  +
  theme(
    axis.text.x  = element_blank(),   
    axis.ticks.x = element_blank(),
    axis.text.y  = element_text(size = 14)
  )

plot_bank <- viable_range_plot(bank, data_name = "Bank_marketing")
plot_bank <- plot_bank + labs(x = NULL, y = NULL) +
  theme(
    axis.text.x  = element_blank(),   
    axis.ticks.x = element_blank(),
    axis.text.y  = element_blank(),   
    axis.ticks.y = element_blank()
  )

plot_germ <- viable_range_plot(german, data_name = "German_credit")
plot_germ <- plot_germ + labs(x = NULL, y = NULL) +
  theme(
    axis.text.x  = element_blank(),   
    axis.ticks.x = element_blank(),
    axis.text.y  = element_blank(),   
    axis.ticks.y = element_blank()
  ) 

plot_give <- viable_range_plot(give, data_name = "Give_me_credit")
plot_give <- plot_give + labs(x = NULL)  +
  theme(
    axis.text.x  = element_blank(),   
    axis.ticks.x = element_blank(),
    axis.text.y  = element_text(size = 14)
  ) 

plot_hmeq <- viable_range_plot(hmeq, data_name = "HMEQ")
plot_hmeq <- plot_hmeq + labs(x = NULL, y = NULL) +
  theme(
    axis.text.x  = element_blank(),   
    axis.ticks.x = element_blank(),
    axis.text.y  = element_blank(),   
    axis.ticks.y = element_blank()
  ) 

plot_loan <- viable_range_plot(loan, data_name = "Loan_data")
plot_loan <- plot_loan + labs(x = NULL, y = NULL) +
  theme(
    axis.text.x  = element_blank(),   
    axis.ticks.x = element_blank(),
    axis.text.y  = element_blank(),   
    axis.ticks.y = element_blank()
  ) 

plot_pol3 <- viable_range_plot(poland3, data_name = "Poland_year3")
plot_pol3  <- plot_pol3 +
  theme(
    axis.text.x  = element_text(size = 14),   
    axis.text.y  = element_text(size = 14)   
  ) 

plot_pol5 <- viable_range_plot(poland5, data_name = "Poland_year5")
plot_pol5 <- plot_pol5 + labs(y = NULL) +
  theme(
    axis.text.y  = element_blank(),   
    axis.ticks.y = element_blank(),
    axis.text.x  = element_text(size = 14)
  )

plot_taiw <- viable_range_plot(taiwan, data_name = "Taiwan_credit")
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



