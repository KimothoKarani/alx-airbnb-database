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
```
# ALX Airbnb Database - Advanced Subqueries

## Overview

This directory contains advanced SQL subquery examples for the ALX Airbnb database project. The queries demonstrate both correlated and non-correlated subqueries to solve complex data retrieval problems.

## Files

- `subqueries.sql` - Contains all the SQL subquery examples
- `README.md` - This documentation file

## Subquery Types Covered

### 1. Non-Correlated Subqueries

**Definition**: Independent subqueries that can be executed separately from the main query.

**Example**: Finding properties with average rating > 4.0

```sql
SELECT p.property_id, p.name, p.location
FROM Property p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
);
```

**Characteristics**:
- Executes once and returns a result set
- The outer query uses the subquery result
- Can be executed independently

### 2. Correlated Subqueries

**Definition**: Subqueries that reference columns from the outer query and are executed for each row.

**Example**: Finding users with more than 3 bookings

```sql
SELECT u.user_id, u.first_name, u.last_name
FROM User u
WHERE (
    SELECT COUNT(*)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > 3;
```

**Characteristics**:
- References outer query columns
- Executes for each row of the outer query
- Cannot be executed independently

## Query Explanations

### Query 1: Properties with High Ratings

**Objective**: Find all properties where the average rating is greater than 4.0

**Approach**: 
- Uses a non-correlated subquery in the WHERE clause
- Subquery calculates average rating for each property
- Main query filters properties based on subquery results

**Alternative Implementation**:
- Uses EXISTS instead of IN for better performance
- EXISTS stops at the first match, making it more efficient

### Query 2: Active Users

**Objective**: Find users who have made more than 3 bookings

**Approach**:
- Uses a correlated subquery that counts bookings for each user
- The subquery references the user_id from the outer query
- Filters users based on booking count

**Enhanced Version**:
- Includes additional booking statistics
- Shows total bookings, first booking date, and last booking date
- Ordered by total bookings for better insights

## Additional Advanced Examples

### 3. Properties Never Booked

Uses NOT EXISTS to find properties with no bookings:

```sql
SELECT p.property_id, p.name
FROM Property p
WHERE NOT EXISTS (
    SELECT 1 FROM Booking b WHERE b.property_id = p.property_id
);
```

### 4. Multi-Location Travelers

Finds users who have booked properties in multiple locations:

```sql
SELECT u.user_id, u.first_name, u.last_name
FROM User u
WHERE (
    SELECT COUNT(DISTINCT p.location)
    FROM Booking b JOIN Property p ON b.property_id = p.property_id
    WHERE b.user_id = u.user_id
) > 2;
```

### 5. Above-Average Pricing

Finds properties priced above the average for their location:

```sql
SELECT p.property_id, p.name, p.pricepernight
FROM Property p
WHERE p.pricepernight > (
    SELECT AVG(p2.pricepernight)
    FROM Property p2
    WHERE p2.location = p.location
);
```

## Performance Considerations

### Optimization Tips:

1. **Use EXISTS vs IN**: EXISTS is often more efficient for existence checks
2. **Proper Indexing**: Ensure columns used in subqueries are indexed
3. **Limit Result Sets**: Use LIMIT when appropriate
4. **Consider JOINs**: Sometimes JOINs can be more efficient than subqueries

### Index Recommendations:

```sql
-- For better performance, consider these indexes:
CREATE INDEX idx_review_property_rating ON Review(property_id, rating);
CREATE INDEX idx_booking_user_date ON Booking(user_id, start_date);
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);
```

## Usage Instructions

1. Ensure your database has the required tables and sample data
2. Execute the queries in `subqueries.sql` one by one
3. Analyze the results to understand subquery behavior
4. Experiment with modifications to see how they affect performance

## Common Pitfalls to Avoid

1. **Using IN with NULL values**: Be careful with NULL handling
2. **Performance issues**: Correlated subqueries can be slow on large datasets
3. **Incorrect correlation**: Ensure correlated subqueries reference the correct outer query columns
4. **Missing GROUP BY**: When using aggregate functions in subqueries, ensure proper grouping


# Advanced SQL Aggregations and Window Functions

This directory contains SQL scripts demonstrating advanced aggregation techniques and window functions for analyzing booking data in the Airbnb database.

## Files

- `aggregations_and_window_functions.sql` - Main SQL script with all examples
- `README.md` - This documentation file

## Task Overview

### Task 1: Total Bookings by User (Aggregation Functions)

**Objective**: Count total bookings made by each user using COUNT and GROUP BY

**Core Query**:
```sql
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.email
ORDER BY total_bookings DESC;
```

**Key Features**:
- Uses `LEFT JOIN` to include users with zero bookings
- `COUNT()` function aggregates booking records
- `GROUP BY` groups results by user
- `ORDER BY` sorts by booking count

### Task 2: Property Rankings by Booking Count (Window Functions)

**Objective**: Rank properties based on total bookings using ROW_NUMBER and RANK

**Core Query**:
```sql
SELECT 
    p.property_id,
    p.name,
    p.location,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number_rank,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank_with_gaps
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name, p.location
ORDER BY total_bookings DESC;
```

**Key Features**:
- `ROW_NUMBER()` assigns unique sequential numbers
- `RANK()` handles ties with gaps in numbering
- `OVER()` clause defines the window specification
- `ORDER BY` in window function determines ranking order

## Aggregation Functions Explained

### Basic Aggregation Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `COUNT()` | Count non-null values | `COUNT(booking_id)` |
| `SUM()` | Sum numeric values | `SUM(total_price)` |
| `AVG()` | Calculate average | `AVG(total_price)` |
| `MIN()` | Find minimum value | `MIN(start_date)` |
| `MAX()` | Find maximum value | `MAX(start_date)` |

### GROUP BY Rules

1. **All non-aggregate columns** in SELECT must be in GROUP BY
2. **Aggregate functions** don't need to be in GROUP BY
3. **ORDER BY** can reference aggregate functions
4. **HAVING** filters groups after aggregation

### Advanced Aggregation Example

```sql
SELECT 
    u.user_id,
    u.first_name,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_spent,
    AVG(b.total_price) AS avg_booking_value,
    MIN(b.start_date) AS first_booking,
    MAX(b.start_date) AS last_booking,
    COUNT(DISTINCT b.property_id) AS unique_properties
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name
HAVING COUNT(b.booking_id) > 5
ORDER BY total_bookings DESC;
```

## Window Functions Explained

### Window Function Types

#### Ranking Functions
- `ROW_NUMBER()` - Unique sequential numbers
- `RANK()` - Same rank for ties, with gaps
- `DENSE_RANK()` - Same rank for ties, no gaps
- `NTILE(n)` - Divide into n equal buckets

#### Analytic Functions
- `LAG()` - Access previous row value
- `LEAD()` - Access next row value
- `FIRST_VALUE()` - First value in window
- `LAST_VALUE()` - Last value in window

#### Aggregate Functions as Window Functions
- `SUM() OVER()` - Running totals
- `AVG() OVER()` - Moving averages
- `COUNT() OVER()` - Running counts

### Window Function Syntax

```sql
function_name([arguments]) OVER (
    [PARTITION BY partition_expression]
    [ORDER BY sort_expression]
    [ROWS|RANGE frame_specification]
)
```

### Partitioning Example

```sql
-- Rank properties within each location
SELECT 
    property_id,
    name,
    location,
    COUNT(booking_id) AS bookings,
    RANK() OVER (
        PARTITION BY location 
        ORDER BY COUNT(booking_id) DESC
    ) AS location_rank
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY property_id, name, location;
```

## Advanced Analytics Examples

### 1. Running Totals and Moving Averages

```sql
SELECT 
    property_id,
    name,
    total_bookings,
    SUM(total_bookings) OVER (
        ORDER BY total_bookings DESC 
        ROWS UNBOUNDED PRECEDING
    )