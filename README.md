
# About Me & This Project

With a background in **finance**, I am passionate about bridging the gap between financial analysis and data engineering to drive smarter, data-backed decisions. This repository reflects my hands-on journey into structured data analysis.

A special shoutout to [@DataWithBaraa](https://github.com/DataWithBaraa) for providing an incredibly inspiring and helpful roadmap for SQL beginners, which laid a strong foundation for this workflow.

Additionally, development for this project was assisted by **Copilot** in refining T-SQL syntax, query optimization, and presentation clarity.
# Loan Portfolio — SQL EDA & Advanced Analytics

A SQL analytics portfolio project on a 20,000-row consumer loan application dataset, following a 6-step EDA framework and an advanced-analytics roadmap (change-over-time, cumulative, performance, part-to-whole, and segmentation analysis), consolidated into a single reporting view.

## Contents

- `sql_server_scripts/` — 13 numbered T-SQL scripts (SQL Server / SSMS syntax), mirroring the reference EDA framework:
  - `00_init_database.sql` — database/schema/table DDL for `gold.loan_applications`
  - `01_database_exploration.sql` → `06_ranking_analysis.sql` — the 6 EDA steps
  - `07_change_over_time_analysis.sql` → `11_part_to_whole_analysis.sql` — advanced analytics
  - `12_report_loan_applicants.sql` — final consolidated `gold.report_loan_applicants` view
- `RESULTS_AND_INSIGHTS.md` — the write-up: scorecard, data-integrity finding, and 6 headline insights
- `data/Loan.csv` — source data (20,000 rows × 36 columns, Kaggle-style synthetic loan dataset)

## Key finding highlights

- Approval rate: 23.9% (4,780 / 20,000)
- `RiskScore` is an almost deterministic approval gate, with a cliff around 42–45 — see insight #3 in `RESULTS_AND_INSIGHTS.md` for a target-leakage caution if you extend this into a predictive model
- `ApplicationDate` is a synthetic sequential index (one row per calendar day, 2018–2072), not a real timestamp — disclosed rather than treated as a seasonality trend
- Education level is the strongest demographic driver of approval and pricing; loan purpose is nearly irrelevant

## How to run

1. Run `00_init_database.sql` in SSMS against your SQL Server instance — this creates the table AND runs the `BULK INSERT` load. Update the file path inside it to point at your local `data/Loan.csv` first.
2. Run scripts `01` → `12` in order.
3. Connect Power BI / Tableau to `gold.report_loan_applicants` for visualization.
