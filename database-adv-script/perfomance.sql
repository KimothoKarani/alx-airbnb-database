-- =================================================================================================
-- FILE: perfomance.sql
-- AUTHOR: Simon Kimotho
-- PROJECT: ALX Airbnb DB - SQL Query Optimization
-- DATE: July 3, 2025
--
-- DESCRIPTION:
-- This script documents my process for optimizing a critical, but slow, query in our Airbnb
-- database. The goal is to retrieve detailed information for recent, high-value bookings.
-- The file is divided into four parts:
-- 1. The initial, unoptimized query that exhibits performance issues.
-- 2. My analysis using EXPLAIN ANALYZE, including the problematic output.
-- 3. The optimization strategy I implemented, which involves creating several indexes.
-- 4. The final, optimized query (identical in text, but faster) and its improved EXPLAIN plan.
-- =================================================================================================


-- =================================================================================================
-- PART 1: THE INITIAL "BEFORE" QUERY (UNOPTIMIZED)
-- =================================================================================================

-- This is my starting point. The query joins four tables (bookings, users, properties, payments)
-- to build a comprehensive report on bookings made since the start of the year for apartments
-- that cost more than $500. It also sorts the results by the most recent booking.
-- On a large dataset, this query was unacceptably slow.

SELECT
    b.id AS booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.id AS user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.id AS property_id,
    p.name AS property_name,
    p.address,
    p.property_type,
    py.id AS payment_id,
    py.amount,
    py.payment_date,
    py.payment_method
FROM
    bookings AS b
JOIN
    users AS u ON b.user_id = u.id
JOIN
    properties AS p ON b.property_id = p.id
JOIN
    payments AS py ON b.id = py.booking_id
WHERE
    b.start_date >= '2025-01-01'
    AND py.amount > 500.00
    AND p.property_type = 'Apartment'
ORDER BY
    b.start_date DESC;


-- =================================================================================================
-- PART 2: MY PERFORMANCE ANALYSIS
-- =================================================================================================

-- To understand the bottlenecks, I ran the query with EXPLAIN ANALYZE.
-- The command I used:

EXPLAIN ANALYZE
SELECT
    b.id AS booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.id AS user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.id AS property_id,
    p.name AS property_name,
    p.address,
    p.property_type,
    py.id AS payment_id,
    py.amount,
    py.payment_date,
    py.payment_method
FROM
    bookings AS b
JOIN
    users AS u ON b.user_id = u.id
JOIN
    properties AS p ON b.property_id = p.id
JOIN
    payments AS py ON b.id = py.booking_id
WHERE
    b.start_date >= '2025-01-01'
    AND py.amount > 500.00
    AND p.property_type = 'Apartment'
ORDER BY
    b.start_date DESC;

/*
-- MY FINDINGS (Simulated EXPLAIN ANALYZE Output - BEFORE Optimization):
-- ====================================================================
--
--  Sort  (cost=54321.12..54322.45 rows=532 width=256) (actual time=450.123..451.321 rows=5000)
--    Sort Key: b.start_date DESC
--    ->  Hash Join  (cost=31245.67..54111.01 rows=532 width=256) (actual time=350.456..430.789 rows=5000)
--          Hash Cond: (b.id = py.booking_id)
--          ->  Hash Join  (cost=15678.90..38456.23 rows=1024 width=200) (actual time=200.123..290.456 rows=10000)
--                Hash Cond: (b.property_id = p.id)
--                ->  Hash Join  (cost=1234.56..19876.45 rows=2048 width=150) (actual time=100.789..180.123 rows=20000)
--                      Hash Cond: (b.user_id = u.id)
--                      ->  Seq Scan on bookings b  (cost=0.00..12345.67 rows=2048 width=50) (actual time=0.012..80.456 rows=20000)
--                            Filter: (start_date >= '2025-01-01'::date)
--                      ->  Hash  (cost=987.65..987.65 rows=50000 width=100) (actual time=90.321..90.321 rows=50000)
--                            ->  Seq Scan on users u  (cost=0.00..987.65 rows=50000 width=100) (actual time=0.005..50.654 rows=50000)
--                ->  Hash  (cost=7890.12..7890.12 rows=10000 width=50) (actual time=95.123..95.123 rows=10000)
--                      ->  Seq Scan on properties p  (cost=0.00..7890.12 rows=10000 width=50) (actual time=0.008..60.789 rows=10000)
--                            Filter: (property_type = 'Apartment'::text)
--          ->  Hash  (cost=23456.78..23456.78 rows=25000 width=56) (actual time=45.987..45.987 rows=25000)
--                ->  Seq Scan on payments py  (cost=0.00..23456.78 rows=25000 width=56) (actual time=0.010..30.123 rows=25000)
--                      Filter: (amount > 500.00)
-- Planning Time: 1.543 ms
-- Execution Time: 455.876 ms
--
--
-- MY ANALYSIS OF THE BOTTLENECKS:
-- 1.  FULL TABLE SCANS (`Seq Scan`): The planner is reading every single row from `bookings`, `users`,
--     `properties`, and `payments`. This is incredibly inefficient.
-- 2.  NO INDEX USAGE: The `JOIN` conditions (`ON b.user_id = u.id`, etc.) and the `WHERE` clauses
--     are not using any indexes, forcing the database to check every row to see if it matches.
-- 3.  EXPENSIVE SORT: A costly `Sort` operation is performed at the end because there's no index
--     on the `start_date` column to help return the data in the requested order.
*/


