-- ============================================================
-- Maven Café | Views (Abstraction Layer)
-- Description: SQL Views serving as Single Source of Truth for Power BI
-- ============================================================

-- ------------------------------------------------------------
-- View 1: customers_clean
-- Adds age / income / membership tenure bins per customer
-- Excludes age=118 (invalid records with missing demographics)
-- ------------------------------------------------------------
ALTER VIEW customers_clean AS
WITH cte_age_bins AS (
    SELECT *,
        FLOOR(age / 10) * 10                                                         AS age_index,
        CAST(FLOOR(age / 10) * 10 AS VARCHAR) + '-'
            + CAST(FLOOR(age / 10) * 10 + 9 AS VARCHAR)                             AS age_bin
    FROM customers
),
cte_income AS (
    SELECT *,
        FLOOR(income / 10000) * 10000                                                AS income_index,
        CAST(FLOOR(income / 10000) * 10000 AS VARCHAR) + '-'
            + CAST(FLOOR(income / 10000) * 10000 + 9000 AS VARCHAR)                 AS income_bin
    FROM customers
),
cte_membership AS (
    SELECT *,
        FLOOR(DATEDIFF(day, c.became_member_on, '2018-07-26') / 365.0)              AS membership_index,
        'Year ' + CAST(
            FLOOR(DATEDIFF(day, c.became_member_on, '2018-07-26') / 365.0) + 1
        AS VARCHAR)                                                                  AS membership_bin
    FROM customers c
)
SELECT
    a.*,
    b.income_index,
    b.income_bin,
    c.membership_index,
    c.membership_bin
FROM cte_age_bins a
JOIN cte_income    b ON a.customer_id = b.customer_id
JOIN cte_membership c ON a.customer_id = c.customer_id
WHERE a.age != 118;
-- Note: age=118 records have NULL gender/income and are excluded (2,175 rows)


-- ------------------------------------------------------------
-- View 2: max_complete_clients
-- Top-performing customers: completed all 6 available offers
-- Used for target audience analysis (Q1)
-- ------------------------------------------------------------
ALTER VIEW max_complete_clients AS
WITH cte_bestclients AS (
    SELECT e.customer_id,
           COUNT(e.offerId) AS tot_offers_completed
    FROM events_clean e
    WHERE e.event = 'offer completed'
    GROUP BY e.customer_id
    HAVING COUNT(e.offerId) = 6
)
SELECT *
FROM customers_clean
WHERE customer_id IN (SELECT customer_id FROM cte_bestclients);


-- ------------------------------------------------------------
-- View 3: completed_offers
-- Revenue per offer based on completions × difficulty
-- ------------------------------------------------------------
CREATE VIEW completed_offers AS
WITH cte_completed_offers AS (
    SELECT e.offerId,
           COUNT(e.customer_id) AS tot_cus
    FROM events_clean e
    WHERE e.event = 'offer completed'
    GROUP BY e.offerId
)
SELECT *,
    c.tot_cus * o.difficulty AS revenue
FROM cte_completed_offers c
JOIN offers o ON o.offer_id = c.offerId
WHERE o.offer_id IN (SELECT offerId FROM cte_completed_offers)
ORDER BY revenue DESC;


-- ------------------------------------------------------------
-- View 4: offer_results
-- Conversion funnel data bucketed by time windows
-- Time bins (hours → campaign day equivalent):
--   <168h  = Day 7  | <336h = Day 14 | <408h = Day 17
--   <504h  = Day 21 | <576h = Day 24 | ≥576h = Day 30
-- ------------------------------------------------------------
CREATE VIEW offer_results AS
WITH cte_timebin AS (
    SELECT *,
        CASE
            WHEN time < 168  THEN 7
            WHEN time < 336  THEN 14
            WHEN time < 408  THEN 17
            WHEN time < 504  THEN 21
            WHEN time < 576  THEN 24
            WHEN time >= 576 THEN 30
        END AS timepassed
    FROM events_clean
)
SELECT
    c.offerId,
    c.timepassed,
    c.event,
    COUNT(c.customer_id) AS total_customers
FROM cte_timebin c
GROUP BY c.offerId, c.timepassed, c.event;
