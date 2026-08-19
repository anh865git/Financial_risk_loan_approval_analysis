# Loan Portfolio EDA & Advanced Analytics — Results

**Dataset:** Loan.csv — 20,000 loan applications, 36 attributes, no missing values.
**Method:** SQL EDA (6 steps) → Advanced Analytics roadmap → consolidated report view.
**Executed against:** the real data, via DuckDB in this session (see note in README on why DuckDB vs. SQL Server). Every number below was independently re-verified with pandas straight from the CSV.

---

## Portfolio scorecard

| Metric | Value |
|---|---|
| Total applications | 20,000 |
| Approved | 4,780 (23.9%) |
| Total loan volume requested | $497,657,356 |
| Total loan volume approved | $91,511,710 |
| Avg loan amount | $24,883 |
| Avg credit score | 572 (range 343–712) |
| Avg interest rate | 23.9% |
| Avg risk score | 50.8 (range 28.8–84.0) |
| Bankruptcy history rate | 5.2% |
| Prior default rate | 10.0% |

---

## Data integrity finding (Step 3)

`ApplicationDate` runs 2018-01-01 → 2072-10-03 with **exactly one row per calendar day, zero duplicates, zero gaps** — 20,000 rows across 20,000 consecutive days, including dates 46 years in the future. This is a synthetic sequential index, not a real submission timestamp. Confirmed by the year-over-year breakdown: every year has ~365 applications and approval rate/pricing bounce in a random ±3pt band with no trend — there is no real seasonality to find in this field. Disclosed here rather than reported as a "trend" finding, and the advanced-analytics scripts still demonstrate the SQL technique (window functions, date grouping) on it for skill-building purposes.

---

## Headline insights

**1. Education level is the strongest demographic driver of both approval and pricing.**
Doctorate holders: 44.0% approval, 22.5% avg rate. High School: 14.4% approval, 24.6% avg rate. A ~30-point approval gap and ~2-point rate gap, tracking the underlying credit-score difference (598 vs. 557 avg) between the two groups.

**2. Loan purpose barely matters.**
Across Home, Debt Consolidation, Auto, Education, and Other, approval rate stays in a tight 22.3–25.3% band and average interest rate in a 23.85–24.01% band. The *reason* for borrowing carries almost no independent weight next to the borrower's credit profile — a useful negative finding, since it's tempting to assume purpose drives risk.

**3. RiskScore is an almost deterministic gate on approval — likely a composite variable, not an independent feature.**
Approval rate by RiskScore bucket falls off a cliff:

| RiskScore | Approval rate |
|---|---|
| 30–35 | 100.0% |
| 35–40 | 99.8% |
| 40–45 | 90.1% → 13.7% (the cliff sits right around 42–45) |
| 45–50 | 0.9% |
| 50+ | ~0.0% |

Crucially, once RiskScore is known, credit-score quartile barely moves the approval rate further (Low-Risk tier: 97.8–100% approved regardless of credit quartile; High-Risk tier: ~0.9–1.6% approved regardless of credit quartile — see the cross-tab in `12_report_loan_applicants.sql`). **Caution for anyone building a predictive model on this data:** RiskScore should be treated as the decision variable (or excluded from features alongside it) to avoid target leakage — it isn't behaving like an independent risk input.

**4. Debt-to-income ratio, on its own, is surprisingly uninformative.**
Approval rate is nearly flat across DTI bands (Healthy <20%: 23.8% approved, Manageable 20-36%: 24.1%, High >36%: 23.8%). DTI only becomes meaningful in combination with RiskScore/credit score — a good example of why single-variable "magnitude analysis" needs to be paired with segmentation before drawing conclusions.

**5. Employment status has a counter-intuitive twist.**
Self-Employed applicants are approved *more* often than Employed applicants (27.8% vs. 24.0%), despite typically being viewed as higher-risk in real underwriting. Likely explained by this synthetic dataset's Self-Employed segment happening to carry stronger average credit profiles — worth flagging as a "check before you conclude" moment rather than taking at face value.

**6. Home loans dominate volume.**
Home purpose accounts for 29.6% of total loan volume requested ($147.1M), followed by Debt Consolidation (25.1%), Auto (20.2%), Education (15.2%), and Other (10.0%).

---

