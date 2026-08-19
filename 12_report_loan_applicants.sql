/*
===============================================================================
Loan Applicant Report (360-degree view)
===============================================================================
Purpose:
    - Consolidate the applicant record with derived KPIs and segments into
      one queryable view, ready for Power BI / Tableau.

  NOTE ON GRAIN: unlike the retail reference project (which aggregates many
  transactions up to one row per customer), this dataset is already one row
  per applicant/application. So instead of a customer_aggregation CTE that
  SUMs many orders, the "aggregation" layer here computes derived ratios
  that don't exist in the raw columns (loan-to-income, savings coverage,
  rate spread over base) -- same 3-layer CTE pattern, adapted to the grain.

Highlights:
    1. Base query: retrieves the core borrower/loan columns.
    2. Derived KPIs: loan-to-income ratio, savings coverage (months),
       interest rate spread over the base rate.
    3. Final: applies credit/risk/DTI segments and an approval flag.
===============================================================================
*/

IF OBJECT_ID('gold.report_loan_applicants', 'V') IS NOT NULL
    DROP VIEW gold.report_loan_applicants;
GO

CREATE VIEW gold.report_loan_applicants AS

WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: core columns for the report
---------------------------------------------------------------------------*/
    SELECT
        ApplicationDate, Age, AnnualIncome, MonthlyIncome, CreditScore, EmploymentStatus,
        EducationLevel, MaritalStatus, HomeOwnershipStatus, LoanPurpose, NumberOfDependents,
        LoanAmount, LoanDuration, MonthlyDebtPayments, MonthlyLoanPayment,
        DebtToIncomeRatio, TotalDebtToIncomeRatio, SavingsAccountBalance, CheckingAccountBalance,
        TotalAssets, TotalLiabilities, NetWorth, BaseInterestRate, InterestRate,
        BankruptcyHistory, PreviousLoanDefaults, RiskScore, LoanApproved
    FROM gold.loan_applications
),

derived AS (
/*---------------------------------------------------------------------------
2) Derived KPIs: ratios not present in the raw data
---------------------------------------------------------------------------*/
    SELECT *,
        ROUND(CAST(LoanAmount AS FLOAT) / NULLIF(AnnualIncome, 0), 3) AS loan_to_income_ratio,
        ROUND(CAST(SavingsAccountBalance AS FLOAT) / NULLIF(MonthlyDebtPayments + MonthlyLoanPayment, 0), 1) AS savings_coverage_months,
        ROUND(InterestRate - BaseInterestRate, 4) AS interest_rate_spread
    FROM base_query
)

/*---------------------------------------------------------------------------
3) Final: applies segments and the decision flag
---------------------------------------------------------------------------*/
SELECT
    *,
    CASE WHEN CreditScore < 540 THEN 'Bottom Quartile'
         WHEN CreditScore < 578 THEN '2nd Quartile'
         WHEN CreditScore < 609 THEN '3rd Quartile'
         ELSE 'Top Quartile' END AS credit_tier,
    CASE WHEN RiskScore < 42 THEN 'Low Risk'
         WHEN RiskScore < 48 THEN 'Watch Zone'
         ELSE 'High Risk' END AS risk_tier,
    CASE WHEN DebtToIncomeRatio < 0.20 THEN 'Healthy (<20%)'
         WHEN DebtToIncomeRatio < 0.36 THEN 'Manageable (20-36%)'
         ELSE 'High (>36%)' END AS dti_band,
    CASE WHEN LoanApproved = 1 THEN 'Approved' ELSE 'Declined' END AS decision
FROM derived;
GO

-- Headline KPI cross-tab: does credit tier matter once risk tier is known?
SELECT risk_tier, credit_tier, COUNT(*) AS n,
       ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 1) AS approval_rate_pct
FROM gold.report_loan_applicants
GROUP BY risk_tier, credit_tier
ORDER BY risk_tier, credit_tier;

/* RESULT : approval rate is driven almost entirely by
   risk_tier (Low ~98-100%, Watch 29-68%, High ~1%) and barely shifts
   across credit_tier within the same risk_tier -- confirms RiskScore is
   the dominant/composite underwriting variable in this dataset. */
