# Simulation of Randomized Clinical Trial Comparing Chemotherapy vs. Immunotherapy in HR+/HER2− Metastatic Breast Cancer
# Step 5: Generate Kaplan-Meier Survival Plots by Treatment Group and for HR+/HR- Subgroups

# LIBRARIES
library(survival)                                               # survival = survival analysis functions
library(survminer)                                              # survminer = visualize survival analysis results
library(data.table)                                             # data.table = fast data handling

# LOAD SIMULATED DATA
dt <- fread("data/simulated_clinical_data.csv")                 # Load simulated clinical dataset from CSV into data.table (dt)

# CONFIRM COVARIATES ARE FACTORS
dt[, treatment := factor(treatment)]                            # Each covariate should be a factor (categorical variable)
dt[, hr_label := factor(hr_label)]
dt[, ecog := factor(ecog)]
dt[, menopause := factor(menopause)]

# GENERATE KM PLOTS BY HR STATUS
plot_km_by_hr <- function(data, hr_group, filename) {           # Define function with data (full dataset, dt here), hr_group (HR+ or HR-), filename (flexible output path)
  subset_dt <- data[hr_label == hr_group]                       # Filter to include only patients in specified HR group
  fit <- survfit(Surv(time, status) ~ treatment, data = subset_dt) # Fit KP curve for treatment groups within HR subgroup

  p <- ggsurvplot(                                              # ggsurvplot() generates KM survival plot
    fit,                                                        # fit = as specified above 
    data = subset_dt,                                           # subset_dt = as specified above
    pval = TRUE,                                                # Show log-rank test p-value
    risk.table = TRUE,                                          # Show risk table
    conf.int = TRUE,                                            # Show shaded 95% confidence intervals
    title = paste("Survival by Treatment in", hr_group, "Patients"), # Generate title
    xlab = "Time (months)",                                     # x-axis label
    legend.title = "Treatment",                                 # Legend label
    legend.labs = c("Chemotherapy", "Immunotherapy")            # Define treatment group names
  )

  ggsave(filename,                                              # Save to specified filename
         plot = p$plot,                                         # Save only survival curve (not risk table)
         width = 7, height = 5, dpi = 300)                      # Dimensions and resolution
}

# GENERATE KM PLOTS BY TREATMENT
plot_km_by_hr(dt, "HR+", "results/figures/km_hr_positive.png")  # data = dt; hr_group HR+; filename as specified
plot_km_by_hr(dt, "HR−", "results/figures/km_hr_negative.png")  # data = dt; hr_group HR-; filename as specified
