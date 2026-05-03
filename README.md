# Credit Risk & Loan Default Prediction
### End-to-End Analytics & Machine Learning Pipeline

![Python](https://img.shields.io/badge/Python-3.13-blue?logo=python)
![SQLite](https://img.shields.io/badge/SQLite-Database-lightgrey?logo=sqlite)
![scikit-learn](https://img.shields.io/badge/scikit--learn-ML-orange?logo=scikit-learn)
![XGBoost](https://img.shields.io/badge/XGBoost-3.2-red)
![SHAP](https://img.shields.io/badge/SHAP-Explainability-blueviolet)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-yellow?logo=powerbi)

---

## Executive Dashboard Preview

![Dashboard Page 1](powerbi/dashboard_page1.png)

---

## Project Summary

Loan defaults represent one of the most significant risks facing banks and
financial institutions globally. This project builds a complete, production-style
credit risk analytics pipeline — from raw data ingestion and SQL business
analysis, through exploratory analysis and feature engineering, to a machine
learning model capable of predicting which loan applicants are most likely to
default. The final output includes SHAP-based model explainability and a
3-page executive Power BI dashboard designed for a bank's risk management team.

**Dataset:** Give Me Some Credit — Kaggle (150,000 loan applicants, 11 features)  
**Target:** SeriousDlqin2yrs (1 = defaulted within 2 years, 0 = did not default)  
**Dataset Source:** [Download from Kaggle](https://www.kaggle.com/competitions/GiveMeSomeCredit/data)

---

## Key Findings

- **Overall default rate: 6.68%** — 10,026 out of 150,000 applicants defaulted
- **Credit utilization is the strongest predictor** — applicants above 80%
  utilization default at 21% vs only 4% for normal utilization (5.25x higher)
- **Late payments are a leading indicator** — defaulters average 2.39 late
  payments vs 0.28 for non-defaulters, nearly 9x higher
- **Younger borrowers carry the highest risk** — under-30s default at 11.7%,
  nearly double the portfolio average of 6.68%
- **Engineered features outperform raw data** — CreditStressScore (SHAP: 0.152)
  and TotalLatePayments (SHAP: 0.071) are the top two predictors, both
  engineered features, outranking all 11 original dataset columns
- **High-risk segment identified** — 2,253 applicants (1.5% of portfolio) with
  high utilization, high debt ratio, and confirmed default history
- **Class imbalance addressed with SMOTE** — training set balanced from 93/7
  to 50/50 to ensure the model learns to detect the minority default class

---

## Exploratory Data Analysis

![Default Rate by Age Group](visuals/01_default_rate_by_age_group.png)

![Correlation Heatmap](visuals/04_correlation_heatmap.png)

![Credit Stress Score Distribution](visuals/08_credit_stress_score_distribution.png)

---

## Machine Learning Results

![ROC Curve Comparison](visuals/11_roc_curve_comparison.png)

### Model Performance Comparison

| Model | Accuracy | Precision | Recall | F1-Score | ROC-AUC |
|---|---|---|---|---|---|
| Logistic Regression | 0.9113 | 0.3342 | 0.3292 | 0.3317 | 0.8223 |
| **Random Forest ⭐** | 0.8505 | 0.2550 | **0.6439** | 0.3653 | **0.8484** |
| XGBoost | 0.9146 | 0.3734 | 0.4105 | 0.3911 | 0.8433 |
| Gradient Boosting | 0.9094 | 0.3573 | 0.4459 | 0.3967 | 0.8437 |

**Selected model: Random Forest** — highest Recall (0.6439) and ROC-AUC (0.8484).
In credit risk, Recall is prioritised over Precision because missing a real
defaulter results in direct financial loss, while a false alarm can be
reviewed manually by a human underwriter.

---

## SHAP Model Explainability

![SHAP Summary Plot](visuals/12_shap_summary_plot.png)

![SHAP Waterfall Plot](visuals/13_shap_waterfall_plot.png)

The SHAP analysis confirms that **behavioural signals** — how applicants manage
existing credit — are far more predictive than static financial metrics like
income or debt ratio. The engineered `CreditStressScore` ranks as the single
most important feature (SHAP: 0.152), validating the feature engineering approach.

---

## Power BI Dashboard

![Dashboard Page 2](powerbi/dashboard_page2.png)

![Dashboard Page 3](powerbi/dashboard_page3.png)

📄 [Download Full Dashboard PDF](powerbi/credit_risk_dashboard.pdf)

---

## Business Recommendations

1. **Implement utilization threshold policy** — automatically refer all
   applicants with revolving utilization above 80% to manual underwriting
2. **Deploy early warning system** — trigger enhanced account monitoring
   after a customer's first missed payment, not the standard 90-day threshold
3. **Apply age-based risk tiering** — require stricter income and utilization
   criteria for applicants under 30 applying for unsecured credit
4. **Deploy Random Forest as loan pre-screening layer** — integrate into the
   loan origination system with flagged applications reviewed by a human
   underwriter before final decision
5. **Incorporate CreditStressScore into internal scoring framework** — this
   engineered composite score is the single strongest predictor of default
   (SHAP value 0.152) and should be added to the bank's credit scorecard

---

## Project Structure

```
credit-risk-loan-default/
├── data/
│   └── cs_cleaned.csv               # Cleaned & feature-engineered dataset
├── notebooks/
│   └── credit_risk_analysis.ipynb   # Full analysis notebook (all 6 phases)
├── sql/
│   └── business_queries.sql         # 8 business-focused SQL queries
├── visuals/                          # 13 portfolio-ready PNG charts
├── powerbi/
│   └── credit_risk_dashboard.pdf    # 3-page executive dashboard export
├── outputs/
│   ├── model_comparison.csv         # Model metrics for all 4 models
│   └── shap_feature_importance.csv  # SHAP values for Power BI
└── README.md
```

---

## Tools & Technologies

| Tool | Usage |
|---|---|
| Python 3.13 | Data processing, ML pipeline, visualisations |
| Pandas & NumPy | Data manipulation and feature engineering |
| Matplotlib & Seaborn | 13 portfolio-ready visualisations |
| SQLite | Data ingestion and 8 business SQL queries |
| Scikit-learn | ML models, SMOTE, evaluation metrics |
| XGBoost | Gradient boosted classifier |
| SHAP | Model explainability and feature importance |
| Power BI Web | 3-page interactive executive dashboard |

---

*Author: Sanju Thomas Sabu | Master of Business Analytics, University of Wollongong in Dubai*
