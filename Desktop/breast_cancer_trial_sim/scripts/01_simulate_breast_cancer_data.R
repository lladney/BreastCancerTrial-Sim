# Load required libraries
library(simstudy)
library(data.table)

# Set seed for reproducibility
set.seed(1234)

# STEP 1: Define baseline covariates (excluding ECOG)
def <- defData(varname = "age", dist = "normal", formula = 58, variance = 100)
def <- defData(def, varname = "menopause", dist = "binary", formula = 0.6)
def <- defData(def, varname = "ki67", dist = "normal", formula = 25, variance = 100)
def <- defData(def, varname = "hr_status", dist = "binary", formula = 0.8)
def <- defData(def, varname = "her2_status", dist = "binary", formula = 0.1)
def <- defData(def, varname = "rx", dist = "binary", formula = 0.5)

# STEP 2: Generate data
dt <- genData(300, def)

# Confirm still a data.table
dt <- as.data.table(dt)

# STEP 3: Manually assign ECOG 0/1/2
dt[, ecog := sample(c("0", "1", "2"), .N, replace = TRUE, prob = c(0.5, 0.4, 0.1))]
dt[, ecog := factor(ecog, levels = c("0", "1", "2"))]

# STEP 4: Simulate survival time (exponential, treatment effect)
dt[, lambda := fifelse(rx == 1, 0.08, 0.12)]
dt[, time := rexp(.N, rate = lambda)]

# Censoring
dt[, censor_time := runif(.N, min = 5, max = 20)]
dt[, status := ifelse(time <= censor_time, 1, 0)]
dt[, time := pmin(time, censor_time)]

# STEP 5: Labeling
dt[, treatment := ifelse(rx == 1, "Immunotherapy", "Chemotherapy")]
dt[, hr_label := ifelse(hr_status == 1, "HR+", "HR−")]
dt[, her2_label := ifelse(her2_status == 1, "HER2+", "HER2−")]
dt[, menopause := ifelse(menopause == 1, "Post", "Pre")]

# Drop temporary columns
dt[, c("lambda", "censor_time") := NULL]

# STEP 6: Save
fwrite(dt, file = "data/simulated_clinical_data.csv")
print(head(dt))
