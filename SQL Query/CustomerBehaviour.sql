-- =============================================================
-- Customer Behaviour Analysis
-- =============================================================


-- MOST ACTIVE CUSTOMERS
-- By Transaction 
SELECT client_id, COUNT(*) AS total_transactions
FROM transactions_data
GROUP BY client_id
ORDER BY total_transactions DESC
LIMIT 10;

-- By Total Spending
SELECT client_id, ROUND(SUM(amount),2) AS total_spending
FROM transactions_data
GROUP BY client_id
ORDER BY total_transactions DESC
LIMIT 10;


-- HIGHEST SPENDING MONTH 
SELECT DATE_FORMAT(date,'%M %Y') AS month, ROUND(SUM(amount),2) AS total_spending
FROM transactions_data
GROUP BY DATE_FORMAT(date,'%Y-%m'), DATE_FORMAT(date,'%M %Y')
ORDER BY total_spending DESC
LIMIT 1;


-- PREFERRED MERCHANT CITY 
SELECT merchant_city, COUNT(*) AS transactions, ROUND(SUM(amount),2) AS total_spending
FROM transactions_data
GROUP BY merchant_city
ORDER BY total_spending DESC;


-- CUSTOMER  FAVOURITE CITY
WITH city_rank AS(
SELECT client_id, merchant_city, COUNT(*) AS visits, 
ROW_NUMBER() OVER(PARTITION BY client_id ORDER BY COUNT(*) DESC) AS rn
FROM transactions_data
GROUP BY client_id, merchant_city
)
SELECT *
FROM city_rank
WHERE rn = 1;


-- PREFERRED MERCHANT 
SELECT merchant_id, COUNT(*) AS visits, ROUND(SUM(amount),2) AS total_spending
FROM transactions_data
GROUP BY merchant_id
ORDER BY visits DESC;


-- MOST FREQUENTLY VISITED MERCHANT FOR EACH CUSTOMER
WITH merchant_rank AS (
SELECT client_id, merchant_id, COUNT(*) AS visits, 
ROW_NUMBER() OVER(PARTITION BY client_id ORDER BY COUNT(*) DESC) AS rn
FROM transactions_data
GROUP BY client_id, merchant_id
)
SELECT *
FROM merchant_rank
WHERE rn = 1;
 
 
-- PREFERRED MERCHANT CATEGORY
SELECT mcc, COUNT(*) AS total_transactions, ROUND(SUM(amount),2) AS total_spending
FROM transactions_data
GROUP BY mcc
ORDER BY total_transactions DESC;


-- WEEKEND VS WEEKDAY SPENDING
SELECT
CASE 
WHEN DAYOFWEEK(date) IN (1,7) THEN 'Weekend'
ELSE 'Weekday'
END AS day_type,
COUNT(*) AS transactions,
ROUND(SUM(amount),2) AS total_spending,
ROUND(AVG(amount),2) AS avg_transaction
FROM transactions_data
GROUP BY day_type;


-- CHIP VS SWIPE USAGE 
SELECT use_chip, COUNT(*) AS total_transactions, ROUND(SUM(amount),2) AS total_spending
FROM transactions_data
GROUP BY use_chip;


-- CREDIT VS DEBIT USAGE
SELECT c.card_type, COUNT(*) AS total_transactions, ROUND(SUM(t.amount),2) AS total_spending
FROM transactions_data t
JOIN cards_data c ON t.card_id = c.id
GROUP BY c.card_type;


-- AVERAGE TRANSACTION VALUE  
SELECT c.card_type, COUNT(*) AS transactions, ROUND(AVG(t.amount),2) AS avg_transaction,ROUND(SUM(t.amount),2) AS total_spending
FROM transactions_data t
JOIN cards_data c ON t.card_id = c.id
GROUP BY c.card_type;


-- TRANSACTION ERRORS 
SELECT errors, COUNT(*) AS occurrences
FROM transactions_data
WHERE errors IS NOT NULL
GROUP BY errors
ORDER BY occurrences DESC;



