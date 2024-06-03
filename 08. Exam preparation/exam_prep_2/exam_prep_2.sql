-- MySQL Exam Preparation 2

-- Triple S – SoftUni Stores System

-- Section 0: Database Overview

-- Section 1: Data Definition Language (DDL) – 40 pts

-- 1. Table Design

CREATE TABLE towns(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL UNIQUE,
town_id INT NOT NULL,

FOREIGN KEY (town_id) REFERENCES towns(id)
);

CREATE TABLE stores(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL UNIQUE,
rating FLOAT NOT NULL,
has_parking TINYINT(1) DEFAULT(0),
address_id INT NOT NULL,

FOREIGN KEY (address_id) REFERENCES addresses(id)
);

CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(15) NOT NULL,
middle_name CHAR(1),
last_name VARCHAR(20) NOT NULL,
salary DECIMAL (19, 2) DEFAULT(0),
hire_date DATE NOT NULL,
manager_id INT,
store_id INT NOT NULL,

FOREIGN KEY(store_id) REFERENCES stores(id),
FOREIGN KEY(manager_id) REFERENCES employees(id)
);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE pictures(
id INT PRIMARY KEY AUTO_INCREMENT,
url VARCHAR(100) NOT NULL,
added_on DATETIME NOT NULL
);

CREATE TABLE products(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE,
best_before DATE,
price DECIMAL(10, 2) NOT NULL,
`description` TEXT,
category_id INT NOT NULL,
picture_id INT NOT NULL,

FOREIGN KEY(category_id) REFERENCES categories(id),
FOREIGN KEY(picture_id) REFERENCES pictures(id)
);

CREATE TABLE products_stores(
product_id INT NOT NULL,
store_id INT NOT NULL,

PRIMARY KEY(product_id, store_id),
FOREIGN KEY(product_id) REFERENCES products(id),
FOREIGN KEY(store_id) REFERENCES stores(id)
);


-- Section 2: Data Manipulation Language (DML) – 30 pts

-- 2. Insert
INSERT INTO products_stores(product_id, store_id)
SELECT p.id, 1 AS store_id
FROM products p LEFT JOIN products_stores ps ON p.id = ps.product_id
WHERE p.id NOT IN (SELECT product_id FROM products_stores);


-- 3. Update
UPDATE employees e 
JOIN stores s ON s.id = e.store_id
SET e.manager_id = 3, e.salary = e.salary - 500
WHERE YEAR(e.hire_date) > 2003 AND s.`name` NOT IN ('Cardguard', 'Veribet');


-- 4. Delete
DELETE FROM employees 
WHERE manager_id IS NOT NULL AND salary >= 6000;


-- 5. Employees
SELECT first_name, middle_name, last_name, salary, hire_date 
FROM employees
ORDER BY hire_date DESC;


-- 6. Products with old pictures
SELECT p.`name`, p.price, p.best_before, CONCAT(SUBSTRING(p.`description`, 1, 10), '...') 
AS short_description, ps.url
FROM products p
JOIN pictures ps ON ps.id = p.picture_id
WHERE LENGTH(`description`) > 100 
AND YEAR(ps.added_on) < 2019
AND p.price > 20
ORDER BY p.price DESC;


-- 7. Counts of products in stores and their average 
SELECT s.`name`, COUNT(p.id) AS product_count, ROUND(AVG(p.price), 2) AS average_price
FROM stores s 
LEFT JOIN products_stores ps ON s.id = ps.store_id
LEFT JOIN products p ON p.id = ps.product_id
GROUP BY s.id
ORDER BY product_count DESC, average_price DESC, s.id ASC; 


-- 8. Specific employee
SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name,
s.`name`, a.`name`, e.salary
FROM employees e 
JOIN stores s ON s.id = e.store_id
JOIN addresses a ON a.id = s.address_id
WHERE e.salary < 4000
AND a.`name` LIKE '%5%'
AND LENGTH(s.`name`) > 8
AND e.last_name LIKE '%n'; 


-- 9. Find all information of stores
SELECT REVERSE(s.`name`) AS reversed_name,
CONCAT(UPPER(t.`name`), '-', a.`name`) AS full_address,
COUNT(e.id) AS employees_count
FROM stores s  
JOIN addresses a ON a.id = s.address_id
JOIN towns t ON t.id = a.town_id
JOIN employees e ON s.id = e.store_id
GROUP BY e.store_id
ORDER BY full_address ASC;


-- Section 4: Programmability – 30 pts

-- 10. Find name of top paid employee by store name
DELIMITER $$

CREATE FUNCTION udf_top_paid_employee_by_store (store_name VARCHAR(50))
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE employee_info TEXT;
    
    SELECT CONCAT(e.first_name, ' ', e.middle_name, '.', ' ', e.last_name, ' works in store for ',
    TIMESTAMPDIFF(YEAR, e.hire_date, '2020-10-18'), ' years') INTO employee_info
    FROM employees e
    JOIN stores s ON e.store_id = s.id
    WHERE s.`name` = store_name
    ORDER BY salary DESC
    LIMIT 1;
    
    RETURN employee_info;
END;


-- 11. Update product price by address
CREATE PROCEDURE udp_update_product_price(address_name VARCHAR(50))
BEGIN
   UPDATE products p 
   JOIN products_stores ps ON p.id = ps.product_id
   JOIN stores s ON s.id = ps.store_id
   JOIN addresses a ON a.id = s.address_id
   SET p.price = CASE 
			WHEN LEFT(a.`name`, 1) = '0' THEN p.price + 100
			ELSE p.price + 200
			END
   WHERE a.`name` = address_name;
END;









































