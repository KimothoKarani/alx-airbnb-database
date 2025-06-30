# Database Schema Script (`schema.sql`)

This directory contains the primary Data Definition Language (DDL) script for the ALX Airbnb Clone project.

## Overview

The `schema.sql` file includes all the necessary SQL `CREATE TABLE` statements to build the database structure from scratch. It defines all entities, attributes, data types, and the relationships between them as specified in the project requirements.

### Key Features of the Schema:
- **Normalization:** The schema is designed in Third Normal Form (3NF) to ensure data integrity and reduce redundancy.
- **Relational Integrity:** `PRIMARY KEY` and `FOREIGN KEY` constraints are used to maintain strong relationships between tables. `ON DELETE` and `ON UPDATE` actions are defined to handle data consistency automatically.
- **Data Constraints:** Includes `NOT NULL`, `UNIQUE`, and `CHECK` constraints to enforce business rules and data quality.
- **Performance:** Key columns are indexed to ensure efficient data retrieval and optimal query performance for common operations like logins, searches, and lookups.

## How to Use This Script

To set up the database using this script, follow these steps with a MySQL-compatible database client:

1.  **Create the Database:**
    First, create the database that will hold the tables.
    ```sql
    CREATE DATABASE alx_airbnb;
    ```

2.  **Select the Database:**
    Before running the script, you must select the database you just created.
    ```sql
    USE alx_airbnb;
    ```

3.  **Run the Script:**
    Execute the entire contents of the `schema.sql` file. This will create all the tables, set up the constraints, and build the indexes.

    *Example using the MySQL command line:*
    ```bash
    mysql -u your_username -p alx_airbnb < schema.sql
    ```

After successful execution, the database will be fully structured and ready to be populated with data.
