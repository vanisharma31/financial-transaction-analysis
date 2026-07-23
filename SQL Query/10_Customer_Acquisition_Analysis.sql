-- =============================================================
-- Customer Acquisition Analysis
-- =============================================================


-- FIRST ACCOUNT OPEN DATE PER CUSTOMER
WITH customer_acquisition AS (
SELECT client_id, MIN(acct_open_date) AS first_account_date
FROM cards_data
GROUP BY client_id
)
SELECT *
FROM customer_acquisition;


-- CUSTOMERS ACQUIRED PER YEAR
WITH customer_acquisition AS (
SELECT client_id, MIN(acct_open_date) AS first_account_date
FROM cards_data
GROUP BY client_id
)
SELECT YEAR(first_account_date) AS year, COUNT(*) AS new_customers
FROM customer_acquisition
GROUP BY YEAR(first_account_date)
ORDER BY year;


-- CUSTOMERS ACCQUIRED PER MONTH 
WITH customer_acquisition AS (
SELECT client_id, MIN(acct_open_date) AS first_account_date
FROM cards_data
GROUP BY client_id
)
SELECT
DATE_FORMAT(first_account_date,'%Y-%m') AS month,
COUNT(*) AS new_customers
FROM customer_acquisition
GROUP BY DATE_FORMAT(first_account_date,'%Y-%m')
ORDER BY month;


-- MONTHLY GROWTH RATE
WITH monthly_acquisition AS (
SELECT DATE_FORMAT(MIN(acct_open_date),'%Y-%m') AS month,
COUNT(DISTINCT client_id) AS new_customers
FROM cards_data
GROUP BY DATE_FORMAT(acct_open_date,'%Y-%m')
)
SELECT month, new_customers, 
LAG(new_customers) OVER(ORDER BY month) AS previous_month,
ROUND(((new_customers-LAG(new_customers) OVER(ORDER BY month))/LAG(new_customers) OVER(ORDER BY month))*100,2) AS growth_rate
FROM monthly_acquisition;


-- RUNNING TOTAL OF CUSTOMERS
WITH customer_acquisition AS (
SELECT client_id, MIN(acct_open_date) first_account_date
FROM cards_data
GROUP BY client_id
)
SELECT DATE_FORMAT(first_account_date,'%Y-%m') month,
COUNT(*) new_customers,
SUM(COUNT(*)) OVER(ORDER BY DATE_FORMAT(first_account_date,'%Y-%m')) cumulative_customers
FROM customer_acquisition
GROUP BY month;


-- ACQUISITION BY CARD BRAND 
SELECT card_brand, COUNT(DISTINCT client_id) customers
FROM cards_data
GROUP BY card_brand
ORDER BY customers DESC;


-- ACQUISITION BY CARD TYPE 
SELECT card_type, COUNT(DISTINCT client_id) customers
FROM cards_data
GROUP BY card_type
ORDER BY customers DESC;


-- GROWTH ANAYLSIS 
WITH customer_acquisition AS (
SELECT client_id, MIN(acct_open_date) first_account_date
FROM cards_data
GROUP BY client_id
),
monthly AS (
SELECT DATE_FORMAT(first_account_date,'%Y-%m') month,
COUNT(*) new_customers
FROM customer_acquisition
GROUP BY month
)
SELECT month, new_customers, SUM(new_customers) OVER(
ORDER BY month
) cumulative_customers, 
LAG(new_customers) OVER(ORDER BY month) previous_month,
ROUND(((new_customers-LAG(new_customers) OVER(ORDER BY month))/LAG(new_customers) OVER(ORDER BY month))*100,2) growth_rate
FROM monthly;








