/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - Track application volume, approval rate, and pricing by year.

  CAVEAT: see 03_date_exploration.sql -- ApplicationDate is a synthetic
  sequential index (exactly one row per calendar day, 2018-2072), not a
  real timestamp. This script demonstrates the technique (DATEPART / YEAR,
  GROUP BY, aggregate functions); the flat year-over-year results below
  confirm there is no real seasonality to find here -- each year has
  ~365 rows and approval rate hovers in a narrow band purely by chance.

SQL Functions Used:
    - YEAR(), DATEPART(), SUM(), COUNT(), AVG()
===============================================================================
*/

SELECT
    YEAR(ApplicationDate) AS application_year,
    COUNT(*) AS applications,
    SUM(CAST(LoanApproved AS INT)) AS approved,
    ROUND(100.0 * SUM(CAST(LoanApproved AS INT)) / COUNT(*), 2) AS approval_rate_pct,
    ROUND(100 * AVG(InterestRate), 2) AS avg_interest_rate_pct
FROM gold.loan_applications
GROUP BY YEAR(ApplicationDate)
ORDER BY application_year;

/* RESULT:
   2018: 365 apps, 26.03% approved, 23.74% avg rate
   2019: 365 apps, 22.47% approved, 23.92% avg rate
   2020: 366 apps, 23.50% approved, 23.56% avg rate
   2021: 365 apps, 26.85% approved, 23.59% avg rate
   2022: 365 apps, 21.64% approved, 23.74% avg rate
   2023: 365 apps, 22.74% approved, 24.22% avg rate
   -> No trend, no seasonality -- confirms the synthetic-date finding. */
