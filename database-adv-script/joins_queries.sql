-- =================================================================
-- ALX Airbnb Clone Project - Advanced SQL Join Queries
-- Description: This script contains queries using INNER, LEFT,
--              and an emulated FULL OUTER JOIN.
-- Author: Simon Kimotho
-- Date: July 2, 2025
-- =================================================================

-- Select the database to use
USE alx_airbnb;

-- -----------------------------------------------------------------
-- Query 1: INNER JOIN
-- Objective: Retrieve all confirmed bookings and the respective
--            users who made those bookings.
-- -----------------------------------------------------------------
-- An INNER JOIN only returns rows where there is a match in both tables.
-- Here, we only get bookings that are linked to a user.
SELECT
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.first_name,
    u.last_name,
    u.email
FROM
    Booking b
INNER JOIN
    User u ON b.user_id = u.user_id
WHERE
    b.status = 'confirmed';


-- -----------------------------------------------------------------
-- Query 2: LEFT JOIN
-- Objective: Retrieve all properties and any reviews they have,
--            including properties that have no reviews.
-- -----------------------------------------------------------------
-- A LEFT JOIN returns all rows from the left table (Property) and the
-- matched rows from the right table (Review). If there is no match,
-- the columns from the right table will be NULL.
SELECT
    p.property_id,
    p.name AS property_name,
    r.rating,
    r.comment
FROM
    Property p
LEFT JOIN
    Review r ON p.property_id = r.property_id
ORDER BY
    p.name;


-- -----------------------------------------------------------------
-- Query 3: Emulated FULL OUTER JOIN (using UNION)
-- Objective: Retrieve all users and all bookings, showing matches
--            where they exist, but also including users who have
--            never booked and bookings that might not have a user.
-- -----------------------------------------------------------------
-- MySQL does not support FULL OUTER JOIN directly. We emulate it by
-- combining a LEFT JOIN and a RIGHT JOIN with UNION.

-- Part 1: Get all Users and their bookings (if any)
SELECT
    u.user_id,
    u.first_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.status
FROM
    User u
LEFT JOIN
    Booking b ON u.user_id = b.user_id

UNION

-- Part 2: Get all Bookings and their users (if any)
SELECT
    u.user_id,
    u.first_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.status
FROM
    User u
RIGHT JOIN
    Booking b ON u.user_id = b.user_id;

