CREATE TABLE customers
(
    customer_id   SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    city          VARCHAR(50)
);

-- Tạo bảng orders
CREATE TABLE orders
(
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customers (customer_id),
    order_date   DATE,
    total_amount NUMERIC(10, 2)
);

-- Tạo bảng order_items
CREATE TABLE order_items
(
    item_id      SERIAL PRIMARY KEY,
    order_id     INT REFERENCES orders (order_id),
    product_name VARCHAR(100),
    quantity     INT,
    price        NUMERIC(10, 2)
);


-- Thêm dữ liệu mẫu cho bảng customers
INSERT INTO customers (customer_name, city)
VALUES ('Nguyen Van A', 'Hanoi'),
       ('Tran Thi B', 'Ho Chi Minh'),
       ('Le Van C', 'Da Nang'),
       ('Pham Thi D', 'Hai Phong'),
       ('Hoang Van E', 'Can Tho');

-- Thêm dữ liệu mẫu cho bảng orders
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES (1, '2024-01-10', 250000.00),
       (2, '2024-02-15', 120000.00),
       (3, '2024-03-20', 500000.00),
       (4, '2024-04-05', 7500.00),
       (5, '2024-05-12', 300000.00);

-- Thêm dữ liệu mẫu cho bảng order_items
INSERT INTO order_items (order_id, product_name, quantity, price)
VALUES (1, 'Laptop Lenovo', 1, 250000.00),
       (2, 'Chuột Logitech', 2, 60000.00),
       (3, 'Điện thoại Samsung', 1, 500000.00),
       (4, 'Bàn phím cơ', 1, 7500.00),
       (5, 'Tai nghe Sony', 2, 150000.00);

SELECT c.customer_name AS "Tên khách hàng", o.order_date AS "Ngày đặt hàng", o.total_amount AS "Tổng tiền"
FROM customers c
         JOIN orders o ON c.customer_id = o.customer_id;

SELECT SUM(total_amount) "Tổng doanh thu",
       AVG(total_amount) "Trung bình giá trị đơn hàng",
       MAX(total_amount) "Đơn hàng lớn nhất",
       MIN(total_amount) "Đơn hàng nhỏ nhất",
       COUNT(order_id)   "Số lượng đơn hàng"
FROM orders;

SELECT c.city, SUM(total_amount) "Tổng doanh thu"
FROM orders o
         JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING SUM(total_amount) > 10000;

SELECT c.customer_name, o.order_date, i.quantity, i.price
FROM orders o
         JOIN customers c ON o.customer_id = c.customer_id
         JOIN order_items i ON i.order_id = o.order_id;

SELECT c.customer_name
FROM customers c
WHERE c.customer_id = (SELECT c.customer_id
                       FROM orders o
                                JOIN customers c ON o.customer_id = c.customer_id
                       GROUP BY c.customer_id
                       ORDER BY SUM(total_amount) DESC
                       LIMIT 1);


