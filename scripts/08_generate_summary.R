# Load libraries
library(data.table)
library(gt)
library(survival)
library(survminer)
library(htmltools)
library(base64enc)

# Load clinical data
dt <- fread("data/simulated_clinical_data.csv")

# Refit Cox model
cox_model <- coxph(Surv(time, status) ~ treatment + hr_label + menopause + ecog, data = dt)
summary_model <- summary(cox_model)

# Extract HRs, CIs, p-values
results_table <- data.frame(
  Variable = rownames(summary_model$coefficients),
  HR = round(summary_model$coefficients[, "exp(coef)"], 2),
  `95% CI Lower` = round(summary_model$conf.int[, "lower .95"], 2),
  `95% CI Upper` = round(summary_model$conf.int[, "upper .95"], 2),
  `p-value` = signif(summary_model$coefficients[, "Pr(>|z|)"], 3),
  check.names = FALSE
)

# Create GT table
gt_table <- gt(results_table) %>%
  tab_header(
    title = "Cox Proportional Hazards Model Summary",
    subtitle = "Breast Cancer Clinical Trial Simulation"
  ) %>%
  fmt_number(columns = c(HR, `95% CI Lower`, `95% CI Upper`), decimals = 2)

# Save GT table temporarily
gtsave(gt_table, filename = "results/temp_table.html")

# Function to encode image as base64
encode_img <- function(path) {
  encoded <- base64enc::dataURI(file = path, mime = "image/png")
  tags$img(src = encoded, style = "width:600px; margin-bottom: 20px;")
}

# Embed all subgroup plots
plot_paths <- list.files("results/figures/subgroups", full.names = TRUE, pattern = "\\.png$")
img_tags <- lapply(plot_paths, function(p) {
  tags$div(
    tags$h4(basename(p)),
    encode_img(p)
  )
})

# Compose final HTML
html_report <- tags$html(
  tags$head(tags$title("Breast Cancer Trial Summary Report")),
  tags$body(
    tags$h2("Breast Cancer Trial Summary Report"),
    includeHTML("results/temp_table.html"),
    tags$h3("Kaplan-Meier Plots by Subgroup"),
    img_tags
  )
)

# Save report
save_html(html_report, file = "results/summary_report.html")
file.remove("results/temp_table.html")
cat("✅ Self-contained HTML report written to results/summary_report.html\n")
