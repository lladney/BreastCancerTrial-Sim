# Simulation of Randomized Clinical Trial Comparing Chemotherapy vs. Immunotherapy in HR+/HER2− Metastatic Breast Cancer
# Step 7: Generate KM Plots for each Level of Multiple Subgroup Variables

# LIBRARIES
library(survival)                                               # survival = survival analysis functions
library(survminer)                                              # survminer = visualize survival analysis results
library(data.table)                                             # data.table = fast data handling

# LOAD SIMULATED DATA
dt <- fread("data/simulated_clinical_data.csv")                 # Load simulated clinical dataset from CSV into data.table (dt)

# CREATE OUTPUT DIRECTORY
dir.create("results/figures/subgroups",                         # Create folder to this path
           recursive = TRUE,                                    # Allow creation of nested folders
           showWarnings = FALSE)                                # If already exists, don't show warnings

# GENERATE KM PLOTS BY TREATMENT FOR EACH SUBGROUP LEVEL
plot_subgroup_km <- function(data,                              # Specify dataset (i.e., dt)
                             subgroup_var,                      # Name of column to define subgroups (i.e., hr_label)
                             out_dir) {                         # Output directory where plots saved
  
  levels <- unique(data[[subgroup_var]])                        # Get unique levels from current subgroup variable
  
  for (level in levels) {                                       # Loop through each level (i.e., for subgroup_var = menopause, levels = pre, post)
    subset_data <- data[get(subgroup_var) == level]             # Create subset of dataset with rows for only current subgroup, current level
    fit <- survfit(Surv(time, status) ~ treatment, data = subset_data) # Fit KM curve comparing treatment arms within current subgroup level
    
    p <- ggsurvplot(                                            # ggsurvplot() generates KM survival plot
      fit,                                                      # fit = as specified above
      data = subset_data,                                       # subset_data = as specified above
      pval = TRUE,                                              # Add log-rank p-value comparing treatment arms
      title = paste("KM Plot -", subgroup_var, "=", level),     # Generate title
      legend.title = "Treatment",                               # Legend label
      xlab = "Time (months)",                                   # x-axis label
      risk.table = TRUE,                                        # Add risk table
      ggtheme = theme_minimal()                                 # Minimal theme
    )
    
    ggsave(                                                     # Save KM plot to PNG
      filename = paste0(out_dir, "/", subgroup_var, "_", level, "_KM.png"), # Build filename
      plot = p$plot,                                            # Save only survival curve (not risk table)
      width = 7,                                                # Dimensions
      height = 5,
      dpi = 300                                                 # Resolution
    )
  }
}

# APPLY FUNCTION TO EACH SUBGROUP VARIABLE 
subgroup_vars <- c("hr_label", "menopause", "ecog")             # Vector of subgroup variables
for (var in subgroup_vars) {                                    # Loop through each subgroup variable in vector
  plot_subgroup_km(dt, var, "results/figures/subgroups")        # Generate KM plots
}
