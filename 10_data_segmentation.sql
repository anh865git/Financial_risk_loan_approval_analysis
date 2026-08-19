/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - Group applicants into meaningful risk/credit segments using CASE.

  NOTE: standard textbook FICO bands (Poor <580 / Fair 580-669 / Good
  670-739 / Excellent 740+) do NOT fit this dataset -- CreditScore only
  ranges 343-712, so "Excellent" would be empty and "Good" would hold
  under 1% of applicants. Bands below are quartile-based (data-driven)
  instead: Q1=540, Q2(median)=578, Q3=609.

SQL Functions Used:
    - CASE, GROUP BY
===============================================================================
*/

-- Credit tier (quartile-based) vs approval rate & pricing
SELECT credit_tier, COUNT(*) AS n,
       ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 2) AS approval_rate_pct,
       ROUND(100 * AVG(InterestRate), 2) AS avg_rate_pct
FROM (
    SELECT CreditScore, LoanApproved, InterestRate,
        CASE WHEN CreditScore < 540 THEN 'Bottom Quartile'
             WHEN CreditScore < 578 THEN '2nd Quartile'
             WHEN CreditScore < 609 THEN '3rd Quartile'
             ELSE 'Top Quartile' END AS credit_tier
    FROM gold.loan_applications
) seg
GROUP BY credit_tier ORDER BY approval_rate_pct DESC;

-- Risk tier from RiskScore -- the approval "cliff" sits between 42 and 48
SELECT risk_tier, COUNT(*) AS n,
       ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 2) AS approval_rate_pct
FROM (
    SELECT RiskScore, LoanApproved,
        CASE WHEN RiskScore < 42 THEN 'Low Risk'
             WHEN RiskScore < 48 THEN 'Watch Zone'
             ELSE 'High Risk' END AS risk_tier
    FROM gold.loan_applications
) seg
GROUP BY risk_tier ORDER BY approval_rate_pct DESC;

-- Approval rate by 5-point RiskScore bucket -- shows the exact cliff location
SELECT FLOOR(RiskScore / 5) * 5 AS risk_bucket, COUNT(*) AS n,
       ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 2) AS approval_rate_pct
FROM gold.loan_applications
GROUP BY FLOOR(RiskScore / 5) * 5
ORDER BY risk_bucket;

-- DTI health bands
SELECT dti_band, COUNT(*) AS n,
       ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 2) AS approval_rate_pct
FROM (
    SELECT DebtToIncomeRatio, LoanApproved,
        CASE WHEN DebtToIncomeRatio < 0.20 THEN 'Healthy (<20%)'
             WHEN DebtToIncomeRatio < 0.36 THEN 'Manageable (20-36%)'
             ELSE 'High Risk (>36%)' END AS dti_band
    FROM gold.loan_applications
) seg
GROUP BY dti_band ORDER BY approval_rate_pct DESC;

/* HEADLINE FINDING 
   RiskScore is an almost deterministic gate on approval:
     RiskScore 30-40 -> ~99-100% approved
     RiskScore 40-45 -> drops from 90% to 14% (the cliff)
     RiskScore 45-50 -> 0.9% approved
     RiskScore 50+   -> ~0% approved
   Credit tier and DTI band barely move approval rate once RiskScore is
   known (see 12_report_loan_applicants.sql cross-tab)
   -- RiskScore 
   looks like a pre-computed composite underwriting score, not an independent
   input. */
