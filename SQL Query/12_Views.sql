-- =============================================================
-- Views
-- =============================================================


-- EXECUTIVE DASHBOARD 
CREATE OR REPLACE VIEW vw_executive_dashboard AS
WITH card_info AS (
SELECT client_id, MIN(acct_open_date) AS account_open_date 
FROM cards_data
GROUP BY client_id
),
customer_metrics AS (
SELECT u.id,
SUM(t.amount) AS total_spending,
AVG(t.amount) AS avg_transaction,
COUNT(t.id) AS total_transactions,
TIMESTAMPDIFF(MONTH, c.account_open_date,MAX(t.date)) AS months_active,
ROUND((SUM(t.amount) /NULLIF(TIMESTAMPDIFF(MONTH,c.account_open_date,MAX(t.date)),0)) * 12,2) AS estimated_clv,
u.credit_score, u.yearly_income, u.total_debt
FROM users_data u
JOIN transactions_data t ON u.id = t.client_id
LEFT JOIN card_info c ON u.id = c.client_id
GROUP BY u.id, c.account_open_date, u.credit_score, u.yearly_income, u.total_debt
),
customer_activity AS ( 
SELECT client_id,
MAX(date) AS last_transaction
FROM transactions_data
GROUP BY client_id
),
customer_status AS (
SELECT client_id,
CASE
WHEN DATEDIFF((SELECT MAX(date) FROM transactions_data),last_transaction) <= 90 THEN 'Active'
WHEN DATEDIFF((SELECT MAX(date) FROM transactions_data),last_transaction) <= 180 THEN 'At Risk'
ELSE 'Inactive'
END AS customer_status
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
ROUND(SUM(CASE 
          WHEN cs.customer_status = 'Churned' THEN 1 
          ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate,
ROUND(SUM(cm.total_spending), 2) AS total_spending,
ROUND(AVG(cm.avg_transaction), 2) AS avg_transaction,
ROUND(AVG(cm.estimated_clv), 2) AS avg_clv,
ROUND(AVG(cm.credit_score), 2) AS avg_credit_score,
ROUND(AVG(cm.yearly_income), 2) AS avg_income,
ROUND(AVG(cm.total_debt), 2) AS avg_debt
FROM customer_metrics cm
JOIN customer_status cs ON cm.id = cs.client_id;


-- CUSTOMER PROFILE
CREATE OR REPLACE VIEW vw_customer_profile AS
SELECT u.id, u.current_age, u.gender, u.birth_year, u.birth_month, u.yearly_income, 
u.per_capita_income, u.total_debt, u.credit_score, u.num_credit_cards,
c.card_brand, c.card_type, c.credit_limit
FROM users_data u
LEFT JOIN cards_data c ON u.id=c.client_id;


-- SPENDING ANALYSIS
CREATE OR REPLACE VIEW vw_spending_analysis AS
SELECT t.client_id, t.date, DATE_FORMAT(t.date, '%Y-%m') AS month,
t.amount, t.merchant_id, t.merchant_city, t.merchant_state, t.mcc, t.use_chip, c.card_type,c.card_brand
FROM transactions_data t
JOIN cards_data c ON t.card_id = c.id;
    

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
WITH card_info AS ( 
SELECT client_id,
MIN(acct_open_date) AS account_open_date
FROM cards_data
GROUP BY client_id
),
customer_metrics AS (
SELECT u.id AS client_id, SUM(t.amount) AS total_spending,
AVG(t.amount) AS avg_transaction,
COUNT(t.id) AS total_transactions,
TIMESTAMPDIFF(MONTH,ci.account_open_date, MAX(t.date)) AS months_active,
u.yearly_income, u.credit_score, u.total_debt
FROM users_data u
JOIN transactions_data t ON u.id = t.client_id
LEFT JOIN card_info ci ON u.id = ci.client_id
GROUP BY u.id, ci.account_open_date, u.yearly_income, u.credit_score,u.total_debt
),
clv_calculation AS (
SELECT *,
ROUND(total_transactions /NULLIF(months_active, 0),2) AS monthly_transaction_frequency,
ROUND((total_spending /NULLIF(months_active, 0)) * 12,2) AS estimated_clv
FROM customer_metrics
)
SELECT client_id, total_spending, avg_transaction, total_transactions, months_active,
monthly_transaction_frequency, estimated_clv, yearly_income, credit_score, total_debt,
RANK() OVER (ORDER BY estimated_clv DESC) AS customer_rank
FROM clv_calculation;


-- Top Merchant Cities
CREATE OR REPLACE VIEW vw_top_merchant_cities AS
SELECT merchant_city,
ROUND(SUM(amount),2) AS total_revenue,
COUNT(*) AS total_transactions
FROM transactions_data
GROUP BY merchant_city
ORDER BY total_revenue DESC;

