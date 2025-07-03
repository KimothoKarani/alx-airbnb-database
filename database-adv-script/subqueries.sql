-- =================================================================
-- ALX Airbnb Clone Project - Advanced SQL Subqueries & Alternatives
-- Description: This script demonstrates solving complex queries using
--              correlated subqueries and the more performant
--              JOIN with GROUP BY approach.
-- Author: Simon Kimotho
-- Date: July 3, 2025
-- =================================================================

-- Select the database to use
USE alx_airbnb;

-- -----------------------------------------------------------------
-- Method 1: Using Correlated Subqueries
-- -----------------------------------------------------------------

-- Query 1: Find all properties where the average rating is > 4.0.
SELECT
    p.property_id,
    p.name,
    p.location
FROM
    Property AS p
WHERE
    (
        SELECT AVG(r.rating)
        FROM Review AS r
        WHERE r.property_id = p.property_id -- This correlation links the review to the specific property
    ) > 4.0;


-- Query 2: Find users who have made more than 3 bookings.
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM
    User AS u
WHERE
    (
        SELECT COUNT(b.booking_id)
        FROM Booking AS b
        WHERE b.user_id = u.user_id -- This correlation links the booking to the specific user
    ) > 3;


-- =================================================================
-- Method 2: Using JOIN with GROUP BY and HAVING
-- This is often a more performant and readable alternative.
-- =================================================================

-- Query 1 Alternative: Find properties with an average rating > 4.0.
-- First, we JOIN properties with their reviews, then we GROUP the results
-- by property, and finally, we filter those groups with HAVING.
SELECT
    p.property_id,
    p.name,
    p.location,
    AVG(r.rating) AS average_rating
FROM
    Property AS p
INNER JOIN
    Review AS r ON p.property_id = r.property_id
GROUP BY
    p.property_id, p.name, p.location
HAVING
    AVG(r.rating) > 4.0;


-- Query 2 Alternative: Find users who have made more than 3 bookings.
-- We JOIN users with their bookings, GROUP the results by user,
-- and then filter the groups to find those with a booking count > 3.
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS number_of_bookings
FROM
    User AS u
INNER JOIN
    Booking AS b ON u.user_id = b.user_id
GROUP BY
    u.user_id, u.first_name, u.last_name, u.email
HAVING
    COUNT(b.booking_id) > 3;
