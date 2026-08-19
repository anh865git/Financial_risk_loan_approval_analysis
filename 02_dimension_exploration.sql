/*
===============================================================================
Dimension Exploration
===============================================================================
Purpose:
    - Identify unique values in each categorical dimension.

SQL Functions Used:
    - DISTINCT, COUNT, GROUP BY, ORDER BY
===============================================================================
*/

SELECT EmploymentStatus, COUNT(*) AS n
FROM gold.loan_applications
GROUP BY EmploymentStatus ORDER BY n DESC;

SELECT EducationLevel, COUNT(*) AS n
FROM gold.loan_applications
GROUP BY EducationLevel ORDER BY n DESC;

SELECT MaritalStatus, COUNT(*) AS n
FROM gold.loan_applications
GROUP BY MaritalStatus ORDER BY n DESC;

SELECT HomeOwnershipStatus, COUNT(*) AS n
FROM gold.loan_applications
GROUP BY HomeOwnershipStatus ORDER BY n DESC;

SELECT LoanPurpose, COUNT(*) AS n
FROM gold.loan_applications
GROUP BY LoanPurpose ORDER BY n DESC;

SELECT LoanApproved, COUNT(*) AS n
FROM gold.loan_applications
GROUP BY LoanApproved ORDER BY LoanApproved;

SELECT BankruptcyHistory, COUNT(*) AS n
FROM gold.loan_applications
GROUP BY BankruptcyHistory ORDER BY BankruptcyHistory;

SELECT PreviousLoanDefaults, COUNT(*) AS n
FROM gold.loan_applications
GROUP BY PreviousLoanDefaults ORDER BY PreviousLoanDefaults;

SELECT NumberOfDependents, COUNT(*) AS n
FROM gold.loan_applications
GROUP BY NumberOfDependents ORDER BY NumberOfDependents;

/* RESULT (executed live):
   EmploymentStatus: Employed 17,036 | Self-Employed 1,573 | Unemployed 1,391
   EducationLevel:   Bachelor 6,054 | High School 5,908 | Associate 4,034 | Master 3,050 | Doctorate 954
   MaritalStatus:    Married 10,041 | Single 6,078 | Divorced 2,882 | Widowed 999
   HomeOwnershipStatus: Mortgage 7,939 | Rent 6,087 | Own 3,938 | Other 2,036
   LoanPurpose:      Home 5,925 | Debt Consolidation 5,027 | Auto 4,034 | Education 3,008 | Other 2,006
   LoanApproved:     Declined 15,220 (76.1%) | Approved 4,780 (23.9%)
   BankruptcyHistory: No 18,952 (94.8%) | Yes 1,048 (5.2%)
   PreviousLoanDefaults: No 17,999 (90.0%) | Yes 2,001 (10.0%) */
