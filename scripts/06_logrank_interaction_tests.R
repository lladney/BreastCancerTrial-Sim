# Simulation of Randomized Clinical Trial Comparing Chemotherapy vs. Immunotherapy in HR+/HER2− Metastatic Breast Cancer
# Step 6: Perform Log-Rank Tests within Subgroups and Fit Cox Models to Assess Treatment Effect

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

# LOG-RANK TESTS BY SUBGROUP
cat("Log-rank Tests by Subgroup\n")                             # Inform user

for (var in c("hr_label", "menopause", "ecog")) {               # Loop over each subgroup variable
                                                                # For example, hr_label (test HR+ vs HR-)
  levels <- unique(dt[[var]])                                   # var = hr_label will return levels = c("HR+", "HR−")
  for (lvl in levels) {                                         # Run lvl = HR+ then lvl = HR-
    subgroup <- dt[get(var) == lvl]                             # Get the column with name in var and level (i.e., hr_label, HR+)
    fit <- survdiff(Surv(time, status) ~ treatment, data = subgroup) # Run log-rank test comparing treatment at specified var and level
    pval <- 1 - pchisq(fit$chisq, df = 1)                       # Calculate p-value from chi-squared stat; 2 treatment groups, so 1 df
    cat(paste0("Subgroup: ", var, " = ", lvl, " | p = ", round(pval, 4), "\n")) # Inform user
                                                                # paste0 = concatenates strings and variables with no spaces
                                                                # round(pval, 4) = round p-value to 4 decimal places
  }
}

# COX MODEL WITH TREATMENT X HR STATUS INTERACTION
cat("Cox Model: Treatment × HR Status Interaction\n")           # Inform user

dt[, interaction := interaction(treatment, hr_label)]           # Create new column (interaction) combining treatment and hr_label for each row
                                                                # Interaction column will be new factor...
                                                                # For example: Chemotherapy.HR+, Chemotherapy.HR-, Immunotherapy.HR+, Immunotherapy.HR-
cox_model <- coxph(Surv(time, status)                           # Fit Cox proportional hazards model
                   ~ treatment * hr_label + menopause + ecog,   # Expands to: ~ treatment + hr_label + treatment:hr_label + menopause + ecog (include interaction term)
                                                                # Note: interaction term tests if treatment effect depends on HR status (difference between HR+ and HR-?)
                   data = dt)                                   # Use dataset dt

summary(cox_model)                                              # Print summary of Cox model
