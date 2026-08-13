-- =============================================================
-- DATA SETUP
-- =============================================================


-- Drop database if it already exists

DROP DATABASE IF EXISTS CustomerAnalytics;


-- Create database

CREATE DATABASE CustomerAnalytics;


-- Use database

USE CustomerAnalytics;


-- Create Tables

DROP TABLE cards_data;

CREATE TABLE cards_data (
    id INT,
    client_id INT,
    card_brand VARCHAR(50),
    card_type VARCHAR(50),
    card_number VARCHAR(50),
    expires DATE,
    cvv INT,
    has_chip VARCHAR(50),
    num_cards_issued INT,
    credit_limit INT,
    acct_open_date DATE,
    year_pin_last_changed INT,
    card_on_dark_web VARCHAR(20)
);

DROP TABLE transactions_data ;

CREATE TABLE transactions_data (
    id INT,
    date DATE,
    client_id INT,
    card_id INT,
    amount DECIMAL(10,2),
    use_chip VARCHAR(50),
    merchant_id INT,
    merchant_city VARCHAR(50),
    merchant_state VARCHAR(50),
    zip INT,
    mcc INT,
    errors VARCHAR(255)
);

CREATE TABLE users_data (
    id INT,
    current_age INT,
    retirement_age INT,
    birth_year INT,
    birth_month INT,
    gender VARCHAR(50),
    address VARCHAR(50),
    per_capita_income INT,
    yearly_income INT,
    total_debt INT,
    credit_score INT,
    num_credit_cards INT
);


-- Load CSV Data

TRUNCATE TABLE cards_data;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cards_data.csv'
INTO TABLE cards_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(    id,
    client_id,
    card_brand,
    card_type,
    card_number,
    @expires,
    cvv,
    has_chip,
    num_cards_issued,
    credit_limit,
    @acct_open_date,
    year_pin_last_changed,
    card_on_dark_web
)
SET
acct_open_date = STR_TO_DATE(@acct_open_date,'%d-%m-%Y');

SHOW CREATE TABLE transactions_data;

TRUNCATE TABLE transactions_data;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions_data.csv'
INTO TABLE transactions_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
id,
@date,
client_id,
card_id,
amount,
use_chip,
merchant_id,
merchant_city,
merchant_state,
@zip,
@mcc,
@errors
)
SET
date = STR_TO_DATE(@date,'%d-%m-%Y'),
zip = NULLIF(@zip, ''),
mcc = NULLIF(@mcc, ''),
errors = NULLIF(@errors, '');


TRUNCATE TABLE users_data;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_data.csv'
INTO TABLE users_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    current_age,
    retirement_age,
    birth_year,
    birth_month,
    gender,
    address,
    per_capita_income,
    yearly_income,
    total_debt,
    credit_score,
    num_credit_cards
);


