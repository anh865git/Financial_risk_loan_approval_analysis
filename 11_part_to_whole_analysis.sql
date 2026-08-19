/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - Which loan purposes contribute the most to overall loan volume?

SQL Functions Used:
    - SUM() OVER() for the grand total, ratio calculation
===============================================================================
*/

SELECT LoanPurpose, total_volume,
       SUM(total_volume) OVER () AS overall_volume,
       ROUND(100.0 * total_volume / SUM(total_volume) OVER (), 2) AS pct_of_total
FROM (
    SELECT LoanPurpose, SUM(LoanAmount) AS total_volume
    FROM gold.loan_applications
    GROUP BY LoanPurpose
) t
ORDER BY total_volume DESC;

/* RESULT :
   Home 29.56% | Debt Consolidation 25.05% | Auto 20.22% | Education 15.15% | Other 10.02%
   Total portfolio requested: $497,657,356 across all 20,000 applications. */
