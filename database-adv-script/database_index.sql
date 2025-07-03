-- =================================================================
-- ALX Airbnb Clone Project - Index Creation for Optimization
-- Description: This script creates indexes on high-usage columns
--              to improve query performance.
-- Author: Simon Kimotho
-- Date: July 3, 2025
-- =================================================================

-- Select the database to use
USE alx_airbnb;

-- =====================================================
-- INDEX ANALYSIS AND CREATION
-- =====================================================

-- First, let's analyze current table structures and identify high-usage columns
-- This helps us understand which columns need indexing

-- =====================================================
-- 1. USER TABLE INDEXES
-- =====================================================

-- Primary key index (usually created automatically)
-- ALTER TABLE User ADD PRIMARY KEY (user_id);

-- Email index - frequently used for user authentication and lookups
CREATE INDEX idx_user_email ON User(email);

-- Phone number index - used for user lookups and contact
CREATE INDEX idx_user_phone ON User(phone_number);

-- Name indexes - used for user searches and sorting
CREATE INDEX idx_user_name ON User(first_name, last_name);

-- Registration date index - used for user analytics and filtering
CREATE INDEX idx_user_created ON User(created_at);

-- Role-based index (if role column exists)
-- CREATE INDEX idx_user_role ON User(role);

-- =====================================================
-- 2. PROPERTY TABLE INDEXES
-- =====================================================

-- Primary key index (usually created automatically)
-- ALTER TABLE Property ADD PRIMARY KEY (property_id);

-- Host ID index - for finding properties by host
CREATE INDEX idx_property_host ON Property(host_id);

-- Location index - frequently used for property searches
CREATE INDEX idx_property_location ON Property(location);

-- Price range index - used for price filtering
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Property type index (if property_type column exists)
-- CREATE INDEX idx_property_type ON Property(property_type);

-- Availability index (if availability column exists)
-- CREATE INDEX idx_property_availability ON Property(availability);

-- Composite index for location and price filtering
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- Property creation date index
CREATE INDEX idx_property_created ON Property(created_at);

-- =====================================================
-- 3. BOOKING TABLE INDEXES
-- =====================================================

-- Primary key index (usually created automatically)
-- ALTER TABLE Booking ADD PRIMARY KEY (booking_id);

-- User ID index - for finding bookings by user
CREATE INDEX idx_booking_user ON Booking(user_id);

-- Property ID index - for finding bookings by property
CREATE INDEX idx_booking_property ON Booking(property_id);

-- Date range indexes - crucial for availability and booking searches
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Composite index for date range queries
CREATE INDEX idx_booking_date_range ON Booking(start_date, end_date);

-- Status index - for filtering active/cancelled bookings
CREATE INDEX idx_booking_status ON Booking(status);

-- Total price index - for financial analytics
CREATE INDEX idx_booking_price ON Booking(total_price);

-- Booking creation date index
CREATE INDEX idx_booking_created ON Booking(created_at);

-- Composite index for user and date queries
CREATE INDEX idx_booking_user_date ON Booking(user_id, start_date);

-- Composite index for property and date queries
CREATE INDEX idx_booking_property_date ON Booking(property_id, start_date);

-- Composite index for property availability checks
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- =====================================================
-- 4. PAYMENT TABLE INDEXES (if exists)
-- =====================================================

-- CREATE INDEX idx_payment_booking ON Payment(booking_id);
-- CREATE INDEX idx_payment_method ON Payment(payment_method);
-- CREATE INDEX idx_payment_status ON Payment(payment_status);
-- CREATE INDEX idx_payment_amount ON Payment(amount);
-- CREATE INDEX idx_payment_date ON Payment(payment_date);

-- =====================================================
-- 5. REVIEW TABLE INDEXES
-- =====================================================

-- Property ID index - for finding reviews by property
CREATE INDEX idx_review_property ON Review(property_id);

-- User ID index - for finding reviews by user
CREATE INDEX idx_review_user ON Review(user_id);

-- Rating index - for filtering by rating
CREATE INDEX idx_review_rating ON Review(rating);

-- Review date index - for chronological ordering
CREATE INDEX idx_review_created ON Review(created_at);

-- Composite index for property ratings
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);

-- =====================================================
-- 6. MESSAGE TABLE INDEXES (if exists)
-- =====================================================

-- CREATE INDEX idx_message_sender ON Message(sender_id);
-- CREATE INDEX idx_message_receiver ON Message(receiver_id);
-- CREATE INDEX idx_message_booking ON Message(booking_id);
-- CREATE INDEX idx_message_timestamp ON Message(sent_at);

