-- =============================================================
-- Customer Demographics
-- =============================================================

-- Age Analysis

SELECT AVG(current_age) AS average_age, MIN(current_age) AS youngest_customer, MAX(current_age) AS oldest_customer
FROM users_data;

SELECT 
CASE 
	WHEN current_age < 41 THEN "18-40" 
    WHEN current_age BETWEEN 41 AND 60 THEN "41-60"
    ELSE "60+"
    END AS age_group,
    COUNT(DISTINCT id) AS count_in_age_group, ROUND(COUNT(DISTINCT id) *100 /(SELECT COUNT(DISTINCT id) FROM users_data),2) AS percentage_count_in_age_group
    FROM users_data
    GROUP BY age_group;
    
-- Income Analysis

SELECT AVG(per_capita_income) AS average_per_capita_income, MIN(per_capita_income) AS lowest_per_capita_income, MAX(per_capita_income) AS highest_per_capita_income
FROM users_data;

SELECT 
CASE 
	WHEN per_capita_income < 25000 THEN "low" 
    WHEN per_capita_income BETWEEN 25000 AND 49999 THEN "middle"
    WHEN per_capita_income BETWEEN 50000 AND 74999 THEN "upper middle"
    WHEN per_capita_income BETWEEN 75000 AND 100000 THEN "high"
    ELSE "very high"
    END AS income_group,
    COUNT(DISTINCT id) AS count_in_income_group, ROUND(COUNT(DISTINCT id) *100 /(SELECT COUNT(DISTINCT id) FROM users_data),2) AS percentage_count_in_income_group
    FROM users_data
    GROUP BY income_group
    ORDER BY count_in_income_group DESC;

-- Credit Score Analysis

SELECT AVG(credit_score) AS average_credit_score, MIN(credit_score) AS lowest_credit_score, MAX(credit_score) AS highest_credit_score
FROM users_data;

SELECT 
CASE 
	WHEN credit_score < 580 THEN "poor"
     WHEN credit_score BETWEEN 580 AND 669 THEN "fair"
    WHEN credit_score BETWEEN 670 AND 739 THEN "good"
    WHEN credit_score BETWEEN 740 AND 799 THEN "very good"
    ELSE "excellent"
    END AS credit_score_groups,
    COUNT(DISTINCT id) AS count_in_credit_score_groups, ROUND(COUNT(DISTINCT id) *100 /(SELECT COUNT(DISTINCT id) FROM users_data),2) AS percentage_count_in_credit_score_groups
    FROM users_data
    GROUP BY credit_score_groups
    ORDER BY count_in_credit_score_groups DESC;

-- Data Analysis

SELECT ROUND(AVG(total_debt),2) AS avg_debt, MIN(total_debt) AS min_debt, MAX(total_debt) AS max_debt, ROUND(STDDEV(total_debt),2) AS std_debt
FROM users_data;

SELECT
CASE
WHEN total_debt < 5000 THEN 'Below 5K'
WHEN total_debt BETWEEN 5000 AND 9999 THEN '5K - 10K'
WHEN total_debt BETWEEN 10000 AND 24999 THEN '10K - 25K'
WHEN total_debt BETWEEN 25000 AND 49999 THEN '25K - 50K'
ELSE '50K+'
END AS debt_range,
    COUNT(DISTINCT id) AS customers, ROUND(COUNT(DISTINCT id) *100 /(SELECT COUNT(DISTINCT id) FROM users_data),2) AS customer_percentage
FROM users_data
GROUP BY debt_range
ORDER BY customers DESC;


SELECT id, total_debt
FROM users_data
ORDER BY total_debt DESC
LIMIT 10;

SELECT gender, ROUND(AVG(total_debt),2) AS avg_debt
FROM users_data
GROUP BY gender;

SELECT 
CASE
WHEN current_age < 30 THEN '18-29'
WHEN current_age BETWEEN 30 AND 44 THEN '30-44'
WHEN current_age BETWEEN 45 AND 59 THEN '45-59'
ELSE '60+'
END AS age_group,
ROUND(AVG(total_debt),2) AS avg_debt
FROM users_data
GROUP BY age_group
ORDER BY avg_debt DESC;

SELECT id, yearly_income, total_debt, ROUND((total_debt / yearly_income) * 100,2) AS debt_income_ratio
FROM users_data;

SELECT id, yearly_income, total_debt, ROUND((total_debt / yearly_income) * 100,2) AS debt_income_ratio,
CASE
WHEN (total_debt / yearly_income) < 0.20 THEN 'Low Risk'
WHEN (total_debt / yearly_income) < 0.40 THEN 'Moderate Risk'
WHEN (total_debt / yearly_income) < 0.60 THEN 'High Risk'
ELSE 'Very High Risk'
END AS risk_category
FROM users_data;

SELECT 
CASE
WHEN (total_debt / yearly_income) < 0.20 THEN 'Low Risk'
WHEN (total_debt / yearly_income) < 0.40 THEN 'Moderate Risk'
WHEN (total_debt / yearly_income) < 0.60 THEN 'High Risk'
ELSE 'Very High Risk'
END AS risk_category,
COUNT(DISTINCT id) AS customers
FROM users_data
GROUP BY risk_category
ORDER BY customers DESC;

SELECT id, yearly_income, total_debt
FROM users_data
WHERE total_debt > yearly_income;

SELECT COUNT(DISTINCT id) 
FROM users_data
WHERE total_debt > yearly_income;

