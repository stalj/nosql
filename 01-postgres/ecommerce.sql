-- 1. Cleanup
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- 2. Schema Creation
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,
    order_date DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('PENDING', 'COMPLETED', 'CANCELLED'))
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    product_name VARCHAR(100) NOT NULL,
    quantity INT CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) CHECK (unit_price > 0)
);

-- 3. Data Insertion
INSERT INTO customers (full_name, country) VALUES
('Alice Smith', 'USA'),
('Bob Jones', 'Poland'),
('Charlie Brown', 'Germany'),
('Diana Prince', 'USA');

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2026-09-01', 'COMPLETED'),
(1, '2026-09-10', 'COMPLETED'),
(2, '2026-09-05', 'COMPLETED'),
(2, '2026-09-12', 'PENDING'),
(3, '2026-09-08', 'CANCELLED'),
(4, '2026-09-11', 'COMPLETED');

INSERT INTO order_items (order_id, product_name, quantity, unit_price) VALUES
(1, 'Laptop', 1, 1200.00),
(1, 'Mouse', 2, 25.00),
(2, 'Monitor', 1, 300.00),
(3, 'Keyboard', 1, 80.00),
(3, 'Mouse', 1, 25.00),
(4, 'Webcam', 1, 60.00),
(5, 'Desk Lamp', 1, 45.00),
(6, 'Headphones', 2, 150.00);

