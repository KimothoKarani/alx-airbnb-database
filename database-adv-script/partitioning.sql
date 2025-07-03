-- =======================================================================================
-- FILE: partitioning.sql
-- AUTHOR: Simon Kimotho
-- PROJECT: ALX Airbnb DB - Partitioning Large Tables
-- DATE: July 3, 2025
--
-- DESCRIPTION:
-- This script implements partitioning on the 'bookings' table to improve query
-- performance on this large and growing dataset. The partitioning strategy is
-- RANGE partitioning based on the 'start_date' column, with partitions created
-- for each calendar year.
--
-- STEPS:
-- 1. Create a new partitioned table named 'bookings_partitioned'.
-- 2. Define partitions for specific date ranges (e.g., for 2023, 2024, 2025).
-- 3. Copy data from the old 'bookings' table to the new partitioned table.
-- 4. Drop the old table and rename the new one to take its place.
-- =======================================================================================


-- STEP 1: Create the new partitioned table with the same structure as the original
-- We use PARTITION BY RANGE on the `start_date` column.

CREATE TABLE bookings_partitioned (
    id INT,
    user_id INT,
    property_id INT,
    start_date DATE NOT NULL,
    end_date DATE,
    total_price DECIMAL(10, 2),
    CONSTRAINT bookings_partitioned_pkey PRIMARY KEY (id, start_date) -- Partition key must be part of the primary key
) PARTITION BY RANGE (start_date);


-- STEP 2: Create partitions for specific date ranges.
-- This is where we define the boundaries for each partition. Queries filtering
-- by date will only scan the relevant partition(s).

CREATE TABLE bookings_y2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE bookings_y2024 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE bookings_y2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- It's good practice to create a default partition for values that don't fit
-- into the other partitions, though this is optional.
CREATE TABLE bookings_default PARTITION OF bookings_partitioned DEFAULT;


-- STEP 3: Migrate data from the old table into the new partitioned table.
-- The database will automatically route the rows to the correct partition.

INSERT INTO bookings_partitioned (id, user_id, property_id, start_date, end_date, total_price)
SELECT id, user_id, property_id, start_date, end_date, total_price FROM bookings;


-- STEP 4: Replace the old table with the new partitioned one.
-- This should be done within a transaction in a production environment
-- to minimize downtime.

-- BEGIN; -- Start transaction

DROP TABLE bookings;
ALTER TABLE bookings_partitioned RENAME TO bookings;

-- COMMIT; -- Commit transaction

-- After this, queries to the `bookings` table will automatically benefit from partitioning.
-- You can verify the partitions with \d+ bookings in psql.