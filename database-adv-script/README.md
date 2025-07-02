# Advanced SQL: Join Queries

This directory contains the SQL script `joins_queries.sql`, which demonstrates the use of different types of SQL `JOIN` clauses to retrieve and combine data from multiple tables in the ALX Airbnb Clone database.

## Overview

SQL `JOIN`s are fundamental for querying relational databases. They allow us to link data from different tables based on a related column between them. This script provides practical examples of the most common join types.

### 1. INNER JOIN

**Purpose:** To retrieve records that have matching values in both tables.

The query in this script finds all confirmed bookings and combines them with the information of the user who made the booking.

```sql
SELECT
    b.booking_id,
    b.start_date,
    b.status,
    u.first_name,
    u.email
FROM
    Booking b
INNER JOIN
    User u ON b.user_id = u.user_id
WHERE
    b.status = 'confirmed';

2. LEFT JOIN
Purpose: To retrieve all records from the left table and the matched records from the right table. If there is no match, the result is NULL on the right side.

The query retrieves all properties and includes any reviews they may have. Properties with no reviews will still be listed, but their review fields will be NULL.

SELECT
    p.property_id,
    p.name AS property_name,
    r.rating,
    r.comment
FROM
    Property p
LEFT JOIN
    Review r ON p.property_id = r.property_id;

3. FULL OUTER JOIN (Emulated in MySQL)
Purpose: To retrieve all records when there is a match in either the left or the right table. It includes all users (even those with no bookings) and all bookings (even those without a linked user, if that were possible).

Note: MySQL does not have a native FULL OUTER JOIN syntax. The required functionality is achieved by combining a LEFT JOIN and a RIGHT JOIN with a UNION operator.

-- Get all Users and their bookings
SELECT u.user_id, u.first_name, b.booking_id, b.status
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
UNION
-- Get all Bookings and their users
SELECT u.user_id, u.first_name, b.booking_id, b.status
FROM User AS u
RIGHT JOIN Booking b ON u.user_id = b.user_id;
