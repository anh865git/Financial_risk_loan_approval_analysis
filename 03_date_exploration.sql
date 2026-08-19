/*
===============================================================================
Date Exploration
===============================================================================
Purpose:
    - Determine the time span of the dataset and check date data integrity.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF(), COUNT(DISTINCT ...)
===============================================================================
*/

SELECT
    MIN(ApplicationDate) AS first_application_date,
    MAX(ApplicationDate) AS last_application_date,
    DATEDIFF(DAY, MIN(ApplicationDate), MAX(ApplicationDate)) AS day_span,
    COUNT(DISTINCT ApplicationDate) AS distinct_dates,
    COUNT(*) AS total_rows
FROM gold.loan_applications;

/*
===============================================================================
 DATA INTEGRITY FINDING (verified on the live data)
===============================================================================
 Because this is a simulated project, MAX date gets beyond the range of current date,
 use GETDATE() if you want to be more realistic. 

 ApplicationDate spans 2018-01-01 to 2072-10-03 — 20,000 rows and exactly
 20,000 distinct dates with ZERO duplicates and ZERO gaps (one row per
 calendar day, for ~55 straight years, including a year 46 years in the
 future). 


===============================================================================
*/
