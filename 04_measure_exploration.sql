/*
===============================================================================
Measure Exploration (Key Metrics)
===============================================================================
Purpose:
    - Calculate the "big numbers" that summarize the loan portfolio.

SQL Functions Used:
    - COUNT(), SUM(), AVG(), ROUND(), UNION ALL
===============================================================================
*/

SELECT 'Total Applications' AS measure_name, CAST(COUNT(*) AS FLOAT) AS measure_value FROM gold.loan_applications
UNION ALL
SELECT 'Total Approved', CAST(SUM(CAST(LoanApproved AS INT)) AS FLOAT) FROM gold.loan_applications
UNION ALL
SELECT 'Approval Rate %', ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 2) FROM gold.loan_applications
UNION ALL
SELECT 'Total Loan Volume Requested', CAST(SUM(LoanAmount) AS FLOAT) FROM gold.loan_applications
UNION ALL
SELECT 'Total Loan Volume Approved', CAST(SUM(CASE WHEN LoanApproved = 1 THEN LoanAmount ELSE 0 END) AS FLOAT) FROM gold.loan_applications
UNION ALL
SELECT 'Avg Loan Amount', ROUND(AVG(CAST(LoanAmount AS FLOAT)), 2) FROM gold.loan_applications
UNION ALL
SELECT 'Avg Credit Score', ROUND(AVG(CAST(CreditScore AS FLOAT)), 1) FROM gold.loan_applications
UNION ALL
SELECT 'Avg Interest Rate %', ROUND(100 * AVG(InterestRate), 2) FROM gold.loan_applications
UNION ALL
SELECT 'Avg Risk Score', ROUND(AVG(RiskScore), 1) FROM gold.loan_applications
UNION ALL
SELECT 'Avg Debt-to-Income Ratio', ROUND(AVG(DebtToIncomeRatio), 3) FROM gold.loan_applications
UNION ALL
SELECT 'Bankruptcy Rate %', ROUND(100.0 * SUM(CAST(BankruptcyHistory AS INT)) / COUNT(*), 2) FROM gold.loan_applications
UNION ALL
SELECT 'Prior Default Rate %', ROUND(100.0 * SUM(CAST(PreviousLoanDefaults AS INT)) / COUNT(*), 2) FROM gold.loan_applications;

/*
   Total Applications: 20,000        | Total Approved: 4,780
   Approval Rate: 23.90%             | Total Loan Volume Requested: $497,657,356
   Total Loan Volume Approved: $91,511,710
   Avg Loan Amount: $24,883          | Avg Credit Score: 571.6
   Avg Interest Rate: 23.91%         | Avg Risk Score: 50.8
   Avg DTI Ratio: 0.286              | Bankruptcy Rate: 5.24%
   Prior Default Rate: 10.01% */
