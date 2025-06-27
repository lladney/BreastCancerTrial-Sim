# scripts/05_subgroup_km_curves.R

library(survival)
library(survminer)
library(data.table)

# Load data
dt <- fread("data/simulated_clinical_data.csv")

# Make sure covariates are factors
dt[, treatment := factor(treatment)]
dt[, hr_label := factor(hr_label)]
dt[, ecog := factor(ecog)]
dt[, menopause := factor(menopause)]

# Function to generate KM plots by HR status
plot_km_by_hr <- function(data, hr_group, filename) {
  subset_dt <- data[hr_label == hr_group]
  fit <- survfit(Surv(time, status) ~ treatment, data = subset_dt)

  p <- ggsurvplot(
    fit,
    data = subset_dt,
    pval = TRUE,
    risk.table = TRUE,
    conf.int = TRUE,
    title = paste("Survival by Treatment in", hr_group, "Patients"),
    xlab = "Time (months)",
    legend.title = "Treatment",
    legend.labs = c("Chemotherapy", "Immunotherapy")
  )

  ggsave(filename, plot = p$plot, width = 7, height = 5, dpi = 300)
}

# Generate plots
plot_km_by_hr(dt, "HR+", "results/figures/km_hr_positive.png")
plot_km_by_hr(dt, "HR−", "results/figures/km_hr_negative.png")
