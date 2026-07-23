-- =============================================================
-- Customer Spending Analysis
-- =============================================================

SELECT u.id, SUM(t.amount) AS total_spending, AVG(t.amount) AS average_transaction, COUNT( t.id) AS no_of_transactions, MAX(ABS(t.amount)) AS largest_transaction 
FROM users_data u
JOIN transactions_data t ON u.id=t.client_id
GROUP BY u.id
ORDER BY u.id;

SELECT DATE_FORMAT(date,'%M %Y') AS month, ROUND(SUM(amount),2) AS monthly_spending
FROM transactions_data
GROUP BY DATE_FORMAT(date,'%Y-%m'), DATE_FORMAT(date,'%M %Y')
ORDER BY MIN(date);

SELECT date, ROUND(SUM(amount),2) AS daily_spending
FROM transactions_data
GROUP BY date
ORDER BY date;

SELECT date, SUM(amount) AS daily_spending, LAG(SUM(amount)) OVER(ORDER BY date) AS previous_day
FROM transactions_data
GROUP BY date
ORDER BY date;

SELECT date, SUM(amount) AS daily_spending, SUM(amount) - LAG(SUM(amount)) OVER(ORDER BY date) AS change_from_previous_day
FROM transactions_data
GROUP BY date
ORDER BY date;

SELECT date, SUM(amount) AS daily_spending, LEAD(SUM(amount)) OVER(ORDER BY date) AS next_day
FROM transactions_data
GROUP BY date
ORDER BY date;

SELECT DATE_FORMAT(date,'%Y-%m') AS month, SUM(amount) AS monthly_spending, SUM(SUM(amount)) OVER(ORDER BY DATE_FORMAT(date,'%Y-%m')) AS running_total
FROM transactions_data
GROUP BY DATE_FORMAT(date,'%Y-%m')
ORDER BY month;

SELECT DATE_FORMAT(date,'%Y-%m') AS month, SUM(amount) AS monthly_spending, SUM(SUM(amount)) OVER(ORDER BY DATE_FORMAT(date,'%Y-%m')) AS running_total
FROM transactions_data
GROUP BY DATE_FORMAT(date,'%Y-%m')
ORDER BY month;

WITH monthly AS (
SELECT DATE_FORMAT(date,'%Y-%m') AS month, SUM(amount) AS spending
FROM transactions_data
GROUP BY DATE_FORMAT(date,'%Y-%m')
)
SELECT month, spending, LAG(spending) OVER(ORDER BY month) AS previous_month, ROUND(((spending-LAG(spending) OVER(ORDER BY month))/LAG(spending) OVER(ORDER BY month))*100,2) AS growth_percentage

FROM monthly;
