-- =============================================================
-- Customer Churn Analysis
-- =============================================================


CREATE OR REPLACE VIEW vw_executive_dashboard AS
WITH customer_metrics AS (
SELECT u.id, SUM(t.amount) total_spending, AVG(t.amount) avg_transaction, COUNT(*) total_transactions,
TIMESTAMPDIFF(MONTH, MIN(c.acct_open_date), MAX(t.date)) months_active,
ROUND(SUM(t.amount) *(COUNT(*)/NULLIF(TIMESTAMPDIFF(MONTH,MIN(c.acct_open_date),MAX(t.date)),0)),2) estimated_clv,
u.credit_score, u.yearly_income, u.total_debt
FROM users_data u
JOIN cards_data c ON u.id=c.client_id
JOIN transactions_data t ON u.id=t.client_id
GROUP BY u.id, u.credit_score, u.yearly_income, u.total_debt
),
churn AS (
SELECT client_id, 
CASE
WHEN DATEDIFF((SELECT MAX(date) FROM transactions_data),MAX(date))<=90 THEN 'Active'
WHEN DATEDIFF((SELECT MAX(date) FROM transactions_data),MAX(date))<=180 THEN 'At Risk'
ELSE 'Churned'
END customer_status
FROM transactions_data
GROUP BY client_id
)
SELECT COUNT(*) total_customers, SUM(customer_status='Active') active_customers,
ROUND(SUM(total_spending),2) total_revenue,
ROUND(AVG(avg_transaction),2) avg_transaction,
ROUND(AVG(estimated_clv),2) avg_clv,
ROUND(AVG(credit_score),0) avg_credit_score,
ROUND(AVG(yearly_income),2) avg_income,
ROUND(AVG(total_debt),2) avg_debt,
ROUND(SUM(customer_status='Churned')*100/COUNT(*),2) churn_rate
FROM customer_metrics cm
JOIN churn c ON cm.id=c.client_id;


-- CUSTOMER PROFILE
CREATE OR REPLACE VIEW vw_customer_profile AS
SELECT u.id, u.current_age, u.gender, u.birth_year, u.birth_month, u.yearly_income, 
u.per_capita_income, u.total_debt, u.credit_score, u.num_credit_cards,
c.card_brand, c.card_type, c.credit_limit
FROM users_data u
LEFT JOIN cards_data c ON u.id=c.client_id;


-- SPENDING ANALYSIS 
CREATE OR REPLACE VIEW vw_spending_analysis AS 
SELECT t.client_id, t.date, DATE_FORMAT(t.date,'%Y-%m') month, t.amount, t.merchant_id, t.merchant_city, t.merchant_state, t.mcc, t.use_chip,
c.card_type, 
SUM(t.amount) OVER(PARTITION BY t.client_id) total_spending, 
AVG(t.amount) OVER(PARTITION BY t.client_id) avg_transaction,
COUNT(*) OVER(PARTITION BY t.client_id) total_transactions,
MAX(t.amount) OVER(PARTITION BY t.client_id) highest_transaction,
MIN(t.amount) OVER(PARTITION BY t.client_id) lowest_transaction
FROM transactions_data t
JOIN cards_data c ON t.card_id=c.id;


-- CUSTOMER SEGMENTS 
CREATE OR REPLACE VIEW vw_customer_segments AS
WITH spending AS (
SELECT u.id, u.yearly_income, u.credit_score, u.total_debt, SUM(t.amount) total_spending
FROM users_data u
JOIN transactions_data t ON u.id=t.client_id
GROUP BY u.id, u.yearly_income, u.credit_score, u.total_debt
)
SELECT *,
CASE
WHEN yearly_income>=100000 AND total_spending>=50000 THEN 'VIP'
WHEN credit_score>=750 AND total_spending>=30000 THEN 'Premium'
WHEN total_debt>yearly_income*0.5 AND credit_score<600 THEN 'Risk'
WHEN total_spending<10000 THEN 'Budget'
ELSE 'Regular'
END customer_segment
FROM spending;


-- CHURN ANALYSIS 
CREATE OR REPLACE VIEW vw_churn_analysis AS
SELECT client_id, MAX(date) last_transaction,
DATEDIFF((SELECT MAX(date) FROM transactions_data), MAX(date)) days_inactive,
CASE
WHEN DATEDIFF((SELECT MAX(date) FROM transactions_data),MAX(date))<=90 THEN 'Active'
WHEN DATEDIFF((SELECT MAX(date) FROM transactions_data),MAX(date))<=180 THEN 'At Risk'
ELSE 'Churned'
END customer_status
FROM transactions_data
GROUP BY client_id;


-- CUSTOMER CLV 
CREATE OR REPLACE VIEW vw_customer_clv AS
WITH metrics AS (
SELECT u.id,  SUM(t.amount) total_spending, ROUND(AVG(t.amount),2) avg_spend, 
COUNT(*) total_transactions,
TIMESTAMPDIFF(MONTH,MIN(c.acct_open_date),MAX(t.date)) months_active
FROM users_data u
JOIN cards_data c ON u.id=c.client_id
JOIN transactions_data t ON u.id=t.client_id
GROUP BY u.id
)
SELECT *,
ROUND(total_transactions/NULLIF(months_active,0),2) transaction_frequency,
ROUND(total_spending*(total_transactions/NULLIF(months_active,0)),2) estimated_clv,
RANK() OVER(ORDER BY(total_spending*(total_transactions/NULLIF(months_active,0))) DESC) customer_rank,
DENSE_RANK() OVER(ORDER BY(total_spending*(total_transactions/NULLIF(months_active,0))) DESC) dense_customer_rank,
NTILE(4) OVER(ORDER BY(total_spending*(total_transactions/NULLIF(months_active,0))) DESC) customer_quartile
FROM metrics;





