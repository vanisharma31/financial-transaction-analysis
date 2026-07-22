-- =============================================================
-- Customer Segmentation 
-- =============================================================

 WITH customer_summary AS (
 SELECT u.id, u.yearly_income, u.credit_score, u.total_debt,
 SUM(t.amount) AS total_spending, COUNT(t.id) AS total_transactions, AVG(t.amount) AS avg_transaction
 FROM users_data u 
 JOIN transactions_data t on u.id=t.client_id
 GROUP BY u.id, u.yearly_income, u.credit_score, u.total_debt
 ) 
 SELECT *,
 CASE 
 WHEN yearly_income >=100000 AND total_spending >= 50000 THEN 'VIP'
 WHEN credit_score>=750 AND total_spending>=30000 THEN 'Premium'
 WHEN total_debt > yearly_income*0.5 AND credit_score < 600 THEN 'Risk'
 WHEN total_spending <10000 THEN 'Budget'
 ELSE 'Regular'
 END AS customer_segment 
 FROM customer_summary;
 
 WITH customer_summary AS (
 SELECT u.id, u.yearly_income, u.credit_score, u.total_debt,
 SUM(t.amount) AS total_spending, COUNT(t.id) AS total_transactions, AVG(t.amount) AS avg_transaction
 FROM users_data u 
 JOIN transactions_data t on u.id=t.client_id
 GROUP BY u.id, u.yearly_income, u.credit_score, u.total_debt
 ) 
 SELECT customer_segment, COUNT(*) AS total_customers
 FROM(SELECT *,
 CASE 
 WHEN yearly_income >=100000 AND total_spending >= 50000 THEN 'VIP'
 WHEN credit_score>=750 AND total_spending>=30000 THEN 'Premium'
 WHEN total_debt > yearly_income*0.5 AND credit_score < 600 THEN 'Risk'
 WHEN total_spending <10000 THEN 'Budget'
 ELSE 'Regular'
 END AS customer_segment 
 FROM customer_summary) x
 GROUP BY customer_segment;
 
 WITH customer_summary AS (
 SELECT u.id, SUM(t.amount) AS total_spending
 FROM users_data u 
 JOIN transactions_data t
 ON u.id = t.client_id
 GROUP BY u.id
 )
 SELECT id, total_spending, 
 NTILE(4) OVER(ORDER BY total_spending DESC) AS spending_quartile
 FROM customer_summary;
 
  WITH customer_summary AS (
 SELECT u.id, u.yearly_income, u.credit_score, u.total_debt,
 SUM(t.amount) AS total_spending
 FROM users_data u 
 JOIN transactions_data t on u.id=t.client_id
 GROUP BY u.id, u.yearly_income, u.credit_score, u.total_debt
 ),
 ranked AS (
 SELECT *,
 NTILE(4) OVER(ORDER BY total_spending DESC) AS spending_group
 FROM customer_summary
 )
 SELECT *,
 CASE
 WHEN spending_group = 1 AND credit_score >=750 THEN 'VIP'
 WHEN spending_group = 2 THEN 'Premium'
 WHEN spending_group = 3 THEN 'Regular'
 WHEN total_debt > yearly_income*0.5 AND credit_score<600 THEN 'Risk'
 ELSE 'Budget'
 END AS customer_segement
 FROM ranked;