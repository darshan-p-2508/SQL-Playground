-- Step 1: Create a new database
CREATE DATABASE sql_playground;

-- Step 2: Use the newly created database
USE sql_playground;

-- Step 3: Create a table to store sample data (e.g., users)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 4: Insert some sample data into the 'users' table
INSERT INTO users (first_name, last_name, email) 
VALUES 
('John', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com'),
('Alice', 'Johnson', 'alice.johnson@example.com');

-- Step 5: Query to retrieve all users
SELECT * FROM users;

-- Step 6: Update a user (example: changing email)
UPDATE users
SET email = 'john.doe_updated@example.com'
WHERE user_id = 1;

-- Step 7: Delete a user
DELETE FROM users
WHERE user_id = 3;

-- Step 8: Query to retrieve users after update and delete
SELECT * FROM users;

/*
Explanation of the SQL Script:
Create Database: This is where you create your SQL playground database.
Create Table: A simple table to store users with fields like user_id, first_name, last_name, email, and created_at.
Insert Data: Inserts a few example users into your table.
Basic CRUD Operations: Perform basic Create, Read, Update, and Delete operations on the users table.
*/
