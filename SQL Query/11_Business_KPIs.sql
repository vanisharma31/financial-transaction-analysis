-- =============================================================
-- Business KPIs
-- =============================================================

WITH card_info AS (
SELECT client_id, MIN(acct_open_date) AS account_open_date
FROM cards_data
GROUP BY client_id
),
customer_metrics AS (
SELECT u.id,
SUM(t.amount) AS total_spending,AVG(t.amount) AS avg_transaction, COUNT(t.id) AS total_transactions,
TIMESTAMPDIFF(MONTH, ci.account_open_date, MAX(t.date)) AS months_active,
u.credit_score, u.yearly_income, u.total_debt
FROM users_data u 
JOIN transactions_data t ON u.id = t.client_id
LEFT JOIN card_info ci ON u.id = ci.client_id
GROUP BY u.id, ci.account_open_date, u.credit_score, u.yearly_income, u.total_debt
),
customer_clv AS (
SELECT *,
ROUND(avg_transaction * (total_transactions / NULLIF(months_active, 0)) * 12,2) AS estimated_clv
FROM customer_metrics
),
customer_activity AS (
SELECT client_id, MAX(date) AS last_transaction_date
FROM transactions_data
GROUP BY client_id
),
customer_status AS (
SELECT client_id,
CASE
WHEN DATEDIFF((SELECT MAX(date) FROM transactions_data), last_transaction_date) <= 90 THEN 'Active'
WHEN DATEDIFF((SELECT MAX(date) FROM transactions_data), last_transaction_date) <= 180 THEN 'At Risk'
ELSE 'Inactive' END AS customer_status
FROM customer_activity
)
SELECT COUNT(*) AS total_customers,
SUM(CASE
    WHEN cs.customer_status = 'Active' THEN 1 
    ELSE 0 
    END) AS active_customers,
SUM(CASE
	WHEN cs.customer_status = 'At Risk' THEN 1
	ELSE 0
	END) AS at_risk_customers,
SUM(CASE
	WHEN cs.customer_status = 'Inactive' THEN 1
	ELSE 0
	END) AS inactive_customers,
ROUND(SUM(cc.total_spending), 2) AS total_spending,
ROUND(AVG(cc.avg_transaction), 2) AS avg_transaction,
ROUND(AVG(cc.estimated_clv), 2) AS avg_clv,
ROUND(AVG(cc.credit_score), 2) AS avg_credit_score,
ROUND(AVG(cc.yearly_income), 2) AS avg_income,
ROUND(AVG(cc.total_debt), 2) AS avg_debt
FROM customer_clv cc
JOIN customer_status cs ON cc.id = cs.client_id;