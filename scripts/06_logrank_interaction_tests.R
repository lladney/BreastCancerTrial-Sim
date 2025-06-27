# scripts/06_logrank_interaction_tests.R

library(survival)
library(data.table)
library(survminer)

# Load data
dt <- fread("data/simulated_clinical_data.csv")

# Ensure factors are properly labeled
dt[, treatment := factor(treatment)]
dt[, hr_label := factor(hr_label)]
dt[, ecog := factor(ecog)]
dt[, menopause := factor(menopause)]

#-------------------------------#
# 1. Log-rank tests by subgroup #
#-------------------------------#

cat("\n--- Log-rank Tests by Subgroup ---\n")

for (var in c("hr_label", "menopause", "ecog")) {
  levels <- unique(dt[[var]])
  for (lvl in levels) {
    subgroup <- dt[get(var) == lvl]
    fit <- survdiff(Surv(time, status) ~ treatment, data = subgroup)
    pval <- 1 - pchisq(fit$chisq, df = 1)
    cat(paste0("Subgroup: ", var, " = ", lvl, " | p = ", round(pval, 4), "\n"))
  }
}

#--------------------------------------------------#
# 2. Cox model with treatment × HR status interaction #
#--------------------------------------------------#

cat("\n--- Cox Model: Treatment × HR Status Interaction ---\n")

dt[, interaction := interaction(treatment, hr_label)]
cox_model <- coxph(Surv(time, status) ~ treatment * hr_label + menopause + ecog, data = dt)
summary(cox_model)


