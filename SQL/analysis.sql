-- ============================================================
-- Maven Café | Analysis Queries
-- Description: Business questions answered via SQL
-- ============================================================


-- ============================================================
-- Q1: Which customer segment responded best to the campaign?
-- ============================================================

-- Offers completed per offer type
SELECT o.offer_id, o.offer_type, COUNT(DISTINCT e.customer_id) AS num_of_clients
FROM offers o
JOIN events_clean e ON o.offer_id = e.offerId
WHERE e.event = 'offer completed'
GROUP BY o.offer_type, o.offer_id
ORDER BY num_of_clients DESC;

-- Top 200 customers: average age and income
SELECT AVG(age) AS avg_age, AVG(income) AS avg_income
FROM max_complete_clients;
-- Result: avg_income = 71,760 | avg_age = 56

-- Top 200 customers: gender breakdown
SELECT gender, COUNT(gender) AS total
FROM max_complete_clients
GROUP BY gender;
-- Result: Female=103, Male=93, Other=4

-- Top 200 customers: membership tenure distribution
SELECT m.membership_bin, COUNT(m.customer_id) AS tot_customers
FROM max_complete_clients m
GROUP BY m.membership_bin
ORDER BY tot_customers DESC;

-- Top 200 customers: age distribution
SELECT m.age_bin, COUNT(m.customer_id) AS tot_customers
FROM max_complete_clients m
GROUP BY m.age_bin
ORDER BY tot_customers DESC;

-- Top 200 customers: income distribution
SELECT m.income_bin, COUNT(m.customer_id) AS tot_customers
FROM max_complete_clients m
GROUP BY m.income_bin
ORDER BY tot_customers DESC;


-- ============================================================
-- Q2: Which campaign generated the highest revenue?
-- ============================================================

-- Revenue by offer (from completed_offers view)
SELECT *
FROM completed_offers
ORDER BY revenue DESC;

-- Total rewards paid out and total transaction volume
SELECT SUM(e.reward) AS tot_reward, SUM(e.trans_amount) AS tot_transactions
FROM events_clean e;
-- Result: Rewards = $164,676 | Transactions = $1,775,451.97


-- ============================================================
-- Q3: Conversion funnel — Offer Received → Completed
-- ============================================================

-- Total offers received
SELECT COUNT(e.customer_id) AS total_received
FROM events_clean e
WHERE e.event = 'offer received';
-- Result: 76,277

-- Total offers completed
SELECT COUNT(e.customer_id) AS total_completed
FROM events_clean e
WHERE e.event = 'offer completed';
-- Result: 33,579

-- Distinct vs total customers per offer (received)
SELECT e.offerId,
       COUNT(DISTINCT e.customer_id) AS distinct_customers,
       COUNT(e.customer_id)          AS total_received
FROM events_clean e
WHERE event = 'offer received'
GROUP BY e.offerId;

-- Distinct vs total customers per offer (completed)
SELECT e.offerId,
       COUNT(DISTINCT e.customer_id) AS distinct_customers,
       COUNT(e.customer_id)          AS total_completed
FROM events_clean e
WHERE event = 'offer completed'
GROUP BY e.offerId;

-- Conversion funnel by offer and time window (from offer_results view)
SELECT *
FROM offer_results
ORDER BY offerId, timepassed ASC, event DESC;

-- Distribution of offer send times (hours)
-- Time=0 → Day 1 | 168 → Day 8 | 336 → Day 15 | 408 → Day 18 | 504 → Day 22 | 576 → Day 25
SELECT offerId, time, COUNT(customer_id) AS customers_reached
FROM events_clean
WHERE event = 'offer received'
GROUP BY offerId, time
ORDER BY offerId, time;

-- Total transactions count
SELECT COUNT(e.customer_id) AS total_transactions
FROM events_clean e
WHERE e.trans_amount IS NOT NULL;
-- Result: 138,953 transactions
