# Parameters
alpha <- 0.05      # Significance level
power <- 0.80      # Desired power
hr <- 0.75         # Target hazard ratio
p <- 0.5           # 1:1 randomization
phi <- 0.6         # Expected event rate (60%)

# Z-scores
z_alpha <- qnorm(1 - alpha / 2)
z_beta <- qnorm(power)

# Schoenfeld formula
n <- ((z_alpha + z_beta)^2) / (p * (1 - p) * (log(hr)^2) * phi)

# Output
cat("Sample Size Estimate (Schoenfeld Method - Manual)\n")
cat("-------------------------------------------------\n")
cat("Hazard Ratio:", hr, "\n")
cat("Alpha:", alpha, "\n")
cat("Power:", power, "\n")
cat("Proportion in treatment arm (p):", p, "\n")
cat("Event Rate (phi):", phi, "\n\n")
cat("Required total sample size:", ceiling(n), "\n")