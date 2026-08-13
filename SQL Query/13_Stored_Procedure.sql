-- =============================================================
-- Stored Procedures
-- =============================================================


-- CUSTOMER PROFILE
DELIMITER $$
CREATE PROCEDURE GetCustomerProfile(IN p_customer_id INT)
BEGIN
SELECT u.current_age, u.gender, u.yearly_income, u.credit_score, u.total_debt, u.num_credit_cards,
c.card_brand, c.card_type, c.credit_limit,
SUM(t.amount) AS total_spending, COUNT(t.id) AS total_transactions, ROUND(AVG(t.amount),2) AS avg_transaction
FROM users_data u
LEFT JOIN cards_data c ON u.id=c.client_id
LEFT JOIN transactions_data t ON u.id=t.client_id
WHERE u.id=p_customer_id
GROUP BY u.id, u.gender, u.yearly_income, u.credit_score, u.total_debt, u.num_credit_cards,
		 c.card_brand, c.card_type, c.credit_limit;
END $$
DELIMITER ;


-- CUSTOMER TRANSACTIONS
DELIMITER $$
CREATE PROCEDURE CustomerTransactions(IN p_customer_id INT)
BEGIN
SELECT date, amount, merchant_id, merchant_city, merchant_state, mcc, use_chip, errors
FROM transactions_data
WHERE client_id=p_customer_id
ORDER BY date DESC;
END $$
DELIMITER ;


-- GET TOP CUSTOMERS
DELIMITER $$
CREATE PROCEDURE GetTopCustomers(IN p_limit INT)
BEGIN
SELECT
client_id,
SUM(amount) total_spending,
COUNT(*) total_transactions,
ROUND(AVG(amount),2) avg_transaction
FROM transactions_data
GROUP BY client_id
ORDER BY total_spending DESC
LIMIT p_limit;
END $$
DELIMITER ;


-- CUSTOMER SEGMENT 
DELIMITER $$
CREATE PROCEDURE CustomerSegment()
BEGIN
WITH spending AS(
SELECT u.id, u.yearly_income, u.credit_score, u.total_debt, SUM(t.amount) total_spending
FROM users_data u 
JOIN transactions_data t ON u.id=t.client_id
GROUP BY u.id, u.yearly_income, u.credit_score, u.total_debt
)
SELECT *,
CASE
WHEN yearly_income>=100000 AND total_spending>=50000 THEN 'VIP'
WHEN credit_score>=750 AND total_spending>=30000 THEN 'Premium'
WHEN total_debt>yearly_income*0.5AND credit_score<600 THEN 'Risk'
WHEN total_spending<10000 THEN 'Budget'
ELSE 'Regular'
END customer_segment
FROM spending;
END $$
DELIMITER ;


-- Customer CLV
DELIMITER $$
CREATE PROCEDURE CustomerCLV()
BEGIN
WITH card_info AS (
SELECT client_id, MIN(acct_open_date) AS account_open_date
FROM cards_data
GROUP BY client_id
    ),
metrics AS (
SELECT u.id,
SUM(t.amount) AS total_spending,
COUNT(t.id) AS total_transactions,
TIMESTAMPDIFF(MONTH, c.account_open_date, MAX(t.date)) AS months_active
FROM users_data u
JOIN transactions_data t ON u.id = t.client_id
LEFT JOIN card_info c ON u.id = c.client_id
GROUP BY u.id, c.account_open_date
)
SELECT id, ROUND(total_spending, 2) AS total_spending, total_transactions, months_active,
ROUND(total_transactions / NULLIF(months_active, 0),2) AS transaction_frequency,
ROUND((total_spending /NULLIF(months_active, 0)) * 12,2) AS estimated_clv,
RANK() OVER (ORDER BY(total_spending / NULLIF(months_active, 0)) * 12 DESC) AS customer_rank
FROM metrics
ORDER BY customer_rank;
END $$
DELIMITER ;

