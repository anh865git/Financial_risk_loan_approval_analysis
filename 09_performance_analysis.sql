/*
===============================================================================
Performance Analysis
===============================================================================
Purpose:
    - Compare each LoanPurpose segment's pricing to the portfolio average.

SQL Functions Used:
    - AVG() OVER(), CASE
===============================================================================
*/

SELECT LoanPurpose, avg_rate,
       ROUND(AVG(avg_rate) OVER (), 2) AS portfolio_avg_rate,
       ROUND(avg_rate - AVG(avg_rate) OVER (), 2) AS diff_vs_avg,
       CASE WHEN avg_rate > AVG(avg_rate) OVER () THEN 'Above Avg'
            WHEN avg_rate < AVG(avg_rate) OVER () THEN 'Below Avg'
            ELSE 'Avg' END AS rate_flag
FROM (
    SELECT LoanPurpose, ROUND(100 * AVG(InterestRate), 2) AS avg_rate
    FROM gold.loan_applications
    GROUP BY LoanPurpose
) t
ORDER BY avg_rate DESC;

/* RESULT : spread is small -- 23.85% (Home, lowest) to
   24.01% (Education, highest), all within +/-0.08pt of the 23.93%
   portfolio average. LoanPurpose is not a meaningful pricing driver here. */
