/* ============================================================
    INTERMEDIATE SQL — Missing Concepts
    Covers:
    - Additional Data Types
    - More Constraints (NOT NULL, DEFAULT, CHECK)
    - More JOIN Types (RIGHT, CROSS)
    - Advanced Filtering (LIKE, BETWEEN, IN, EXISTS)
    - More Subquery Variants
    - Set Operations (UNION, UNION ALL)
    - UPDATE/DELETE with JOIN
    - Transactions
    - Correlated Subqueries
    - Scalar Subqueries
    - JSON Data Type Example
============================================================ */

/* ------------------------------------------------------------
   1. Additional Data Types (BOOLEAN, DATE, ENUM, JSON)
------------------------------------------------------------ */

-- Creating a new table showcasing intermediate data types
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,

    product_name VARCHAR(100) NOT NULL,      -- String
    price DECIMAL(10,2) NOT NULL,            -- Numeric
    in_stock BOOLEAN DEFAULT TRUE,           -- Boolean storage
    category ENUM('Electronics', 'Furniture', 'Accessories'), -- Limited set of values
    release_date DATE,                       -- Date only
    attributes JSON                           -- JSON data type for flexible metadata
);

-- Insert sample product data with JSON
INSERT INTO products (product_name, price, in_stock, category, release_date, attributes)
VALUES
('Gaming Laptop', 1500.00, TRUE, 'Electronics', '2024-09-10', '{"color": "black", "warranty": "2 years"}'),
('Office Chair', 250.99, TRUE, 'Furniture', '2023-11-02', '{"material": "mesh", "height_adjustable": true}'),
('Wireless Mouse', 19.99, TRUE, 'Accessories', '2024-02-20', '{"color": "white"}');


/* ------------------------------------------------------------
   2. More Constraints — NOT NULL, DEFAULT, CHECK
------------------------------------------------------------ */

-- Adding constraints to existing table (orders)
ALTER TABLE orders
MODIFY amount DECIMAL(10,2) NOT NULL;          -- Cannot be NULL

ALTER TABLE orders
ADD CONSTRAINT chk_amount CHECK (amount > 0);   -- Must be positive

ALTER TABLE orders
MODIFY product_name VARCHAR(100) DEFAULT 'Unknown Product';  -- Default value


/* ------------------------------------------------------------
   3. More JOIN Types — RIGHT JOIN, CROSS JOIN
------------------------------------------------------------ */

-- RIGHT JOIN: shows all orders even if user record is missing
SELECT 
    o.order_id,
    o.product_name,
    u.first_name
FROM orders o
RIGHT JOIN users u ON o.user_id = u.user_id;

-- CROSS JOIN: Cartesian product (useful for combinations)
SELECT 
    u.first_name,
    p.product_name
FROM users u
CROSS JOIN products p;


/* ------------------------------------------------------------
   4. Advanced Filtering — LIKE, BETWEEN, IN, EXISTS, REGEXP
------------------------------------------------------------ */

-- LIKE with wildcards
SELECT * FROM users
WHERE first_name LIKE 'J%';   -- Names starting with J

-- BETWEEN for range filtering
SELECT * FROM products
WHERE price BETWEEN 20 AND 1000;

-- IN operator
SELECT * FROM products
WHERE category IN ('Electronics', 'Accessories');

-- REGEXP pattern match
SELECT * FROM users
WHERE email REGEXP '@example\.com$';

-- EXISTS (checks if a user has at least one order)
SELECT * FROM users u
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.user_id = u.user_id
);


/* ------------------------------------------------------------
   5. Subqueries — Scalar, Correlated, Subquery in FROM
------------------------------------------------------------ */

-- SCALAR subquery (returns a single value)
SELECT 
    u.user_id,
    u.first_name,
    (SELECT COUNT(*) FROM orders o WHERE o.user_id = u.user_id) AS order_count
FROM users u;

-- CORRELATED subquery (depends on outer query)
SELECT 
    p.product_name,
    (
        SELECT AVG(price)
        FROM products p2
        WHERE p2.category = p.category
    ) AS avg_category_price
FROM products p;

-- Subquery in FROM (derived table)
SELECT 
    category,
    avg_price
FROM (
    SELECT category, AVG(price) AS avg_price
    FROM products
    GROUP BY category
) AS category_stats;


/* ------------------------------------------------------------
   6. Set Operations — UNION, UNION ALL
------------------------------------------------------------ */

-- UNION removes duplicates
SELECT product_name FROM products
UNION
SELECT product_name FROM orders;

-- UNION ALL keeps duplicates
SELECT product_name FROM products
UNION ALL
SELECT product_name FROM orders;


/* ------------------------------------------------------------
   7. UPDATE and DELETE using JOIN
------------------------------------------------------------ */

-- UPDATE using JOIN
UPDATE users u
JOIN orders o ON u.user_id = o.user_id
SET u.last_name = 'Premium Customer'
WHERE o.amount > 500;

-- DELETE using JOIN
DELETE o
FROM orders o
JOIN users u ON o.user_id = u.user_id
WHERE u.first_name = 'John';


/* ------------------------------------------------------------
   8. Transactions — COMMIT, ROLLBACK
   Important for data integrity during critical operations
------------------------------------------------------------ */

START TRANSACTION;

-- Example operations
UPDATE products SET price = price * 1.10 WHERE category = 'Electronics';
DELETE FROM orders WHERE amount < 20;

-- If everything is correct:
COMMIT;

-- If something went wrong (use instead of COMMIT):
-- ROLLBACK;


/* ------------------------------------------------------------
   END OF INTERMEDIATE SQL EXTENSION
------------------------------------------------------------ */
