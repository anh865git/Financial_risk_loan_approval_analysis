/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - Identify top/bottom performers among dimensions and applicants.

SQL Functions Used:
    - TOP, ORDER BY, RANK() OVER()
===============================================================================
*/

-- Top 5 loan purposes by total loan volume
SELECT TOP 5 LoanPurpose, SUM(LoanAmount) AS total_loan_volume
FROM gold.loan_applications
GROUP BY LoanPurpose ORDER BY total_loan_volume DESC;

-- Top 10 riskiest applicants by RiskScore
SELECT TOP 10 ApplicationDate, Age, CreditScore, LoanAmount, DebtToIncomeRatio, RiskScore, LoanApproved
FROM gold.loan_applications
ORDER BY RiskScore DESC;

-- Bottom-to-top ranking of education segments by approval rate (window function)
SELECT EducationLevel, approval_rate_pct,
       RANK() OVER (ORDER BY approval_rate_pct ASC) AS approval_rank
FROM (
    SELECT EducationLevel, ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 2) AS approval_rate_pct
    FROM gold.loan_applications
    GROUP BY EducationLevel
) t
ORDER BY approval_rate_pct;

-- Employment status ranked by approval rate, worst first
SELECT EmploymentStatus, ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 2) AS approval_rate_pct
FROM gold.loan_applications
GROUP BY EmploymentStatus ORDER BY approval_rate_pct ASC;

/* :
   All 10 riskiest applicants (RiskScore 76-84) were declined 
   Worst approval segment: High School education
   (14.4%) and Unemployed status (18.2%). 

   Best: Doctorate (44.0%) and
   Self-Employed (27.8% -- higher than Employed at 24.0%, likely because
   self-employed applicants in this dataset skew toward stronger credit
   profiles that offset the employment-type risk). */
