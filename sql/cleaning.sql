-- ============================================================
-- Maven Café | Data Cleaning
-- Description: Parse JSON fields, fix data types, filter invalid records
-- ============================================================

-- Parse nested JSON fields from the events table
CREATE OR ALTER VIEW events_clean AS
SELECT *,
    JSON_VALUE(REPLACE(REPLACE(value, CHAR(39), '"'), 'offer id', 'offer_id'), '$.offer_id') AS offerId,
    CAST(JSON_VALUE(REPLACE(value, CHAR(39), '"'), '$.amount') AS FLOAT)                     AS trans_amount,
    CAST(JSON_VALUE(REPLACE(value, CHAR(39), '"'), '$.reward') AS FLOAT)                     AS reward
FROM events;
GO

-- ============================================================
-- Exploratory checks
-- ============================================================

-- Check date range of members
SELECT DISTINCT c.became_member_on
FROM customers c
ORDER BY became_member_on DESC;

-- Total customers
SELECT * FROM customers;
-- Result: 17,000 rows

-- Gender distribution (reveals 2,175 NULLs + 212 'Other')
SELECT gender, COUNT(customer_id) AS tot_cust
FROM customers
GROUP BY gender;

-- Age range check (min=18, max=118, no NULLs)
SELECT DISTINCT c.age
FROM customers c
ORDER BY c.age;

-- Confirm all age=118 records have NULL gender/income (2,175 records)
SELECT age, COUNT(customer_id) AS tot_cust, COUNT(gender) AS gender_count, COUNT(income) AS income_count
FROM customers
WHERE gender IS NULL
GROUP BY age
ORDER BY tot_cust DESC;
