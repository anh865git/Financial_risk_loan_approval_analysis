/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - Calculate running totals / moving averages (window-function technique).
      Same caveat as script 07 applies to the underlying date field.

SQL Functions Used:
    - SUM() OVER(), AVG() OVER()
===============================================================================
*/

SELECT
    application_year,
    total_loan_volume,
    SUM(total_loan_volume) OVER (ORDER BY application_year) AS running_total_volume,
    ROUND(AVG(avg_rate) OVER (ORDER BY application_year), 4) AS moving_avg_rate
FROM (
    SELECT YEAR(ApplicationDate) AS application_year,
           SUM(LoanAmount) AS total_loan_volume,
           AVG(InterestRate) AS avg_rate
    FROM gold.loan_applications
    GROUP BY YEAR(ApplicationDate)
) AS yearly
ORDER BY application_year;
