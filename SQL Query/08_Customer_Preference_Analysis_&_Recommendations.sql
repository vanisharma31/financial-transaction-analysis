-- =============================================================
-- Customer Preference Analysis 
-- =============================================================


-- MOST PREFERRED MERCHANT 
WITH merchant_rank AS(
SELECT client_id, merchant_id, COUNT(*) AS visits,
ROW_NUMBER() OVER(PARTITION BY client_id ORDER BY COUNT(*) DESC) AS rn
FROM transactions_data
GROUP BY client_id, merchant_id
)
SELECT client_id, merchant_id, visits
FROM merchant_rank
WHERE rn=1;


-- PREFERRED MERCHANT CATEGORY
WITH mcc_rank AS(
SELECT client_id, mcc, COUNT(*) AS transactions,
ROW_NUMBER() OVER(PARTITION BY client_id ORDER BY COUNT(*) DESC) AS rn
FROM transactions_data
GROUP BY client_id,mcc
)
SELECT *
FROM mcc_rank
WHERE rn=1;


-- PREFERRED SHOPPING CITY 
WITH city_rank AS(
SELECT client_id, merchant_city, COUNT(*) AS visits,
ROW_NUMBER() OVER(PARTITION BY client_id ORDER BY COUNT(*) DESC) rn
FROM transactions_data
GROUP BY client_id,merchant_city
)
SELECT *
FROM city_rank
WHERE rn=1;


-- HIGH SPENDING CUSTOMERS
SELECT client_id, SUM(amount) total_spending
FROM transactions_data
GROUP BY client_id
ORDER BY total_spending DESC
LIMIT 20;


-- SIMILAR CUSTOMERS
WITH spending AS(
SELECT client_id, SUM(amount) total_spending
FROM transactions_data
GROUP BY client_id
)
SELECT client_id, total_spending,
NTILE(4) OVER(ORDER BY total_spending DESC) spending_group
FROM spending;

-- CUSTOMER INTEREST PROFILE
WITH spending AS (
SELECT client_id, SUM(amount) AS total_spending, 
NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS spending_group
FROM transactions_data
GROUP BY client_id
),
merchant_rank AS (
SELECT client_id, merchant_id,
ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY COUNT(*) DESC) AS rn
FROM transactions_data
GROUP BY client_id, merchant_id
),
city_rank AS (
SELECT client_id, merchant_city,
ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY COUNT(*) DESC) AS rn
FROM transactions_data
GROUP BY client_id, merchant_city
),
mcc_rank AS (
SELECT client_id, mcc, ROW_NUMBER() OVER (PARTITION BY client_id ORDER BY COUNT(*) DESC) AS rn
FROM transactions_data
GROUP BY client_id, mcc
)
SELECT s.client_id, s.total_spending,
CASE
WHEN s.spending_group = 1 THEN 'High Spender'
WHEN s.spending_group = 2 THEN 'Medium-High'
WHEN s.spending_group = 3 THEN 'Medium'
ELSE 'Budget'
END AS spending_segment, 
mr.merchant_id AS preferred_merchant,
cr.merchant_city AS preferred_city,
mc.mcc AS preferred_mcc
FROM spending s
LEFT JOIN merchant_rank mr ON s.client_id = mr.client_id AND mr.rn = 1
LEFT JOIN city_rank cr ON s.client_id = cr.client_id AND cr.rn = 1
LEFT JOIN mcc_rank mc ON s.client_id = mc.client_id AND mc.rn = 1
ORDER BY total_spending DESC;

