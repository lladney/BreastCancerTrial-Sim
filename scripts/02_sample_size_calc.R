# Simulation of Randomized Clinical Trial Comparing Chemotherapy vs. Immunotherapy in HR+/HER2− Metastatic Breast Cancer
# Step 2: Calculate Required Total Sample Size for Time-to-Event Clinical Trial

# PARAMETERS
alpha <- 0.05                                                    # Significance level (probability of Type I Error: reject H0 when true)
power <- 0.80                                                    # Power (probability of detecting a true treatment effect: avoid Type II Error of failing to reject a false H0)
hr <- 0.75                                                       # Hazard ratio (treatment group expected to have 25% lower hazard rate than control group)
p <- 0.5                                                         # 1:1 randomization (equal amount of patients in treatment vs control groups)
phi <- 0.6                                                       # Expected event rate (60% of patients expected to experience event)

# Z-SCORES
z_alpha <- qnorm(1 - alpha / 2)                                  # Z-score for two-sided test; Z at bottom and top 2.5% of normal distribution (cutoff for statistical significance)
z_beta <- qnorm(power)                                           # Z-score for power level; cutoff to ensure test is sensitive ehough to detect real effect (not Type II Error)

# SCHOENFELD FORMULA 
n <- ((z_alpha + z_beta)^2) / (p * (1 - p) * (log(hr)^2) * phi)  # Calculate required total sample size for time-to-event study to meet parameters

# OUTPUT
cat("Sample Size Estimate (Schoenfeld Method - Manual)\n")       # Notify user
cat("Hazard Ratio:", hr, "\n")                    
cat("Alpha:", alpha, "\n")
cat("Power:", power, "\n")
cat("Proportion in treatment arm (p):", p, "\n")
cat("Event Rate (phi):", phi, "\n\n")
cat("Required total sample size:", ceiling(n), "\n")             # Round up if decimal number