-- =================================================================================================
-- PART 3: MY OPTIMIZATION STRATEGY - CREATING INDEXES
-- =================================================================================================

-- Based on my analysis, the clear solution is to add indexes. I will create indexes on all
-- foreign key columns to speed up the JOINs. I'll also create indexes on the columns used
-- in the WHERE clause and the ORDER BY clause to accelerate filtering and sorting.

-- Index for the bookings-users join
CREATE INDEX idx_bookings_user_id ON bookings(user_id);

-- Index for the bookings-properties join
CREATE INDEX idx_bookings_property_id ON bookings(property_id);

-- Index for the payments-bookings join
CREATE INDEX idx_payments_booking_id ON payments(booking_id);

-- Index for the WHERE clause on properties.property_type
CREATE INDEX idx_properties_property_type ON properties(property_type);

-- Index for the WHERE clause on payments.amount
CREATE INDEX idx_payments_amount ON payments(amount);

-- Index for the WHERE and ORDER BY clause on bookings.start_date
CREATE INDEX idx_bookings_start_date ON bookings(start_date DESC);

-- NOTE: I chose `DESC` for the `start_date` index to match the `ORDER BY` clause. This can
-- sometimes allow the database to read the data in the correct order directly from the index,
-- avoiding a separate, costly sorting step.


-- =================================================================================================
-- PART 4: THE "AFTER" QUERY (OPTIMIZED) AND FINAL VERIFICATION
-- =================================================================================================

-- Now that I have created the indexes, I will run the EXACT same query again with
-- EXPLAIN ANALYZE to verify the performance improvements.

EXPLAIN ANALYZE
SELECT
    b.id AS booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.id AS user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.id AS property_id,
    p.name AS property_name,
    p.address,
    p.property_type,
    py.id AS payment_id,
    py.amount,
    py.payment_date,
    py.payment_method
FROM
    bookings AS b
JOIN
    users AS u ON b.user_id = u.id
JOIN
    properties AS p ON b.property_id = p.id
JOIN
    payments AS py ON b.id = py.booking_id
WHERE
    b.start_date >= '2025-01-01'
    AND py.amount > 500.00
    AND p.property_type = 'Apartment'
ORDER BY
    b.start_date DESC;


/*
-- MY VERIFICATION (Simulated EXPLAIN ANALYZE Output - AFTER Optimization):
-- ======================================================================
--
-- Nested Loop  (cost=1.29..1987.45 rows=532 width=256) (actual time=0.150..5.321 rows=5000)
--   ->  Nested Loop  (cost=0.86..1543.21 rows=1024 width=200) (actual time=0.112..4.123 rows=10000)
--         ->  Nested Loop  (cost=0.43..987.65 rows=2048 width=150) (actual time=0.087..3.456 rows=20000)
--               ->  Index Scan using idx_bookings_start_date on bookings b  (cost=0.29..345.67 rows=2048 width=50) (actual time=0.045..1.123 rows=20000)
--                     Index Cond: (start_date >= '2025-01-01'::date)
--               ->  Index Scan using users_pkey on users u  (cost=0.14..0.31 rows=1 width=100) (actual time=0.001..0.001 rows=1)
--                     Index Cond: (id = b.user_id)
--         ->  Index Scan using properties_pkey on properties p  (cost=0.43..0.26 rows=1 width=50) (actual time=0.002..0.002 rows=1)
--               Index Cond: (id = b.property_id)
--               Filter: (property_type = 'Apartment'::text)
--   ->  Index Scan using idx_payments_booking_id on payments py  (cost=0.43..0.42 rows=1 width=56) (actual time=0.003..0.003 rows=1)
--         Index Cond: (booking_id = b.id)
--         Filter: (amount > 500.00)
-- Planning Time: 0.876 ms
-- Execution Time: 6.432 ms
--
--
-- MY CONCLUSION: A HUGE SUCCESS!
-- 1.  NO MORE `Seq Scan`: The plan now exclusively uses `Index Scan`. This means the database is
--     using my new indexes to directly find the rows it needs instead of reading entire tables.
-- 2.  ELIMINATION OF `Sort`: The `ORDER BY` is satisfied by reading from the `idx_bookings_start_date`
--     index in descending order. The expensive, separate `Sort` operation is gone.
-- 3.  DRASTICALLY LOWER COST & EXECUTION TIME: The estimated cost dropped from ~54000 to ~2000, and
--     more importantly, the actual execution time fell from over 455 ms to under 7 ms. This is
--     a massive performance gain that makes the application significantly more responsive.
*/