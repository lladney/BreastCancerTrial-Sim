# Load required packages
library(survival)
library(survminer)
library(data.table)

# Load simulated data
dt <- fread("data/simulated_clinical_data.csv")

# Fit Kaplan-Meier survival curves
fit <- survfit(Surv(time, status) ~ treatment, data = dt)

# Perform log-rank test
logrank <- survdiff(Surv(time, status) ~ treatment, data = dt)

# Print summary stats
cat("Log-Rank Test for Overall Survival:\n")
print(logrank)

# Generate KM plot
km_plot <- ggsurvplot(
  fit,
  data = dt,
  risk.table = TRUE,
  pval = TRUE,
  conf.int = TRUE,
  legend.title = "Treatment Arm",
  legend.labs = c("Chemotherapy", "Immunotherapy"),
  xlab = "Time (months)",
  ylab = "Overall Survival Probability",
  palette = c("#E64B35", "#4DBBD5"),
  ggtheme = theme_minimal()
)

# Save plot
ggsave("results/figures/km_os_curve.png", km_plot$plot, width = 7, height = 5, dpi = 300)

# Optional: Save risk table
ggsave("results/figures/km_os_curve_risktable.png", km_plot$table, width = 7, height = 2, dpi = 300)
