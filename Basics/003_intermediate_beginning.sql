-- ==========================================
--  Intermediate SQL Concepts
--  Relationships, Joins, Aggregates, Indexes
-- ==========================================

-- Step 1: Create a related table (orders)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_name VARCHAR(100),
    amount DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Step 2: Insert sample order data
INSERT INTO orders (user_id, product_name, amount)
VALUES
(1, 'Laptop', 1200.00),
(1, 'Mouse', 25.50),
(2, 'Keyboard', 45.00),
(2, 'Monitor', 300.99);

-- Step 3: INNER JOIN example (users with orders)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    o.product_name,
    o.amount
FROM users u
INNER JOIN orders o ON u.user_id = o.user_id;

-- Step 4: LEFT JOIN example (users even if no orders)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    o.product_name,
    o.amount
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id;

-- Step 5: Aggregate Functions (SUM, COUNT)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id;

-- Step 6: HAVING Clause (filter aggregate results)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    SUM(o.amount) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id
HAVING total_spent > 100;

-- Step 7: Create an index to improve performance
CREATE INDEX idx_user_email ON users(email);

-- Step 8: A VIEW for frequently used query
CREATE VIEW user_order_summary AS
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id;

-- Step 9: Query the view
SELECT * FROM user_order_summary;

