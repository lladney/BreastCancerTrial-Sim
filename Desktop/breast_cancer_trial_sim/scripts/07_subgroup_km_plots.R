# scripts/07_subgroup_km_plots.R

library(survival)
library(survminer)
library(data.table)

# Load data
dt <- fread("data/simulated_clinical_data.csv")

# Create output directory if it doesn't exist
dir.create("results/figures/subgroups", recursive = TRUE, showWarnings = FALSE)

# Function to generate KM plots by treatment for each subgroup level
plot_subgroup_km <- function(data, subgroup_var, out_dir) {
  levels <- unique(data[[subgroup_var]])
  
  for (level in levels) {
    subset_data <- data[get(subgroup_var) == level]
    fit <- survfit(Surv(time, status) ~ treatment, data = subset_data)
    
    p <- ggsurvplot(
      fit,
      data = subset_data,
      pval = TRUE,
      title = paste("KM Plot -", subgroup_var, "=", level),
      legend.title = "Treatment",
      xlab = "Time (months)",
      risk.table = TRUE,
      ggtheme = theme_minimal()
    )
    
    ggsave(
      filename = paste0(out_dir, "/", subgroup_var, "_", level, "_KM.png"),
      plot = p$plot,
      width = 7,
      height = 5,
      dpi = 300
    )
  }
}

# Apply function to each subgroup variable
subgroup_vars <- c("hr_label", "menopause", "ecog")
for (var in subgroup_vars) {
  plot_subgroup_km(dt, var, "results/figures/subgroups")
}


