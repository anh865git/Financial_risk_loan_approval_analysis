/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - Compare measures across dimensions to find which borrower segments
      the bank approves most/least, and where pricing differs.

SQL Functions Used:
    - SUM(), AVG(), COUNT(), GROUP BY, ORDER BY
===============================================================================
*/

-- Approval rate by employment status
SELECT EmploymentStatus, COUNT(*) AS applicants, SUM(CAST(LoanApproved AS INT)) AS approved,
       ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 2) AS approval_rate_pct
FROM gold.loan_applications
GROUP BY EmploymentStatus ORDER BY approval_rate_pct DESC;

-- Approval rate by education level
SELECT EducationLevel, COUNT(*) AS applicants,
       ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 2) AS approval_rate_pct
FROM gold.loan_applications
GROUP BY EducationLevel ORDER BY approval_rate_pct DESC;

-- Approval rate by home ownership
SELECT HomeOwnershipStatus, COUNT(*) AS applicants,
       ROUND(100.0 * SUM(CAST(LoanApproved AS FLOAT)) / COUNT(*), 2) AS approval_rate_pct
FROM gold.loan_applications
GROUP BY HomeOwnershipStatus ORDER BY approval_rate_pct DESC;

-- Loan volume, avg interest rate & avg risk score by loan purpose
SELECT LoanPurpose, COUNT(*) AS applicants, SUM(LoanAmount) AS total_loan_volume,
       ROUND(AVG(CAST(LoanAmount AS FLOAT)), 0) AS avg_loan_amount,
       ROUND(100 * AVG(InterestRate), 2) AS avg_interest_rate_pct,
       ROUND(AVG(RiskScore), 1) AS avg_risk_score,
       ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 2) AS approval_rate_pct
FROM gold.loan_applications
GROUP BY LoanPurpose ORDER BY total_loan_volume DESC;

-- Avg interest rate & credit score by education level
SELECT EducationLevel, ROUND(100 * AVG(InterestRate), 2) AS avg_interest_rate_pct,
       ROUND(AVG(CAST(CreditScore AS FLOAT)), 0) AS avg_credit_score
FROM gold.loan_applications
GROUP BY EducationLevel ORDER BY avg_interest_rate_pct DESC;

/* KEY INSIGHT (executed live):
   Education level is an significant signal:
   Doctorate holders get approved 44.0% of the time at a 22.5% avg rate, 
   vs High School applicants at 14.4% approval 
   and a 24.6% avg rate 
   ~30pt approval gap and ~2pt rate gap driven mostly by the underlying credit-score difference (598 vs 557 avg).

   LoanPurpose barely moves approval rate or pricing (23-25% band across
   all 5 purposes) — the *reason* for the loan matters far less than the
   borrower's credit profile. */
