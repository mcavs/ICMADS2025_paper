## Overview

This repository contains the code and datasets for the ICMADS 2025 paper, "An Investigation of Predictive Multiplicity in Model Selection for Credit Risk Estimation." It includes data preprocessing, model training, prediction storage, metric calculation, and visualization scripts. All code is written in R.

## Repository Structure
```
ICMADS2025_paper/
│
├── datasets/ # Raw and processed datasets
├── pred_rds/ # Serialized prediction files (.rds)
│
├── import_datasets.R # Loads and preprocesses data
├── h2o_train.R # Trains models using the h2o framework
├── calculate_metrics.R # Evaluates model performance metrics
├── data_manifold.R # Analyzes data manifold characteristics
├── local_density.R # Computes local density statistics
├── local_compare.R # Performs local comparisons across subsets
├── max_deviation_plot.R # Visualizes max deviation across conditions
├── viable_range_plot.R # Plots viable data ranges
├── runAll.R # Master script to run the full pipeline
│
└── README.md # This documentation
```

## Scripts Description

- **`import_datasets.R`**: Imports raw data and preprocesses it (e.g., cleaning, normalization). Outputs structured data frames ready for modeling.

- **`h2o_train.R`**: Initializes the H2O environment, trains machine learning models (e.g., random forests, gradient boosting), and saves predictions to `pred_rds/`.

- **`calculate_metrics.R`**: Loads predictions and ground truth, computes evaluation metrics (e.g., accuracy, RMSE, F1-score), and outputs summary results.

- **`data_manifold.R`**: Explores the structure and distribution of the data manifold, potentially for visualization or manifold learning insights.

- **`local_density.R`**: Calculates local data density measures—useful for clustering analysis or anomaly detection.

- **`local_compare.R`**: Performs comparative analysis across local subsets (e.g., stratified by region, cluster, or other groupings).

- **`max_deviation_plot.R`**: Generates visualizations showing maximum deviations under varying conditions, aiding in understanding extremes or error bounds.

- **`viable_range_plot.R`**: Plots the range of values considered viable or within acceptable bounds across the dataset.

- **`runAll.R`**: Orchestrates the entire workflow: from data import through training, evaluation, and visualization. Run this script to execute the full pipeline end-to-end.

## Dependencies

- **R version ≥ 4.x**  
- Required R packages:  
  `h2o`, `ggplot2`, `dplyr`, `readr`, `purrr`, `tidyr`, and others as used in scripts.

Install dependencies with:

```
install.packages(c("h2o", "ggplot2", "dplyr", "readr", "purrr", "tidyr"))
```
Please make sure you have the H2O package installed and properly configured.

## Usage Instructions

1. Clone the repository:
```
git clone https://github.com/mcavs/ICMADS2025_paper.git
cd ICMADS2025_paper
```

2. Open R (or RStudio) and set the working directory to the project root.

3. Run the full pipeline:
```
source("runAll.R")
```

This will execute all stages: data import, model training, prediction generation, metric calculation, and visualization.

Alternatively, run each stage manually:
```
source("import_datasets.R")
source("h2o_train.R")
source("calculate_metrics.R")
source("data_manifold.R")
source("local_density.R")
source("local_compare.R")
source("max_deviation_plot.R")
source("viable_range_plot.R")
```

## Outputs

* Preprocessed data (in memory or saved)

* Model predictions in pred_rds/

* Evaluation metrics printed or saved as CSVs

* Visualizations: manifold plots, density maps, deviation and range plots (e.g., saved as PNGs or PDFs)


📨 Contact & Citation

Mustafa Cavus – [mustafacavus@eskisehir.edu.tr] or open an issue on GitHub.



