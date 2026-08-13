-- =============================================================
-- Customer Lifetime Value (CLV)
-- =============================================================


-- CUSTOMER SPENDING METRICS
WITH customer_metrics AS (
SELECT u.id, SUM(t.amount) AS total_spend, ROUND(AVG(t.amount),2) AS avg_spend, COUNT(t.id) AS total_transactions,
TIMESTAMPDIFF( MONTH, MIN(c.acct_open_date), MAX(t.date)) AS months_active
FROM users_data u
JOIN cards_data c ON u.id = c.client_id
JOIN transactions_data t ON u.id = t.client_id
GROUP BY u.id
)
SELECT *
FROM customer_metrics;


-- CUSTOMER TRANSACTION FREQUENCY
WITH customer_metrics AS (
SELECT u.id, SUM(t.amount) AS total_spend, ROUND(AVG(t.amount),2) AS avg_spend, COUNT(t.id) AS total_transactions,
TIMESTAMPDIFF( MONTH, MIN(c.acct_open_date), MAX(t.date)) AS months_active
FROM users_data u
JOIN cards_data c ON u.id = c.client_id
JOIN transactions_data t ON u.id = t.client_id
GROUP BY u.id
)
SELECT *, ROUND(total_transactions/NULLIF(months_active,0),2) AS transaction_frequency
FROM customer_metrics;


-- CUSTOMER LIFETIME VALUE (CLV)
WITH customer_metrics AS (
SELECT u.id, SUM(t.amount) AS total_spend, ROUND(AVG(t.amount),2) AS avg_spend, COUNT(t.id) AS total_transactions,
TIMESTAMPDIFF( MONTH, MIN(c.acct_open_date), MAX(t.date)) AS months_active
FROM users_data u
JOIN cards_data c ON u.id = c.client_id
JOIN transactions_data t ON u.id = t.client_id
GROUP BY u.id
)
SELECT *, ROUND(total_transactions/NULLIF(months_active,0),2) AS transaction_frequency,
ROUND(total_spend * (total_transactions/NULLIF(months_active,0)) * months_active, 2) AS estimated_clv
FROM customer_metrics;


-- RANK CUSTOMERS BY ESTIMATED CLV
WITH customer_clv AS(
WITH customer_metrics AS (
SELECT u.id, SUM(t.amount) AS total_spend, ROUND(AVG(t.amount),2) AS avg_spend, COUNT(t.id) AS total_transactions,
TIMESTAMPDIFF( MONTH, MIN(c.acct_open_date), MAX(t.date)) AS months_active
FROM users_data u
JOIN cards_data c ON u.id = c.client_id
JOIN transactions_data t ON u.id = t.client_id
GROUP BY u.id
)
SELECT *, ROUND(total_transactions/NULLIF(months_active,0),2) AS transaction_frequency,
ROUND(total_spend * (total_transactions/NULLIF(months_active,0)) * months_active, 2) AS estimated_clv
FROM customer_metrics)
SELECT *,
RANK() OVER(ORDER BY estimated_clv DESC) AS customer_rank
FROM customer_clv;


-- DENSE RANK CUSTOMERS BY ESTIMATED CLV
WITH customer_clv AS(
WITH customer_metrics AS (
SELECT u.id, SUM(t.amount) AS total_spend, ROUND(AVG(t.amount),2) AS avg_spend, COUNT(t.id) AS total_transactions,
TIMESTAMPDIFF( MONTH, MIN(c.acct_open_date), MAX(t.date)) AS months_active
FROM users_data u
JOIN cards_data c ON u.id = c.client_id
JOIN transactions_data t ON u.id = t.client_id
GROUP BY u.id
)
SELECT *, ROUND(total_transactions/NULLIF(months_active,0),2) AS transaction_frequency,
ROUND(total_spend * (total_transactions/NULLIF(months_active,0)) * months_active, 2) AS estimated_clv
FROM customer_metrics)
SELECT *,
DENSE_RANK() OVER(ORDER BY estimated_clv DESC) AS customer_dense_rank
FROM customer_clv;


-- SEGMENT CUSTOMERS INTO CLV QUARTILES USING NTILE()
WITH customer_clv AS(
WITH customer_metrics AS (
SELECT u.id, SUM(t.amount) AS total_spend, ROUND(AVG(t.amount),2) AS avg_spend, COUNT(t.id) AS total_transactions,
TIMESTAMPDIFF( MONTH, MIN(c.acct_open_date), MAX(t.date)) AS months_active
FROM users_data u
JOIN cards_data c ON u.id = c.client_id
JOIN transactions_data t ON u.id = t.client_id
GROUP BY u.id
)
SELECT *, ROUND(total_transactions/NULLIF(months_active,0),2) AS transaction_frequency,
ROUND(total_spend * (total_transactions/NULLIF(months_active,0)) * months_active, 2) AS estimated_clv
FROM customer_metrics)
SELECT *,
NTILE(4) OVER(ORDER BY estimated_clv DESC) AS customer_quartile
FROM customer_clv;


-- CUSTOMER CLV RANKING AND QUARTILE SEGMENTATION
WITH customer_metrics AS (
SELECT u.id, SUM(t.amount) AS total_spend, AVG(t.amount) AS avg_spend, COUNT(*) AS total_transactions, TIMESTAMPDIFF(MONTH, MIN(c.acct_open_date), MAX(t.date)) AS months_active
FROM users_data u
JOIN cards_data c ON u.id=c.client_id
JOIN transactions_data t ON u.id=t.client_id
GROUP BY u.id
),
customer_clv AS (
SELECT *,
ROUND(total_transactions/ NULLIF(months_active,0),2) AS transaction_frequency,
ROUND(total_spend*(total_transactions/NULLIF(months_active,0)),2) AS estimated_clv
FROM customer_metrics
)
SELECT *,
RANK() OVER(ORDER BY estimated_clv DESC) AS customer_rank,
NTILE(4) OVER(ORDER BY estimated_clv DESC) AS customer_segment
FROM customer_clv;