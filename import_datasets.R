file_list <- list.files(path       = "/Users/mustafacavus/Desktop/ICMADS2025/datasets", 
                        pattern    = "\\.csv$", 
                        full.names = TRUE)

for (file in file_list) {
  object_name <- tools::file_path_sans_ext(basename(file))
  df          <- read.csv(file)
  assign(object_name, df)
}

rm(df)

AER_credit_card_data$Class <- 1 - AER_credit_card_data$Class
german_credit$Class <- 1 - german_credit$Class