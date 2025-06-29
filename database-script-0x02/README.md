# Database Seeding Script (`seed.sql`)

This directory contains the SQL Data Manipulation Language (DML) script for populating the ALX Airbnb Clone database with realistic sample data.

## Overview

The `seed.sql` file includes all the necessary SQL `INSERT` statements to add data to the tables created by the `schema.sql` script. It is designed to be run **after** the database schema has been successfully set up.

The script populates the following tables in a logical order to respect foreign key constraints:
1.  **User:** Creates a mix of users with 'host' and 'guest' roles.
2.  **Property:** Adds several properties in different locations, linked to the hosts.
3.  **Booking:** Simulates past, current, and future bookings made by guests for various properties.
4.  **Payment:** Logs payments corresponding to the bookings, including full payments and deposits.
5.  **Review:** Adds a sample review for a completed booking.
6.  **Message:** Includes a sample conversation between a host and a guest.

## How to Use This Script

To populate the database with this sample data, ensure you have already created the schema using `schema.sql`. Then, follow these steps:

1.  **Select the Database:**
    Before running the script, connect to your database client and select the target database.
    ```sql
    USE alx_airbnb;
    ```

2.  **Run the Script:**
    Execute the entire contents of the `seed.sql` file. This will insert all the sample records into your tables.

    *Example using the MySQL command line:*
    ```bash
    mysql -u your_username -p alx_airbnb < seed.sql
    ```

After successful execution, the database will contain a realistic set of data, allowing for comprehensive testing and development of the application.
