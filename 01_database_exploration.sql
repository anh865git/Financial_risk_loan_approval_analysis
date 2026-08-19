/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - Explore the structure of the database (this is a single flat "gold"
      table, not a fact/dimension star schema — one row = one loan application).

SQL Functions Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'loan_applications';

-- Row count
SELECT COUNT(*) AS total_rows FROM gold.loan_applications;

/* RESULT 
   20,000 rows x 36 columns.  */
