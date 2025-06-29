# Database Normalization

## Objective
Make sure our Airbnb‐clone schema follows third normal form (3NF) to eliminate redundancy and ensure data integrity.

---

## 1. Review of Initial Schema

Here’s a quick reminder of our tables and their attributes:

- **User**  
  `user_id`, `first_name`, `last_name`, `email`, `password_hash`, `phone_number`, `role`, `created_at`

- **Property**  
  `property_id`, `host_id`, `name`, `description`, `location`, `price_per_night`, `created_at`, `updated_at`

- **Booking**  
  `booking_id`, `property_id`, `guest_id`, `start_date`, `end_date`, `total_price`, `status`, `created_at`

- **Payment**  
  `payment_id`, `booking_id`, `amount`, `payment_date`, `payment_method`

- **Review**  
  `review_id`, `property_id`, `user_id`, `rating`, `comment`, `created_at`

- **Message**  
  `message_id`, `sender_id`, `recipient_id`, `message_body`, `sent_at`

---

## 2. First Normal Form (1NF)

**Rule:** All columns must hold atomic (indivisible) values; no repeating groups.

- Every attribute in our tables holds a single value.  
- We don’t store arrays or comma-separated lists in any column.

**Status:** ✔ Already in 1NF.

---

## 3. Second Normal Form (2NF)

**Rule:** No partial dependency on a composite primary key (all non-key attributes depend on the whole key).

- We use single-column primary keys (UUIDs), so there is no composite key to worry about.  
- Each non-key attribute in a table depends on that table’s single primary key.

**Status:** ✔ Already in 2NF.

---

## 4. Third Normal Form (3NF)

**Rule:** No transitive dependency—non-key attributes must depend only on the primary key, not on other non-key attributes.

- **User**  
  - All attributes (name, email, role, etc.) describe the user itself.

- **Property**  
  - Attributes like `name`, `location`, `price_per_night` depend only on `property_id`.

- **Booking**  
  - `total_price` is calculated by application logic, not stored from another non-key column.  
  - `status` describes the booking itself.

- **Payment**, **Review**, **Message**  
  - Each attribute directly describes its own entity.

We don’t see any column that depends on another non-key column.

**Status:** ✔ Already in 3NF.

---

## 5. Summary of Adjustments

No structural changes were required. The original design already satisfied 3NF:

- All tables have single-column (atomic) PKs.  
- There are no repeating groups or multi-valued columns.  
- No table contains attributes that depend on anything but its own primary key.

---