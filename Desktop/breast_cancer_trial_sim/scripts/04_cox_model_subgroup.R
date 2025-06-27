# Load libraries
library(survival)
library(survminer)
library(data.table)
library(gtsummary)

# Load simulated data
dt <- fread("data/simulated_clinical_data.csv")

# Convert key covariates to factors
dt[, treatment := factor(treatment, levels = c("Chemotherapy", "Immunotherapy"))]
dt[, hr_label := factor(hr_label)]
dt[, menopause := factor(menopause)]
dt[, ecog := factor(ecog)]

# Fit Cox model
cox_model <- coxph(
  Surv(time, status) ~ treatment + hr_label + menopause + ecog,
  data = dt
)

# Save tidy regression summary table
cox_summary <- tbl_regression(cox_model, exponentiate = TRUE)
write.csv(as_tibble(cox_summary), "results/tables/cox_model_summary.csv", row.names = FALSE)

# Create forest plot (survminer version)
png("results/figures/forest_subgroups.png", width = 800, height = 600)
ggforest(cox_model, data = dt)
dev.off()
