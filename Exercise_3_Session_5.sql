-- Tạo bảng customers bt3-ss5 check lai video bai giang
CREATE TABLE customers
(
    customer_id   SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city          VARCHAR(100)
);

-- Tạo bảng orders
CREATE TABLE orders
(
    order_id    SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers (customer_id),
    order_date  DATE NOT NULL,
    total_price NUMERIC(10, 2)
);

-- Tạo bảng order_items
CREATE TABLE order_items
(
    item_id    SERIAL PRIMARY KEY,
    order_id   INT REFERENCES orders (order_id),
    product_id INT            NOT NULL,
    quantity   INT            NOT NULL,
    price      NUMERIC(10, 2) NOT NULL
);

-- Insert dữ liệu vào bảng customers
INSERT INTO customers (customer_id, customer_name, city)
VALUES (1, 'Nguyễn Văn A', 'Hà Nội'),
       (2, 'Trần Thị B', 'Đà Nẵng'),
       (3, 'Lê Văn C', 'Hồ Chí Minh'),
       (4, 'Phạm Thị D', 'Hà Nội');

-- Insert dữ liệu vào bảng orders
INSERT INTO orders (order_id, customer_id, order_date, total_price)
VALUES (101, 1, '2024-12-20', 3000),
       (102, 2, '2025-01-05', 1500),
       (103, 1, '2025-02-10', 2500),
       (104, 3, '2025-02-15', 4000),
       (105, 4, '2025-03-01', 800);

-- Insert dữ liệu vào bảng order_items
INSERT INTO order_items (item_id, order_id, product_id, quantity, price)
VALUES (1, 101, 1, 2, 1500),
       (2, 102, 2, 1, 1500),
       (3, 103, 3, 5, 500),
       (4, 104, 2, 4, 1000);

SELECT c.customer_id, c.customer_name, SUM(o.total_price) total_revenue, COUNT(o.order_id) order_count
FROM orders o
         LEFT JOIN order_items ot ON o.order_id = ot.order_id
         RIGHT JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_price) > 2000;

SELECT AVG(total_revenue)
FROM (SELECT SUM(total_price) total_revenue
      FROM orders o
      GROUP BY o.customer_id) AS total_table;

SELECT c.customer_id, c.customer_name, SUM(o.total_price) total_revenue, COUNT(o.order_id) order_count
FROM orders o
         LEFT JOIN order_items ot ON o.order_id = ot.order_id
         RIGHT JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING SUM(o.total_price) > (SELECT AVG(total_revenue)
                             FROM (SELECT SUM(total_price) total_revenue
                                   FROM orders o
                                   GROUP BY o.customer_id) AS total_table);

SELECT c.city, SUM(total_price) total_revenue
FROM customers c
         LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 1;

SELECT c.customer_name, c.city, SUM(ot.quantity) total_quantity, SUM(o.total_price) total_revenue
FROM orders o
         INNER JOIN order_items ot ON o.order_id = ot.order_id
         INNER JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id;




