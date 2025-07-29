library(ggplot2)
library(dplyr)

viable_range_plot <- function(data, baseline){
  # Calculate the difference between the highest and lowest value for each row
  row_diffs <- apply(data, 1, function(x) max(x) - min(x))
  
  # Calculate the minimum value for each row
  row_mins <- apply(data, 1, min)
  
  # Create a data frame for ggplot2
  df_plot <- data.frame(
    Original_ID    = 1:length(row_diffs),       # Original observation ID
    Difference     = row_diffs,                 # Difference value for each row
    Baseline_value = data[,baseline] - row_mins # Newly calculated baseline value
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
    theme_bw() +
    theme(
      plot.title = element_text(hjust = 0.5)
    ) +
    # Set breaks and labels for the Y-axis
    scale_y_continuous(
      breaks = c(0, 0.25, 0.50, 0.75, 1.00), # Values to be marked on the Y-axis
      labels = c("0%", "25%", "50%", "75%", "100%"), # Labels corresponding to these values
      limits = c(0, 1) # Force Y-axis limits between 0 and 1
    ) +
    # Set breaks and labels for the X-axis
    scale_x_continuous(
      breaks = c(0, 0.25, 0.50, 0.75, 1.00), # Values to be marked on the X-axis
      labels = c("0%", "25%", "50%", "75%", "100%"), # Labels corresponding to these values
      expand = expansion(mult = c(0, 0)) # Ensure bars start and end exactly at the axis limits
    )
  return(plot)
}

viable_range_plot(AER, 1)
viable_range_plot(bank, 1)
viable_range_plot(german, 1)
viable_range_plot(give, 1)
viable_range_plot(hmeq, 1)
viable_range_plot(loan, 1)
viable_range_plot(poland3, 1)
viable_range_plot(poland5, 1)
viable_range_plot(taiwan, 1)
