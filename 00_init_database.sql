/*
=============================================================
Create Database, Schema, and Table
=============================================================
Script Purpose:
    Creates the 'LoanAnalytics' database and a 'gold' schema
    (this dataset arrives already cleaned/flattened, so it is
    treated as a single gold-layer table — no separate staging
    or silver layers are needed).

WARNING:
    Running this script drops and recreates 'LoanAnalytics' if
    it already exists. All data will be lost. Back up first.
=============================================================
*/

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'LoanAnalytics')
BEGIN
    ALTER DATABASE LoanAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LoanAnalytics;
END;
GO

CREATE DATABASE LoanAnalytics;
GO

USE LoanAnalytics;
GO

CREATE SCHEMA gold;
GO

CREATE TABLE gold.loan_applications (
    ApplicationDate             DATE,
    Age                         INT,
    AnnualIncome                INT,
    CreditScore                 INT,
    EmploymentStatus            NVARCHAR(50),
    EducationLevel              NVARCHAR(50),
    Experience                  INT,
    LoanAmount                  INT,
    LoanDuration                INT,
    MaritalStatus               NVARCHAR(50),
    NumberOfDependents          INT,
    HomeOwnershipStatus         NVARCHAR(50),
    MonthlyDebtPayments         INT,
    CreditCardUtilizationRate   FLOAT,
    NumberOfOpenCreditLines     INT,
    NumberOfCreditInquiries     INT,
    DebtToIncomeRatio           FLOAT,
    BankruptcyHistory           TINYINT,
    LoanPurpose                 NVARCHAR(50),
    PreviousLoanDefaults        TINYINT,
    PaymentHistory              INT,
    LengthOfCreditHistory       INT,
    SavingsAccountBalance       INT,
    CheckingAccountBalance      INT,
    TotalAssets                 INT,
    TotalLiabilities            INT,
    MonthlyIncome               FLOAT,
    UtilityBillsPaymentHistory  FLOAT,
    JobTenure                   INT,
    NetWorth                    INT,
    BaseInterestRate            FLOAT,
    InterestRate                FLOAT,
    MonthlyLoanPayment          FLOAT,
    TotalDebtToIncomeRatio      FLOAT,
    LoanApproved                TINYINT,
    RiskScore                   FLOAT
);
GO

/*
===============================================================================
IMPORT DATA — use BULK INSERT against this table, NOT the "Import Flat
File" wizard's auto-create-table option.
===============================================================================
WHY: SSMS's "Import Flat File" wizard auto-detects column types by
sampling the data. For BankruptcyHistory, PreviousLoanDefaults, and
LoanApproved (which only ever contain 0/1), it guesses SQL type `bit`.
That part is fine in T-SQL itself — but the wizard's underlying .NET
import engine converts source values with `Convert.ChangeType(value,
typeof(bool))`, and .NET's string-to-Boolean conversion ONLY accepts the
literal text "True"/"False" — it does NOT accept "0"/"1", even though
those are perfectly valid bit literals in SQL. That mismatch is exactly
what throws:
    "String '0' was not recognized as a valid Boolean"
This is a known limitation of the wizard, not a problem with your data.

FIX: run the BULK INSERT below against the table already created above
(TINYINT columns, not BIT) — BULK INSERT converts "0"/"1" text correctly
because it goes through SQL Server's native type conversion, not .NET's
IConvertible.ToBoolean path.

If you'd rather keep using the "Import Flat File" wizard's GUI: on its
"Modify Columns" screen, change the Data Type for BankruptcyHistory,
PreviousLoanDefaults, and LoanApproved from "bit" to "tinyint" before
clicking Import — that alone fixes the same error without touching this
script. If the wizard already partially inserted rows into an
auto-created table before failing, drop that table first so you don't
end up with duplicate/partial data next to this one.
===============================================================================
*/

-- Update the file path to match where Loan.csv lives on your machine.
BULK INSERT gold.loan_applications
FROM 'C:\SQL2025\SQL data analyst project\Loan.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',   -- use '\n' instead if this errors on row parsing
    TABLOCK
);
GO

-- Sanity check after loading
SELECT COUNT(*) AS row_count FROM gold.loan_applications;   -- expect 20000
GO
