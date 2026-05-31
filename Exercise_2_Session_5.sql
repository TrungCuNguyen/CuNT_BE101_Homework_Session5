-- Tạo bảng products
CREATE TABLE products
(
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category     VARCHAR(50)
);

-- Tạo bảng orders
CREATE TABLE orders
(
    order_id    SERIAL PRIMARY KEY,
    product_id  INT REFERENCES products (product_id),
    quantity    INT,
    total_price NUMERIC(10, 2)
);

-- Chèn dữ liệu vào bảng products
INSERT INTO products (product_id, product_name, category)
VALUES (1, 'Laptop Dell', 'Electronics'),
       (2, 'IPhone 15', 'Electronics'),
       (3, 'Bàn học gỗ', 'Furniture'),
       (4, 'Ghế xoay', 'Furniture');

-- Chèn dữ liệu vào bảng orders
INSERT INTO orders (order_id, product_id, quantity, total_price)
VALUES (101, 1, 2, 2200),
       (102, 2, 3, 3300),
       (103, 3, 5, 2500),
       (104, 4, 4, 1600),
       (105, 1, 1, 1100);

SELECT product_name, SUM(total_price) total_revenue
FROM products p
         LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id
HAVING SUM(total_price) = (SELECT SUM(total_price) total_revenue
                           FROM orders o
                           GROUP BY o.product_id
                           ORDER BY total_revenue DESC
                           LIMIT 1)
ORDER BY total_revenue DESC
LIMIT 1;

SELECT category, SUM(total_price) total_revenue
FROM products p
         LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category;