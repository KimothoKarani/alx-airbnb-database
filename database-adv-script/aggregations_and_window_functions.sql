-- =================================================================
-- ALX Airbnb Clone Project - Aggregations & Window Functions
-- Description: This script demonstrates the use of aggregation and
--              window functions for data analysis.
-- Author: Simon Kimotho
-- Date: July 3, 2025
-- =================================================================

-- Select the database to use
USE alx_airbnb;

-- -----------------------------------------------------------------
-- Query 1: Aggregation with COUNT and GROUP BY
-- Objective: Find the total number of bookings made by each user.
-- -----------------------------------------------------------------
-- We join User and Booking tables to get user names, then group by
-- user to count the number of bookings for each.
SELECT
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM
    User AS u
LEFT JOIN
    Booking AS b ON u.user_id = b.user_id
GROUP BY
    u.user_id, u.first_name, u.last_name, u.email
ORDER BY
    total_bookings DESC;


-- -----------------------------------------------------------------
-- Query 2: Window Function (RANK)
-- Objective: Rank properties based on the total number of
--            bookings they have received.
-- -----------------------------------------------------------------
-- We first need to count the bookings for each property. A Common
-- Table Expression (CTE) is a great way to do this. Then, we use the
-- RANK() window function on the result of the CTE.
WITH PropertyBookingCounts AS (
    SELECT
        p.property_id,
        p.name,
        p.location,
        COUNT(b.booking_id) AS booking_count
    FROM
        Property AS p
    LEFT JOIN
        Booking AS b ON p.property_id = b.property_id
    GROUP BY
        p.property_id, p.name, p.location
)
SELECT
    name,
    location,
    booking_count,
    RANK() OVER (ORDER BY booking_count DESC) AS property_rank
FROM
    PropertyBookingCounts;


-- -----------------------------------------------------------------
-- Query 3: Window Function (ROW_NUMBER)
-- Objective: Assign a unique sequential number to properties based
--            on the total number of bookings they have received.
-- -----------------------------------------------------------------
-- This is similar to RANK(), but ROW_NUMBER() assigns a unique number
-- to every row, even if there are ties in the booking_count.
WITH PropertyBookingCounts AS (
    SELECT
        p.property_id,
        p.name,
        p.location,
        COUNT(b.booking_id) AS booking_count
    FROM
        Property AS p
    LEFT JOIN
        Booking AS b ON p.property_id = b.property_id
    GROUP BY
        p.property_id, p.name, p.location
)
SELECT
    name,
    location,
    booking_count,
    ROW_NUMBER() OVER (ORDER BY booking_count DESC) AS property_row_number
FROM
    PropertyBookingCounts;