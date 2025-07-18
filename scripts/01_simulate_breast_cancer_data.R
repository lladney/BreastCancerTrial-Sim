# Simulation of Randomized Clinical Trial Comparing Chemotherapy vs. Immunotherapy in HR+/HR− Metastatic Breast Cancer
# Step 1: Simulate synthetic clinical trial dataset with patient traits, treatments, and survival outcomes

# LIBRARIES
library(simstudy)                                              # simstudy = to simulate synthetic dataset
library(data.table)                                            # data.table = data manipulation

# SEED 
set.seed(1234)                                                 # Set seed so random numbers generated can be reproduced

# STEP 1: DEFINE BASELINE CHARACTERISTICS 
def <- defData(varname = "age",                                # Define age variable
               dist = "normal",                                # Normal distribution
               formula = 58,                                   # Mean age of 58
               variance = 100)                                 # Variance of 100 (SD = 10)

def <- defData(def,                                            # Use existing definition table
               varname = "menopause",                          # Define menopause variable
               dist = "binary",                                # Binary (0 or 1)
               formula = 0.6)                                  # 60% chance of 1 (post); 40% chance of 0 (pre)

def <- defData(def,                                            # Use existing definition table
               varname = "ki67",                               # Define KI-67 proliferation index (cancer biomarker) variable
               dist = "normal",                                # Normal distribution
               formula = 25,                                   # Mean KI-67 of 25
               variance = 100)                                 # Variance of 100 (SD = 10)

def <- defData(def,                                            # Use existing definition table
               varname = "hr_status",                          # Define hormone receptor status (most cancer patients +) variable
               dist = "binary",                                # Binary (0 or 1)
               formula = 0.8)                                  # 80% chance of 1 (HR+); 20% chance of 0 (HR-) 

def <- defData(def,                                            # Use existing definition table
               varname = "her2_status",                        # Define HER2 receptor status (cancer biomarker) variable
               dist = "binary",                                # Binary (0 or 1)
               formula = 0.1)                                  # 10% chance of 1 (HER2+); 20% chance of 0 (HER2-) 

def <- defData(def,                                            # Use existing definition table
               varname = "rx",                                 # Define treatment variable
               dist = "binary",                                # Binary (0 or 1)
               formula = 0.5)                                  # 50% chance of 1 or 0 (equal probability of receiving treatment)

# STEP 2: GENERATE DATA
dt <- genData(300, def)                                        # Generate synthetic dataset of 300 patients with variable definitions
                                                               # Store in dt data.table: 300 rows, defined columns

dt <- as.data.table(dt)                                        # Just confirm that dt is a data.table before moving on

# STEP 3: MANUALLY ASSIGN ECOG
dt[, ecog :=                                                   # Add ECOG column
   sample(c("0",                                               # 0 = fully active
            "1",                                               # 1 = restricted
            "2"),                                              # 2 = inactive
          .N,                                                  # Gives number of rows in dt (300 patients)
          replace = TRUE,                                      # Chose each ECOG independently
          prob = c(0.5, 0.4, 0.1))]                            # Probability of ECOG values:
                                                               # 50% = 0
                                                               # 40% = 1
                                                               # 10% = 2

dt[, ecog :=                                                   # Update ECOG column
   factor(ecog,                                                # Turn ECOG values into factor (categorical variable)
          levels = c("0",                                      # Specify levels, so that 0 = lowest
                     "1",                                      # 1 = intermediate
                     "2"))]                                    # 2 = highest

# STEP 4: Simulate survival time (exponential, treatment effect)
dt[, lambda :=                                                 # Add lambda column
   fifelse(rx == 1,                                            # Check whether patient received treatment
           0.08,                                               # If TRUE, assign 0.08 (low hazard, longer survival)
           0.12)]                                              # If FALSE, assign 0.12 (high hazard, shorter survival)

dt[, time :=                                                   # Add time column
   rexp(.N,                                                    # Generate random numbers from exponential distribution in .N (number of rows in dt)
        rate = lambda)]                                        # Use vector of lambda values for individual survival times
                                                               # Note: Now each patient has a simulated survival time

# CENSORING
dt[, censor_time :=                                            # Add censor_time column
   runif(.N,                                                   # Generate .N random numbers (1/patient)...
         min = 5,                                              # ...from a normal distribition between 5 and 20
         max = 20)]

dt[, status :=                                                 # Add status column
   ifelse(time <= censor_time, 1,                              # If time is less than or equal to censoring time, then event occurred (1)
          0)]                                                  # Otherwise, event not observed (0)
                                                               # Note: important for survival analysis (i.e., KP or Cox regression) to distinguish observed vs censored events

dt[, time :=                                                   # Update time column...
   pmin(time, censor_time)]                                    # Pick smaller value:
                                                               # If event happened before censoring, keep time
                                                               # If censoring happened first, replace time with censor_time

# STEP 5: LABELING
dt[, treatment :=                                              # Add treatment column
   ifelse(rx == 1,                                             # If rx is equal to 1...
          "Immunotherapy",                                     # ...assign Immunotherapy
          "Chemotherapy")]                                     # Otherwise, assign Chemotherapy

dt[, hr_label :=                                               # Add hr_label column
   ifelse(hr_status == 1,                                      # If hr_status is equal to 1...
          "HR+",                                               # ...assign HR+  
          "HR−")]                                              # Otherwise, assign HR-

dt[, her2_label :=                                             # Add her2_label column
   ifelse(her2_status == 1,                                    # If her2_status is equal to 1...
          "HER2+",                                             # ...assign HER2+
          "HER2−")]                                            # Otherwise, assign HER2-

dt[, menopause :=                                              # Update menopause column
   ifelse(menopause == 1,                                      # If menopause is equal to 1...
          "Post",                                              # ...assign post-menopausal
          "Pre")]                                              # Otherwise, assign pre-menopausal

dt[, c("lambda",                                               # Remove lambda column (used to simulate time)
       "censor_time") := NULL]                                 # Remove censor_time (used to determine final time)

# STEP 6: SAVE
fwrite(dt, file = "data/simulated_clinical_data.csv")          # Write dt data.table to CSV
print(head(dt))                                                # Print the first 6 rows for inspection
