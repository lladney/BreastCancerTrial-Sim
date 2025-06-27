# Statistical Analysis Plan (SAP)

## Study Title  
**A Simulated Phase II Randomized Controlled Trial of Immunotherapy vs. Chemotherapy in HR+/HER2− Metastatic Breast Cancer**

## Protocol ID  
**BCT-IMMUNO-SIM-01**

---

## 1. Study Objectives

### Primary Objective  
To evaluate whether immunotherapy improves overall survival (OS) compared to standard chemotherapy in patients with hormone receptor–positive (HR+), HER2-negative metastatic breast cancer.

### Secondary Objectives  
- Compare progression-free survival (PFS) between treatment arms  
- Assess survival by ECOG performance status and menopausal status  
- Compare adverse event profiles between treatment arms  

---

## 2. Study Design  

This is a simulated, two-arm, 1:1 randomized controlled trial involving **300 virtual patients** with HR+/HER2− metastatic breast cancer. Patients are assigned to one of two treatment arms:

- **Arm A:** Standard chemotherapy  
- **Arm B:** PD-1/PD-L1–targeting immunotherapy  

Survival times are simulated using an **exponential model** with a **hazard ratio (HR) of 0.75** favoring immunotherapy. Independent censoring is applied to reflect real-world follow-up loss.

---

## 3. Endpoints

### Primary Endpoint  
- **Overall Survival (OS):** Time from randomization to death from any cause

### Secondary Endpoints  
- **Progression-Free Survival (PFS):** Time from randomization to disease progression or death  
- **Adverse Events:** Simulated incidence and severity by treatment group  

---

## 4. Sample Size Determination  

A total sample size of **633 patients** (randomized 1:1) is required to detect a **25% reduction in the hazard of death** (HR = 0.75) with **80% power** and a **two-sided alpha of 0.05**, assuming an **event rate of 60%**.

**Calculation Method:** Schoenfeld’s formula  
```
n = ((Z_{1−α/2} + Z_{1−β})²) / (p(1−p)(log(HR))² × φ)
```

Where:  
- α = 0.05 (significance level)  
- β = 0.2 (1 − power)  
- HR = 0.75  
- p = 0.5 (equal randomization)  
- φ = 0.6 (event rate)  

This yields approximately **380 events**, requiring **633 total enrollees**.

**Justification:** The HR of 0.75 mirrors real-world immunotherapy efficacy in breast cancer (e.g., IMpassion130, KEYNOTE-355).

---

## 5. Statistical Methods

### 5.1 Descriptive Analysis  
Baseline characteristics will be summarized using:  
- **Continuous variables**: Means and standard deviations (e.g., age)  
- **Categorical variables**: Counts and percentages (e.g., ECOG status)  

### 5.2 Primary Analysis  
- **Kaplan-Meier survival curves** for OS  
- **Log-rank test** to compare survival distributions  
- **Cox proportional hazards model** to estimate HRs and 95% CIs  

### 5.3 Secondary Analyses  
- Subgroup survival analyses by ECOG and menopausal status  
- **Forest plot** for subgroup hazard ratios  
- **Chi-squared** or **Fisher’s exact test** for comparing adverse events  

---

## 6. Data Management and Reproducibility  

This analysis uses simulated data. All R scripts and workflows are available in the project GitHub repository. Results are reproducible via the included Conda environment.

---

## 7. Software  

- **R version:** 4.3+  
- **Key packages:**  
  `simstudy`, `survival`, `survminer`, `ggplot2`, `data.table`, `gtsummary`

---

## Appendix  

- **Simulation script:** `scripts/01_simulate_breast_cancer_data.R`  
- **Sample size calculation:** `scripts/02_sample_size_calc.R`  
