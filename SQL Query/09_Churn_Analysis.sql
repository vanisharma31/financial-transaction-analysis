-- =============================================================
-- Customer Churn Analysis
-- =============================================================


-- LATEST TRANSACTION DATE IN THE DATASET 
SELECT MAX(date)
FROM transactions_data;


-- EACH CUSTOMER'S LAST TANSACTION 
SELECT client_id, MAX(date) AS last_transaction_date
FROM transactions_data
GROUP BY client_id


-- DAYS SINCE LAST TRANSACTION 
WITH last_transaction AS(
SELECT client_id, MAX(date) AS last_transaction_date
FROM transactions_data
GROUP BY client_id
)
SELECT client_id, last_transaction_date,
DATEDIFF((SELECT MAX(date) 
		  FROM transactions_data), last_transaction_date) AS days_inactive
FROM last_transaction;


-- CLASSIFY CUSTOMERS
WITH last_transaction AS(
SELECT client_id, MAX(date) AS last_transaction_date
FROM transactions_data
GROUP BY client_id
)
SELECT client_id, last_transaction_date,
DATEDIFF(
    (SELECT MAX(date)
     FROM transactions_data),
    last_transaction_date
) AS days_inactive,
CASE
WHEN DATEDIFF((SELECT MAX(date) 
               FROM transactions_data), last_transaction_date) <= 90 THEN 'Active'
WHEN DATEDIFF((SELECT MAX(date)
		       FROM transactions_data),last_transaction_date) BETWEEN 91 AND 180 THEN 'At Risk'
ELSE 'Churned'
END AS customer_status
FROM last_transaction;
 

-- CUSTOMER IN EACH SEGMENT
WITH churn AS (
SELECT client_id,
CASE
WHEN DATEDIFF((SELECT MAX(date)
			   FROM transactions_data),MAX(date)) <= 90 THEN 'Active'
WHEN DATEDIFF((SELECT MAX(date)
               FROM transactions_data),MAX(date)) <= 180 THEN 'At Risk'
ELSE 'Churned'
END AS customer_status
FROM transactions_data
GROUP BY client_id
)
SELECT customer_status, COUNT(*) AS customers
FROM churn
GROUP BY customer_status;


-- RANK CUSTOMER BY RISK
WITH churn AS( 
SELECT client_id, MAX(date) AS last_transaction_date,
DATEDIFF((SELECT MAX(date) 
          FROM transactions_data),MAX(date)) AS days_inactive,
CASE
WHEN DATEDIFF((SELECT MAX(date) 
               FROM transactions_data),MAX(date)) <= 90 THEN 'Active'
WHEN DATEDIFF((SELECT MAX(date) 
               FROM transactions_data), MAX(date)) BETWEEN 91 AND 180 THEN 'At Risk'   
ELSE 'Churned'
END AS customer_status
FROM transactions_data
GROUP BY client_id
)
SELECT client_id, last_transaction_date, days_inactive, customer_status,
RANK() OVER(ORDER BY days_inactive DESC) AS risk_rank
FROM churn
ORDER BY risk_rank;


-- Customer Detials 
WITH churn AS( 
SELECT client_id, MAX(date) AS last_transaction_date,
DATEDIFF((SELECT MAX(date) 
          FROM transactions_data),MAX(date)) AS days_inactive,
CASE
WHEN DATEDIFF((SELECT MAX(date) 
               FROM transactions_data),MAX(date)) <= 90 THEN 'Active'
WHEN DATEDIFF((SELECT MAX(date) 
               FROM transactions_data), MAX(date)) BETWEEN 91 AND 180 THEN 'At Risk'  
ELSE 'Churned'
END AS customer_status
FROM transactions_data
GROUP BY client_id
)
SELECT u.id, u.yearly_income, u.credit_score, u.total_debt, c.days_inactive, c.customer_status
FROM users_data u JOIN churn c ON u.id = c.client_id;

