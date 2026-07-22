-- =============================================================
-- Business KPIs
-- =============================================================


WITH customer_metrics AS (
SELECT u.id, SUM(t.amount) AS total_spending, AVG(t.amount) AS avg_transaction, COUNT(t.id) AS total_transactions,
TIMESTAMPDIFF(MONTH, MIN(c.acct_open_date), MAX(t.date)) AS months_active,
ROUND(SUM(t.amount) *(COUNT(t.id) / NULLIF(TIMESTAMPDIFF(MONTH, MIN(c.acct_open_date), MAX(t.date)),0)),2) AS estimated_clv,
u.credit_score, u.yearly_income, u.total_debt
FROM users_data u
JOIN cards_data c ON u.id = c.client_id
JOIN transactions_data t ON u.id = t.client_id
GROUP BY u.id, u.credit_score, u.yearly_income,u.total_debt
),
churn AS(
SELECT client_id,
CASE
WHEN DATEDIFF((SELECT MAX(date) FROM transactions_data), MAX(date)) <= 90 THEN 'Active'
WHEN DATEDIFF((SELECT MAX(date) FROM transactions_data),MAX(date)) <= 180 THEN 'At Risk'
ELSE 'Churned'
END AS customer_status
FROM transactions_data
GROUP BY client_id
)
SELECT COUNT(DISTINCT cm.id) AS total_customers,
COUNT(CASE
	  WHEN c.customer_status='Active' THEN 1
	  END) AS active_customers,
ROUND(SUM(cm.total_spending),2) AS total_spending,
ROUND(AVG(cm.avg_transaction),2) AS avg_transaction,
ROUND(AVG(cm.estimated_clv),2) AS avg_clv,
ROUND(AVG(cm.credit_score),2) AS avg_credit_score,
ROUND(AVG(cm.yearly_income),2) AS avg_income,
ROUND(AVG(cm.total_debt),2) AS avg_debt,
ROUND(SUM(CASE
		  WHEN c.customer_status='Churned' THEN 1 ELSE 0
		  END)*100.0/COUNT(*),2) AS churn_rate
FROM customer_metrics cm
JOIN churn c ON cm.id = c.client_id;