-- =====================================================
-- 7. SPECIALIZED COMPOSITE INDEXES
-- =====================================================

-- Complex search scenarios - property search with multiple criteria
CREATE INDEX idx_property_search ON Property(location, pricepernight, created_at);

-- Booking analytics - user booking patterns
CREATE INDEX idx_booking_analytics ON Booking(user_id, status, total_price, start_date);

-- Property performance - for host dashboards
CREATE INDEX idx_property_performance ON Booking(property_id, status, total_price, start_date);

-- User activity tracking
CREATE INDEX idx_user_activity ON Booking(user_id, created_at, status);

-- =====================================================
-- 8. PARTIAL INDEXES (for specific conditions)
-- =====================================================

-- Index only active bookings (if your database supports partial indexes)
-- CREATE INDEX idx_booking_active ON Booking(property_id, start_date, end_date)
-- WHERE status = 'confirmed';

-- Index only available properties
-- CREATE INDEX idx_property_available ON Property(location, pricepernight)
-- WHERE availability = true;

-- =====================================================
-- 9. FULL-TEXT SEARCH INDEXES (if supported)
-- =====================================================

-- For property description searches
-- CREATE FULLTEXT INDEX idx_property_description ON Property(description);

-- For property name searches
-- CREATE FULLTEXT INDEX idx_property_name ON Property(name);

-- =====================================================
-- 10. INDEXES FOR FOREIGN KEY CONSTRAINTS
-- =====================================================

-- These are often created automatically, but let's ensure they exist

-- Booking table foreign keys
CREATE INDEX idx_booking_user_fk ON Booking(user_id);
CREATE INDEX idx_booking_property_fk ON Booking(property_id);

-- Property table foreign keys
CREATE INDEX idx_property_host_fk ON Property(host_id);

-- Review table foreign keys
CREATE INDEX idx_review_property_fk ON Review(property_id);
CREATE INDEX idx_review_user_fk ON Review(user_id);

-- =====================================================
-- 11. INDEX MAINTENANCE COMMANDS
-- =====================================================

-- View all indexes on a table
-- SHOW INDEX FROM User;
-- SHOW INDEX FROM Property;
-- SHOW INDEX FROM Booking;

-- Drop index if needed
-- DROP INDEX idx_name ON table_name;

-- Analyze table to update index statistics
-- ANALYZE TABLE User;
-- ANALYZE TABLE Property;
-- ANALYZE TABLE Booking;

-- =====================================================
-- 12. PERFORMANCE MONITORING QUERIES
-- =====================================================

-- Check index usage statistics (MySQL example)
-- SELECT
--     table_name,
--     index_name,
--     cardinality,
--     sub_part,
--     packed,
--     null,
--     index_type,
--     comment
-- FROM information_schema.statistics
-- WHERE table_schema = 'airbnb_db'
-- ORDER BY table_name, index_name;

-- Find unused indexes (MySQL 5.7+)
-- SELECT
--     object_schema,
--     object_name,
--     index_name,
--     count_read,
--     count_write,
--     count_read/count_write AS read_write_ratio
-- FROM performance_schema.table_io_waits_summary_by_index_usage
-- WHERE object_schema = 'airbnb_db'
-- AND count_read = 0
-- ORDER BY count_write DESC;

-- =====================================================
-- NOTES AND BEST PRACTICES
-- =====================================================

/*
INDEX DESIGN PRINCIPLES:

1. Primary Keys and Foreign Keys:
   - Always indexed automatically or should be
   - Essential for JOIN operations

2. WHERE Clause Columns:
   - Columns frequently used in WHERE conditions
   - High selectivity columns (many unique values)

3. JOIN Columns:
   - Columns used in JOIN conditions
   - Both sides of the join should be indexed

4. ORDER BY Columns:
   - Columns used for sorting
   - Can eliminate need for filesort

5. GROUP BY Columns:
   - Columns used for grouping
   - Can speed up aggregation queries

6. Composite Indexes:
   - Order matters: most selective column first
   - Can serve multiple query patterns
   - Consider left-prefix rule

7. Index Maintenance:
   - Indexes slow down INSERT/UPDATE/DELETE
   - Regular maintenance required
   - Monitor index usage and efficiency

WHEN NOT TO INDEX:
- Tables with frequent writes and few reads
- Columns with low selectivity (few unique values)
- Very small tables
- Columns that are rarely queried

MONITORING:
- Use EXPLAIN to analyze query execution
- Monitor slow query logs
- Track index usage statistics
- Regular performance reviews
*/