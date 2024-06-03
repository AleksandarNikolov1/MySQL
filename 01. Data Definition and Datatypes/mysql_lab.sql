-- Lab: Data Definition and Data Types


-- 0. Create New Database
CREATE DATABASE gamebar;
USE gamebar;


-- 1. Create Tables
CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL
);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL
);

CREATE TABLE products(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL,
category_id INT NOT NULL
);


-- 2. Insert Data in Tables
INSERT INTO employees (first_name, last_name) 
VALUES 
('Ivan', 'Ivanov'),
('Kostadin', 'Kostadinov'),
('Georgi', 'Dimitrov');


-- 3. Alter Tables
ALTER TABLE employees 
ADD COLUMN middle_name VARCHAR(50) NOT NULL;


-- 4. Adding Constraints
ALTER TABLE products
ADD CONSTRAINT FOREIGN KEY (category_id) REFERENCES categories (id);


-- 5. Modifying Columns
ALTER TABLE employees
MODIFY COLUMN middle_name VARCHAR(100);


