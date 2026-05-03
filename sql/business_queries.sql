-- ============================================================
-- Credit Risk & Loan Default Prediction
-- Business SQL Queries
-- Author: Sanju Thomas Sabu
-- Database: credit_risk.db | Table: loan_applicants
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Overall Default Rate
-- Business purpose: Establish the portfolio-level baseline
-- default rate — the single most important headline metric
-- for a bank's credit risk dashboard.
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_applicants,
    SUM(SeriousDlqin2yrs) AS total_defaults,
    ROUND(100.0 * SUM(SeriousDlqin2yrs) / COUNT(*), 2) AS default_rate_pct
FROM loan_applicants;


-- ------------------------------------------------------------
-- QUERY 2: Default Rate by Age Band
-- Business purpose: Identify which age segments carry the
-- highest default risk — informs age-based risk tiering
-- in lending policy.
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 44 THEN '30-44'
        WHEN age BETWEEN 45 AND 59 THEN '45-59'
        WHEN age BETWEEN 60 AND 74 THEN '60-74'
        ELSE '75+'
    END AS age_band,
    COUNT(*) AS total_applicants,
    SUM(SeriousDlqin2yrs) AS total_defaults,
    ROUND(100.0 * SUM(SeriousDlqin2yrs) / COUNT(*), 2) AS default_rate_pct
FROM loan_applicants
WHERE age > 0
GROUP BY age_band
ORDER BY default_rate_pct DESC;


-- ------------------------------------------------------------
-- QUERY 3: Average Debt Ratio and Income by Default Status
-- Business purpose: Quantify how much riskier defaulters look
-- on core financial health metrics compared to non-defaulters.
-- ------------------------------------------------------------
SELECT
    CASE WHEN SeriousDlqin2yrs = 1 THEN 'Defaulted' ELSE 'No Default' END AS default_status,
    ROUND(AVG(DebtRatio), 4) AS avg_debt_ratio,
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income,
    COUNT(*) AS total_applicants
FROM loan_applicants
GROUP BY SeriousDlqin2yrs;


-- ------------------------------------------------------------
-- QUERY 4: High-Risk Segment Isolation
-- Business purpose: Identify the most dangerous applicant
-- segment — those with high utilization, high debt, AND
-- a history of default. These are priority accounts for
-- collections and early intervention.
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS high_risk_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM loan_applicants), 2) AS pct_of_portfolio,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income,
    ROUND(AVG(DebtRatio), 4) AS avg_debt_ratio
FROM loan_applicants
WHERE RevolvingUtilizationOfUnsecuredLines > 0.8
  AND DebtRatio > 0.5
  AND SeriousDlqin2yrs = 1;


-- ------------------------------------------------------------
-- QUERY 5: Late Payment History vs Default Status
-- Business purpose: Show how the frequency of late payments
-- correlates with default — validates late payment flags as
-- leading indicators for early warning systems.
-- ------------------------------------------------------------
SELECT
    SeriousDlqin2yrs AS defaulted,
    ROUND(AVG("NumberOfTime30-59DaysPastDueNotWorse"), 4) AS avg_30_59_late,
    ROUND(AVG(NumberOfTimes90DaysLate), 4) AS avg_90_days_late,
    ROUND(AVG("NumberOfTime60-89DaysPastDueNotWorse"), 4) AS avg_60_89_late,
    COUNT(*) AS total
FROM loan_applicants
GROUP BY SeriousDlqin2yrs;


-- ------------------------------------------------------------
-- QUERY 6: Top Risk Factors — Default Rate by Utilization Band
-- Business purpose: Rank credit utilization bands by default
-- rate to establish utilization thresholds for credit policy
-- (e.g. flag applicants above 80% utilization).
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN RevolvingUtilizationOfUnsecuredLines <= 0.25 THEN 'Low (0-25%)'
        WHEN RevolvingUtilizationOfUnsecuredLines <= 0.50 THEN 'Moderate (25-50%)'
        WHEN RevolvingUtilizationOfUnsecuredLines <= 0.75 THEN 'High (50-75%)'
        WHEN RevolvingUtilizationOfUnsecuredLines <= 1.00 THEN 'Very High (75-100%)'
        ELSE 'Extreme (>100%)'
    END AS utilization_band,
    COUNT(*) AS total_applicants,
    SUM(SeriousDlqin2yrs) AS total_defaults,
    ROUND(100.0 * SUM(SeriousDlqin2yrs) / COUNT(*), 2) AS default_rate_pct
FROM loan_applicants
GROUP BY utilization_band
ORDER BY default_rate_pct DESC;


-- ------------------------------------------------------------
-- QUERY 7: Default Rate by Number of Dependents
-- Business purpose: Assess whether household size correlates
-- with default risk — relevant for affordability assessments
-- in retail lending decisions.
-- ------------------------------------------------------------
SELECT
    CAST(NumberOfDependents AS INTEGER) AS num_dependents,
    COUNT(*) AS total_applicants,
    SUM(SeriousDlqin2yrs) AS total_defaults,
    ROUND(100.0 * SUM(SeriousDlqin2yrs) / COUNT(*), 2) AS default_rate_pct
FROM loan_applicants
WHERE NumberOfDependents IS NOT NULL
GROUP BY num_dependents
ORDER BY num_dependents;


-- ------------------------------------------------------------
-- QUERY 8: Income Band Analysis
-- Business purpose: Segment applicants into income tiers and
-- measure default rates per tier — directly informs minimum
-- income thresholds in loan origination policy.
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN MonthlyIncome < 2000 THEN 'Under $2K'
        WHEN MonthlyIncome BETWEEN 2000 AND 4999 THEN '$2K-$5K'
        WHEN MonthlyIncome BETWEEN 5000 AND 9999 THEN '$5K-$10K'
        WHEN MonthlyIncome BETWEEN 10000 AND 19999 THEN '$10K-$20K'
        ELSE 'Above $20K'
    END AS income_band,
    COUNT(*) AS total_applicants,
    SUM(SeriousDlqin2yrs) AS total_defaults,
    ROUND(100.0 * SUM(SeriousDlqin2yrs) / COUNT(*), 2) AS default_rate_pct
FROM loan_applicants
WHERE MonthlyIncome IS NOT NULL
GROUP BY income_band
ORDER BY default_rate_pct DESC;