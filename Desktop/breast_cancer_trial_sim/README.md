# BreastCancer-ClinicalTrial-Sim  
A modular pipeline for simulating a randomized controlled trial (RCT) comparing immunotherapy versus chemotherapy in HR+/HER2− metastatic breast cancer. This end-to-end R-based workflow includes data simulation, power analysis, survival modeling, subgroup assessment, and reproducible reporting.

## Summary  
1. Simulate baseline characteristics and survival outcomes  
2. Estimate sample size using Schoenfeld’s method  
3. Perform survival and subgroup analysis using Cox models and Kaplan-Meier curves  

## Project Structure  
```
breast_cancer_trial_sim/
├── scripts/                          # Core R scripts for trial simulation and analysis
│   ├── 01_simulate_breast_cancer_data.R   # Simulates patient characteristics and survival
│   ├── 02_sample_size_calc.R              # Schoenfeld-based sample size calculation
│   ├── 03_survival_analysis.R             # Kaplan-Meier + Cox model
│   ├── 04_subgroup_analysis.R             # ECOG/menopausal subgroup forest plot
│   └── 05_adverse_event_summary.R         # Simulated AE frequency summary
│
├── results/                          # Output figures and tables
│   ├── km_plot.png                        # Kaplan-Meier survival curve
│   ├── forest_plot.png                    # Subgroup analysis plot
│   ├── adverse_event_table.csv            # Simulated AE summary
│   └── sample_size_output.txt             # Schoenfeld method output
│
├── clinical_sap.md                   # Full Statistical Analysis Plan (SAP)
├── requirements.txt                  # R package dependencies
└── README.md                         # Project overview and usage guide
```

## Installation  

1. Clone the repository:
```bash
git clone https://github.com/yourusername/breast_cancer_trial_sim.git
cd breast_cancer_trial_sim
```

2. Create and activate a Conda environment:
```bash
conda create -n clinical_r python=3.10
conda activate clinical_r
```

3. Install R and required R packages:
```r
install.packages(c("simstudy", "survival", "survminer", "ggplot2", "gtsummary", "data.table"))
```

> Optionally, use the provided `requirements.txt` or build a full Conda-R environment.

## Running the Pipeline

### Step 1:  *DATA SIMULATION*  
Run from the `scripts/` directory:
```r
Rscript 01_simulate_breast_cancer_data.R
```
This will simulate:  
- Baseline covariates (age, ECOG, menopausal status)  
- Randomized treatment assignment (chemo vs. immunotherapy)  
- Survival outcomes and event censoring  

### Step 2:  *SAMPLE SIZE ESTIMATION*  
Estimate necessary sample size for HR = 0.75 using:
```r
Rscript 02_sample_size_calc.R
```
This generates:
- Estimated number of events  
- Required total N (output saved to `sample_size_output.txt`)  

### Step 3:  *SURVIVAL ANALYSIS*  
Run Kaplan-Meier and Cox models:
```r
Rscript 03_survival_analysis.R
```
Outputs include:
- Kaplan-Meier plot by treatment arm  
- Hazard ratio and 95% CI  
- Median survival times  

### Step 4:  *SUBGROUP AND AE ANALYSIS*  
Run subgroup interaction models and adverse event summary:
```r
Rscript 04_subgroup_analysis.R
Rscript 05_adverse_event_summary.R
```
Produces:
- Forest plot of subgroup hazard ratios (e.g., by ECOG, menopause)  
- AE comparison table between arms  

## Dataset  

This project uses **fully simulated data** generated via the `simstudy` package to replicate characteristics of HR+/HER2− metastatic breast cancer trials. No real patient data are used.

- **Design:** Phase II, 1:1 randomized, immunotherapy vs. chemo  
- **Sample size:** n = 300 (simulated); power calculation suggests 633 needed for HR = 0.75  
- **Event model:** Exponential survival with random censoring  
- **Endpoints:** Overall Survival (OS), Progression-Free Survival (PFS), Adverse Events  

## Documentation  

📄 See the [Statistical Analysis Plan (SAP)](clinical_sap.md) for detailed methodology, rationale, and endpoint definitions.

## Notes  
- All results are saved to the `results/` directory  
- This pipeline is fully reproducible with R 4.3+  
- Ideal for showcasing survival analysis, power calculations, and clinical trial simulation in bioinformatics or biostatistics portfolios

## Citation  
If referencing this project, please cite the Statistical Analysis Plan and mention simulated methodology inspired by oncology immunotherapy trials (e.g., IMpassion130, KEYNOTE-355).
