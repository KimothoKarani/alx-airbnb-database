-- =================================================================
-- ALX Airbnb Clone Project - Database Schema DDL
-- Description: This script creates the full database schema including
--              tables, constraints, and indexes for the project.
-- Author: Simon Kimotho
-- Date: June 29, 2025
-- =================================================================

-- Create the database if it doesn't exist and use it.
-- In a production environment, you might do this separately.
-- CREATE DATABASE IF NOT EXISTS alx_airbnb;
-- USE alx_airbnb;

-- -----------------------------------------------------
-- Table `User`
-- Stores user information for guests, hosts, and admins.
-- -----------------------------------------------------
CREATE TABLE User (
    user_id CHAR(36) NOT NULL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50) NULL,
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- Table `Property`
-- Stores details about rental properties listed by hosts.
-- -----------------------------------------------------
CREATE TABLE Property (
    property_id CHAR(36) NOT NULL PRIMARY KEY,
    host_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (host_id) REFERENCES User(user_id)
        ON DELETE CASCADE -- If a user is deleted, their properties are also deleted.
);

-- -----------------------------------------------------
-- Table `Booking`
-- Manages bookings made by guests for properties.
-- -----------------------------------------------------
CREATE TABLE Booking (
    booking_id CHAR(36) NOT NULL PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (property_id) REFERENCES Property(property_id)
        ON DELETE CASCADE, -- If a property is removed, its bookings are void.
    FOREIGN KEY (user_id) REFERENCES User(user_id)
        ON DELETE RESTRICT -- Do not allow deleting a user who has bookings.
);

-- -----------------------------------------------------
-- Table `Payment`
-- Logs payment transactions for bookings.
-- -----------------------------------------------------
CREATE TABLE Payment (
    payment_id CHAR(36) NOT NULL PRIMARY KEY,
    booking_id CHAR(36) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,

    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE CASCADE -- If a booking is deleted, related payments are also cleared.
);

-- -----------------------------------------------------
-- Table `Review`
-- Stores guest reviews for properties.
-- -----------------------------------------------------
CREATE TABLE Review (
    review_id CHAR(36) NOT NULL PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (property_id) REFERENCES Property(property_id)
        ON DELETE CASCADE, -- If a property is deleted, its reviews are also deleted.
    FOREIGN KEY (user_id) REFERENCES User(user_id)
        ON DELETE CASCADE -- If a user is deleted, their reviews are also deleted.
);

-- -----------------------------------------------------
-- Table `Message`
-- Enables communication between users.
-- -----------------------------------------------------
CREATE TABLE Message (
    message_id CHAR(36) NOT NULL PRIMARY KEY,
    sender_id CHAR(36) NOT NULL,
    recipient_id CHAR(36) NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (sender_id) REFERENCES User(user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES User(user_id)
        ON DELETE CASCADE
);

-- =================================================================
-- Index Creation for Performance Optimization
-- =================================================================

-- Index on User email for faster login lookups.
-- Note: A UNIQUE constraint already creates an index, but explicitly defining
-- it makes the performance intention clear.
CREATE INDEX idx_user_email ON User(email);

-- Index on host_id in Property for faster retrieval of a host's properties.
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Indexes on foreign keys in Booking for faster joins and lookups.
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index on booking_id in Payment for quick access to payment history.
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);