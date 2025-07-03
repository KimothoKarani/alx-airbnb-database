-- =================================================================
-- ALX Airbnb Clone Project - Index Creation for Optimization
-- Description: This script creates indexes on high-usage columns
--              to improve query performance.
-- Author: Simon Kimotho
-- Date: July 3, 2025
-- =================================================================

-- Select the database to use
USE alx_airbnb;

-- -----------------------------------------------------
-- Indexes for the `User` Table
-- -----------------------------------------------------
-- An index on the `email` column is crucial for fast login lookups.
-- Note: A UNIQUE constraint already creates an index, but we define
-- it here explicitly for clarity.
CREATE INDEX idx_user_email ON User(email);


-- -----------------------------------------------------
-- Indexes for the `Property` Table
-- -----------------------------------------------------
-- Index on the foreign key `host_id` to quickly find all
-- properties belonging to a specific host.
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on `location` as users will frequently search for
-- properties in a specific city or area.
CREATE INDEX idx_property_location ON Property(location);

-- Index on `price_per_night` to speed up filtering by price range.
CREATE INDEX idx_property_price ON Property(price_per_night);


-- -----------------------------------------------------
-- Indexes for the `Booking` Table
-- -----------------------------------------------------
-- Indexes on foreign keys are essential for fast JOIN operations.
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- A composite index on dates to optimize searches for booking
-- availability within a specific date range.
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);


-- -----------------------------------------------------
-- Indexes for the `Review` Table
-- -----------------------------------------------------
-- Indexes on foreign keys to quickly retrieve all reviews for a
-- specific property or by a specific user.
CREATE INDEX idx_review_property_id ON Review(property_id);
CREATE INDEX idx_review_user_id ON Review(user_id);


-- =================================================================
-- Performance Measurement Examples (using EXPLAIN ANALYZE)
-- Description: Run these queries after creating the indexes to see
--              their impact on query execution plans.
-- Note: EXPLAIN ANALYZE is available in MySQL 8.0+ and PostgreSQL.
-- =================================================================

-- Example 1: Analyze a query that benefits from an index on a foreign key.
-- This query finds all properties for a specific host.
-- The output should show that the `idx_property_host_id` index is used.
EXPLAIN ANALYZE SELECT property_id, name, location FROM Property WHERE host_id = '1a1a1a1a-1111-1111-1111-111111111111';


-- Example 2: Analyze a query that benefits from an index on a common search column.
-- This query finds all properties in a specific location.
-- The output should show that the `idx_property_location` index is used.
EXPLAIN ANALYZE SELECT property_id, name, price_per_night FROM Property WHERE location = 'Karen, Nairobi';
