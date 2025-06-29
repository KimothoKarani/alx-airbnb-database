# Database Normalization
---

## Objective

The objective of this report is to analyze the database schema for the ALX Airbnb Clone project and verify that it adheres to the principles of database normalization, specifically up to the Third Normal Form (3NF). A normalized database minimizes data redundancy, prevents data anomalies (insertion, update, deletion), and ensures data integrity.

## 1. Analysis of the Schema

The current schema consists of six main tables: `User`, `Property`, `Booking`, `Payment`, `Review`, and `Message`. Our analysis will check this schema against the rules of 1NF, 2NF, and 3NF.

The schema design successfully achieves 3NF by logically separating distinct entities into their own tables from the outset. Below is a step-by-step verification of this claim.

### Step 1: Verification of First Normal Form (1NF)

**Rule:** A table is in 1NF if all its columns contain atomic (indivisible) values, and each record is unique. There should be no repeating groups or multi-valued columns.

**Analysis:**
* **Atomicity:** Every column in every table is designed to hold a single piece of information. For example, the `User` table has separate `first_name` and `last_name` columns, rather than a single non-atomic `full_name` column. The `role` column holds only one role per user.
* **No Repeating Groups:** There are no columns like `phone_number1`, `phone_number2`, or `booking1`, `booking2`. Relationships are handled through separate tables (e.g., a `User` can have multiple bookings by having multiple entries in the `Booking` table, each pointing to that user's `user_id`).
* **Unique Records:** Every table has a `Primary Key` (`user_id`, `property_id`, etc.) that ensures each record is unique.

**Conclusion:** The schema fully complies with the rules of the **First Normal Form (1NF)**.

### Step 2: Verification of Second Normal Form (2NF)

**Rule:** A table is in 2NF if it is in 1NF and all non-key attributes are fully functionally dependent on the entire primary key. This rule is primarily relevant for tables with composite primary keys.

**Analysis:**
All tables in our schema use a single-column primary key (e.g., `booking_id: UUID`). In a single-column primary key scenario, there can be no partial dependencies. By definition, any non-key attribute must be dependent on the *entire* primary key because there is only one column in it.

For instance, in the `Booking` table:
* The primary key is `booking_id`.
* Attributes like `start_date`, `end_date`, `total_price`, and `status` are all facts about that *specific booking*. They are fully dependent on `booking_id`. They are not dependent on just a part of the key, as the key is not composite.

**Conclusion:** The schema fully complies with the rules of the **Second Normal Form (2NF)**.

### Step 3: Verification of Third Normal Form (3NF)

**Rule:** A table is in 3NF if it is in 2NF and it has no transitive dependencies. A transitive dependency exists when a non-key attribute is dependent on another non-key attribute, rather than directly on the primary key.

**Analysis:**
The schema was designed to eliminate transitive dependencies by separating distinct entities into their own tables. Let's examine the `Property` table as a key example.

* **Table:** `Property`
* **Primary Key:** `property_id`
* **Attributes:** `name`, `description`, `location`, `price_per_night`, `host_id`.

Consider the host's information. A host's name (`first_name`) and email (`email`) are facts about the host, not the property.

* `host_name` depends on `host_id`.
* `host_id` depends on `property_id` (since each property has a host).

A poorly designed, non-3NF table might look like this:
`Property (property_id, name, location, host_id, host_name, host_email)`

In this incorrect design, `host_name` and `host_email` are transitively dependent on `property_id` via `host_id`. This would cause an **update anomaly**: if a host changes their email, you would have to update it in every single property record they own.

Our schema correctly avoids this by placing host information in the `User` table. The `Property` table only contains a foreign key (`host_id`). To get the host's name, you join the `Property` and `User` tables. All non-key attributes in the `Property` table (`name`, `location`, etc.) are facts directly about the property and nothing else. The same logic applies to all other tables in the schema.

**Conclusion:** The schema fully complies with the rules of the **Third Normal Form (3NF)**.

## 2. Final Conclusion

No structural changes were required. The original design already satisfied 3NF:

- All tables have single-column (atomic) PKs.  
- There are no repeating groups or multi-valued columns.  
- No table contains attributes that depend on anything but its own primary key.

---