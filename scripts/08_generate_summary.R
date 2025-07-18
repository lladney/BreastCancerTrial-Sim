# Simulation of Randomized Clinical Trial Comparing Chemotherapy vs. Immunotherapy in HR+/HER2− Metastatic Breast Cancer
# Step 8: Create HTML Summary Report

# LIBRARIES
library(survival)                                               # survival = survival analysis functions
library(survminer)                                              # survminer = visualize survival analysis results
library(data.table)                                             # data.table = fast data handling
library(gt)                                                     # gt = create summary tables
library(htmltools)                                              # htmltools = construct HTML content
library(base64enc)                                              # base64enc = encode files in Base64 format

# LOAD SIMULATED DATA
dt <- fread("data/simulated_clinical_data.csv")                 # Load simulated clinical dataset from CSV into data.table (dt)

# FIT COX MODEL
cox_model <- coxph(Surv(time, status) ~ treatment + hr_label + menopause + ecog, data = dt) # Fit cox model
summary_model <- summary(cox_model)                             # Create summary of cox model

# EXTRACT KEY COX MODEL STATS
results_table <- data.frame(                                    # Create data.frame with key Cox model stats: HRs, CIs, p-values
  Variable = rownames(summary_model$coefficients),              # Names of covariates (row names of coefficients matrix)
  HR = round(summary_model$coefficients[, "exp(coef)"], 2),     # Hazard ratios, rounded to 2 decimals
  `95% CI Lower` = round(summary_model$conf.int[, "lower .95"], 2), # Rounded lower confidence bound
  `95% CI Upper` = round(summary_model$conf.int[, "upper .95"], 2), # Rounded upper confidence bound
  `p-value` = signif(summary_model$coefficients[, "Pr(>|z|)"], 3),  # Significance values, up to 3 significant digits
  check.names = FALSE                                           # Don't mess with column names
)

# CREATE GT TABLE
gt_table <- gt(results_table) %>%                               # Convert data.frame into gt table object
  tab_header(                                                   # Add title, subtitle
    title = "Cox Proportional Hazards Model Summary",
    subtitle = "Breast Cancer Clinical Trial Simulation"
  ) %>%
  fmt_number(columns = c(HR, `95% CI Lower`, `95% CI Upper`), decimals = 2) # Ensure numerical columns shown with 2 decimal places

# SAVE GT TABLE TEMPORARILY
gtsave(gt_table, filename = "results/temp_table.html")          # Save gt summary table as HTML file

# ENCODE IMAGE AS BASE64 
encode_img <- function(path) {                                  # Convert PNG -> Base64-encooded HTML
  encoded <- base64enc::dataURI(file = path, mime = "image/png")       # Read image and encode it as Base64
  tags$img(src = encoded, style = "width:600px; margin-bottom: 20px;") # Wrap as image with styling
}

# EMBED ALL SUBGROUP PLOTS 
plot_paths <- list.files("results/figures/subgroups",           # Create list of PNG plot file paths here
                         full.names = TRUE,                     # Return full file paths not just filenames
                         pattern = "\\.png$")                   # Only include files ending in .png

                                                                # Create list of HTML blocks
img_tags <- lapply(plot_paths, function(p) {                    # Loop over each image file path
  tags$div(                                                     # Wrap heading and image into single HTML block
    tags$h4(basename(p)),                                       # basename(p) = extract just filename
    encode_img(p)                                               # Encode image and return <img> tag
  )
})

# CREATE FINAL HTML
html_report <- tags$html(                                       # Wrap everything in html tag
  tags$head(tags$title("Breast Cancer Trial Summary Report")),  # Add title to browser tab
  tags$body(                                                    # Define body content of webpage
    tags$h2("Breast Cancer Trial Summary Report"),              # h2 = main heading
    includeHTML("results/temp_table.html"),                     # Embed saved Cox model summary table
    tags$h3("Kaplan-Meier Plots by Subgroup"),                  # h3 = subheading for next section
    img_tags                                                    # List of <div> blocks created earlier; each has KM plot
  )
)

# SAVE REPORT
save_html(html_report, file = "results/summary_report.html")    # Save full HTML report object as .html
file.remove("results/temp_table.html")                          # Delete temporary HTML file before embedding
cat("HTML report written to results/summary_report.html\n")     # Notify user
