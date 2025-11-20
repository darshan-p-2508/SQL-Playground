/* ---------------------------------------------------------
   Step 1: Create and select the database
--------------------------------------------------------- */

-- Create a database if it doesn't exist already
CREATE DATABASE IF NOT EXISTS sql_playground;

-- Switch to the newly created database
USE sql_playground;


/* ---------------------------------------------------------
   Step 2: Create 'users' table
--------------------------------------------------------- */

-- This table stores user information.
-- AUTO_INCREMENT creates unique IDs automatically.
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique ID for each user
    first_name VARCHAR(50),                  -- User's first name
    last_name VARCHAR(50),                   -- User's last name
    email VARCHAR(100),                      -- Email address
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Auto timestamps on record creation
);


/* ---------------------------------------------------------
   Step 3: Insert sample user data
--------------------------------------------------------- */

-- Adds three example users into the table
INSERT INTO users (first_name, last_name, email) 
VALUES 
('John', 'Doe', 'john.doe@example.com'),
('Jane', 'Smith', 'jane.smith@example.com'),
('Alice', 'Johnson', 'alice.johnson@example.com');


/* ---------------------------------------------------------
   Step 4: Retrieve all users
--------------------------------------------------------- */

-- Select all columns from the users table
SELECT * FROM users;


/* ---------------------------------------------------------
   Step 5: Update a user record
--------------------------------------------------------- */

-- Modify John Doe’s email (WHERE clause ensures we update ONLY user_id = 1)
UPDATE users
SET email = 'john.doe_updated@example.com'
WHERE user_id = 1;


/* ---------------------------------------------------------
   Step 6: Delete a user
--------------------------------------------------------- */

-- Removes the user with user_id = 3
DELETE FROM users
WHERE user_id = 3;


/* ---------------------------------------------------------
   Step 7: Retrieve users after update/delete
--------------------------------------------------------- */

SELECT * FROM users;


/* =========================================================
   NEXT LEVEL SQL
   Constraints, Relationships, Joins, Aggregations,
   Subqueries, Views, Indexing
========================================================= */


/* ---------------------------------------------------------
   Add UNIQUE constraint on email
--------------------------------------------------------- */

-- Ensures no two users can have the same email address.
ALTER TABLE users
ADD CONSTRAINT unique_email UNIQUE (email);


/* ---------------------------------------------------------
   Create 'orders' table with a foreign key
--------------------------------------------------------- */

-- This table stores product orders related to each user.
-- It references the 'users' table to establish a relationship.
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,     -- Unique ID for each order
    user_id INT,                                 -- Links order to a specific user
    product_name VARCHAR(100),                   -- Name of the purchased item
    amount DECIMAL(10,2),                        -- Order amount
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp for the order
    
    -- Foreign key creates a relationship with users table
    -- ON DELETE CASCADE: delete orders if the user is deleted
    CONSTRAINT fk_user FOREIGN KEY (user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);


/* ---------------------------------------------------------
   Insert sample order data
--------------------------------------------------------- */

-- Insert orders belonging to users 1 and 2
INSERT INTO orders (user_id, product_name, amount)
VALUES 
(1, 'Laptop', 1200.00),
(1, 'Mouse', 25.50),
(2, 'Desk Chair', 199.99);


/* ---------------------------------------------------------
   INNER JOIN: Users with matching Orders
--------------------------------------------------------- */

-- Shows only users who *have* orders
SELECT 
    u.user_id,
    u.first_name,
    o.product_name,
    o.amount
FROM users u
JOIN orders o ON u.user_id = o.user_id;


/* ---------------------------------------------------------
   LEFT JOIN: All users, even if they have no orders
--------------------------------------------------------- */

-- Displays users and their orders; shows NULL if no orders exist
SELECT 
    u.user_id,
    u.first_name,
    o.product_name,
    o.amount
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id;


/* ---------------------------------------------------------
   Aggregations: SUM, COUNT, GROUP BY
--------------------------------------------------------- */

-- Total amount each user has spent
SELECT 
    u.user_id,
    u.first_name,
    SUM(o.amount) AS total_spent   -- SUM aggregates the total spending
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.first_name;  -- GROUP BY required when using aggregate functions


-- Number of orders per user
SELECT 
    user_id,
    COUNT(*) AS total_orders      -- Counts total rows per user_id
FROM orders
GROUP BY user_id;


/* ---------------------------------------------------------
   Subquery Example
--------------------------------------------------------- */

-- Select users who have spent more than $500 total
SELECT *
FROM users
WHERE user_id IN (
    SELECT user_id
    FROM orders
    GROUP BY user_id
    HAVING SUM(amount) > 500      -- HAVING used for aggregated filtering
);


/* ---------------------------------------------------------
   Create a VIEW for easier reporting
--------------------------------------------------------- */

-- A view is a saved query that behaves like a virtual table
CREATE OR REPLACE VIEW user_order_summary AS
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,  -- Combine first/last name
    COUNT(o.order_id) AS num_orders,                      -- Total orders per user
    SUM(o.amount) AS total_spent                          -- Total spent per user
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id;


/* Query the view */
SELECT * FROM user_order_summary;


/* ---------------------------------------------------------
   Indexing
--------------------------------------------------------- */

-- Speeds up searches on the email field dramatically
CREATE INDEX idx_email ON users(email);


/* ---------------------------------------------------------
   End of Script
--------------------------------------------------------- */
