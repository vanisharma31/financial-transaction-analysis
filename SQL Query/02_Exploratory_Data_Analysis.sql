-- =============================================================
-- EXPLORATORY DATA ANALYSIS (EDA) 
-- =============================================================

-- CUSTOMER OVERVIEW

SELECT COUNT(DISTINCT id)
FROM users_data;

SELECT gender, COUNT(DISTINCT id)
FROM users_data
GROUP BY gender;

SELECT AVG(current_age)
FROM users_data;

SELECT AVG(per_capita_income), AVG(yearly_income)
FROM users_data;

SELECT gender, AVG(per_capita_income), AVG(yearly_income)
FROM users_data
GROUP BY gender;

SELECT AVG(total_debt)
FROM users_data;

SELECT gender, AVG(total_debt)
FROM users_data
GROUP BY gender;

SELECT AVG(credit_score)
FROM users_data;

SELECT gender, AVG(credit_score)
FROM users_data
GROUP BY gender;


-- CARD OVERVIEW

SELECT COUNT(DISTINCT id)
FROM cards_data;

SELECT card_brand, COUNT(DISTINCT id) AS total_cards, Round( COUNT(DISTINCT id) * 100.0 /(SELECT COUNT(DISTINCT id) FROM cards_data),2) AS percentage
FROM cards_data
GROUP BY card_brand;

SELECT card_type, COUNT(DISTINCT id) AS total_cards, Round( COUNT(DISTINCT id) * 100.0 /(SELECT COUNT(DISTINCT id) FROM cards_data),2) AS percentage
FROM cards_data
GROUP BY card_type;


SELECT has_chip, COUNT(DISTINCT id) AS total, COUNT(DISTINCT ID)*100/(SELECT COUNT(DISTINCT id) FROM cards_data)
FROM cards_data
GROUP BY has_chip;

SELECT Max(credit_limit), MIN(credit_limit)
FROM cards_data;


-- TRANSACTION OVERVIEW

SELECT COUNT(DISTINCT id)
FROM transactions_data;

SELECT SUM(amount), AVG(amount), MAX(amount), MIN(amount)
FROM transactions_data;




 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

