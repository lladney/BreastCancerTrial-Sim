# Simulation of Randomized Clinical Trial Comparing Chemotherapy vs. Immunotherapy in HR+/HER2− Metastatic Breast Cancer
# Step 4: Fit Cox Proportional Hazards Model 

# LIBRARIES
library(survival)                                               # survival = survival analysis functions
library(survminer)                                              # survminer = visualize survival analysis results
library(data.table)                                             # data.table = fast data handling
library(gtsummary)                                              # gtsummary = create summary of Cox model

# LOAD SIMULATED DATA 
dt <- fread("data/simulated_clinical_data.csv")                 # Load simulated clinical dataset from CSV into data.table (dt)

# CONVERT KEY COVARIATES TO FACTORS
dt[, treatment :=                                               # Update treatment column in dt data.table
   factor(treatment,                                            # Convert from character to factor based on treatment group:
          levels = c(
            "Chemotherapy",                                     # Chemotherapy = level 1 (reference group)
            "Immunotherapy"))]                                  # Immunotherapy = level 2 (compare to reference)
                                                                # Result: original treatment column replaced with factor

dt[, hr_label := factor(hr_label)]                              # Convert hr_label to factor (HR+ = reference; compare HR-)
dt[, menopause := factor(menopause)]                            # Convert menopause to factor (post = reference; compare pre)
dt[, ecog := factor(ecog)]                                      # Convert ecog to factor (0 = reference; compare 0 to 1 and 0 to 2)

# FIT COX MODEL
cox_model <- coxph(                                             # coxph() fits a Cox regression model
  Surv(time, status) ~ treatment + hr_label + menopause + ecog, # Component breakdown
                                                                # Surv(time, status) = create survival object with:
                                                                # 1. time: event or censoring
                                                                # 2. status: event indicator (1 = event, 0 = censored)
                                                                # treatment + hr_label + menopause + ecog = predictors (all factors, each gets own hazard ratio)
                                                                # Note: hazard ratio explains how hazard changes for immuno vs chemo treatment, for example
  data = dt                                                     # data = dt = use dataset dt
)

# SAVE TIDY REGRESSION SUMMARY TABLE
cox_summary <- tbl_regression(cox_model, exponentiate = TRUE)   # Component breakdown:
                                                                # tbl_regression() = convert regression model (coxph) into summary table
                                                                # cox_model = model to be summarized
                                                                # exponentiate = exponentiate coefficients so hazard ratios displayed instead of log(hazard ratio)
                                                                # cox_summary Output:
                                                                # exponentiate = exponentiate coefficients so hazard ratios displayed instead of log(hazard ratio)
                                                                # 1) Variable names
                                                                # 2) Hazard ratios (HR)
                                                                # 3) 95% confidence intervals
                                                                # 4) p-values

write.csv(as_tibble(cox_summary),                               # Save Cox regression summary table as CSV
          "results/tables/cox_model_summary.csv",               # Path to where summary will be saved
          row.names = FALSE)                                    # Omit row numbers from writing to file

# CREATE FOREST PLOT
png("results/figures/forest_subgroups.png",                     # Save plot as PNG in path
    width = 800, height = 600)                                  # Image dimensions
ggforest(cox_model, data = dt)                                  # Create forest plot from Cox model
                                                                # Note: shows which covariates significant and what direction (protective? or harmful?)
dev.off()                                                       # Close PNG and save plot
