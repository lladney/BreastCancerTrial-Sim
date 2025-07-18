# Simulation of Randomized Clinical Trial Comparing Chemotherapy vs. Immunotherapy in HR+/HER2− Metastatic Breast Cancer
# Step 3: Kaplan-Meier Survival Analysis by Treatment Group

# LIBRARIES
library(survival)                                               # survival = survival analysis functions
library(survminer)                                              # survminer = visualize survival analysis results
library(data.table)                                             # data.table = fast data handling

# LOAD SIMULATED DATA  
dt <- fread("data/simulated_clinical_data.csv")                 # Load simulated clinical dataset from CSV into data.table (dt)

# FIT KM SURVIVAL CURVES
fit <- survfit(Surv(time, status) ~ treatment, data = dt)       # Component breakdown:
                                                                # Surv(time, status) = create survival object with:
                                                                # 1. time: event or censoring
                                                                # 2. status: event indicator (1 = event, 0 = censored)
                                                                # ~ treatment = stratifies curves by treatment variable (chemotherapy or immunotherapy)
                                                                # data = dt = use dataset dt
                                                                # survfit() = to fit KM curves to each treatment group

# PERFORM LOG-RANK TEST
logrank <- survdiff(Surv(time, status) ~ treatment, data = dt)  # Component breakdown:
                                                                # survdiff() = to statistically compare survival curves between treatment groups                                                           

# PRINT SUMMARY STATS
cat("Log-Rank Test for Overall Survival:\n")                    # Notify user
print(logrank)                                                  # logrank Output:
                                                                # 1) Observed vs Expected events per group
                                                                # 2) Chi-squared stat
                                                                # 3) Degrees of freedom (df)

# GENERATE KM PLOT
km_plot <- ggsurvplot(                                          # ggsurvplot() generates KM survival plot
  fit,                                                          # fit = survfit() object containing KM curves by treatment
  data = dt,                                                    # dt = dataset used to compute curves
  risk.table = TRUE,                                            # Add number-at-risk table below KM plot
  pval = TRUE,                                                  # Add log-rank test p-value to KM plot
  conf.int = TRUE,                                              # Add confidence interval shading around KM curves
  legend.title = "Treatment Arm",                               # Legend title
  legend.labs = c("Chemotherapy", "Immunotherapy"),             # Labels for treatment arms
  xlab = "Time (months)",                                       # x-axis label
  ylab = "Overall Survival Probability",                        # y-axis label
  palette = c("#E64B35", "#4DBBD5"),                            # Colors for treatment groups
  ggtheme = theme_minimal()                                     # Minimal plot theme
)

# SAVE PLOT
ggsave("results/figures/km_os_curve.png",                       # File path where image saves
       km_plot$plot,                                            # Extract just KM plot from ggsurvplot object
       width = 7, height = 5, dpi = 300)                        # Dimensions in inches and image resolution

# SAVE RISK TABLE
ggsave("results/figures/km_os_curve_risktable.png",             # File path where image saves
       km_plot$table,                                           # Extract just risk table from ggsurvplot object
       width = 7, height = 2, dpi = 300)                        # Dimensions in inches and image resolution
