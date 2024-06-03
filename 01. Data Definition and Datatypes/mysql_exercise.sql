-- 0. Create Database
CREATE DATABASE minions;

USE minions;


-- 1. Create Tables
CREATE TABLE minions(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50),
age INT
);

CREATE TABLE towns(
town_id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50)
);


-- 2. Alter Minions Table
ALTER TABLE minions
ADD COLUMN town_id INT,
ADD CONSTRAINT town_id FOREIGN KEY (town_id) REFERENCES towns (id);


-- 3. Insert Records in Both Tables
INSERT INTO towns (id, `name`)
VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO minions (id, `name`, age, town_id) 
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);


-- 4. Truncate Table Minions
TRUNCATE TABLE minions;


-- 5. Drop All Tables
DROP TABLE minions;
DROP TABLE towns;


-- 6. Create Table People
CREATE TABLE people(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(200) NOT NULL,
picture LONGBLOB,
height DECIMAL (5, 2),
weight DECIMAL (5, 2),
gender ENUM('m', 'f') NOT NULL,
birthdate DATE NOT NULL,
biography TEXT,
CHECK (gender IN ('m', 'f'))
);

INSERT INTO people (`name`, picture, height, weight, gender, birthdate, biography)
VALUES
('Ivan', NULL, 1.77, 72, 'm', '2000-12-20', 'This is my biography 1'),
('Stan', NULL, 1.84, 88, 'm', '1999-11-19', 'This is my biography 2'),
('Galena', NULL, 1.64, NULL, 'f', '1998-10-18', 'This is my biography 3'),
('Nikol', NULL, 1.65, NULL, 'f', '1997-09-17', 'This is my biography 4'),
('Miro', NULL, 1.90, 90, 'm', '1996-08-16', 'This is my biography 5');


-- 7. Create Table Users
CREATE TABLE users(
id INT PRIMARY KEY AUTO_INCREMENT,
`username` VARCHAR(30) NOT NULL UNIQUE,
`password` VARCHAR(26) NOT NULL,
profile_picture LONGBLOB,
last_login_time DATETIME,
is_deleted BOOLEAN
);

INSERT INTO users (username, password, profile_picture, last_login_time, is_deleted)
VALUES 
('john_doe', 'password123', NULL, '2024-04-13 10:30:00', FALSE),
('alice_smith', 'secret456', NULL, '2024-04-12 18:45:00', FALSE),
('bob_jackson', 'myP@ssw0rd', NULL, '2024-04-14 08:00:00', TRUE),
('emma_wilson', 'abc123', NULL, '2024-04-11 14:20:00', FALSE),
('sam_jones', 'password!@#', NULL, '2024-04-10 09:15:00', FALSE);


-- 8. Change Primary Key
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users PRIMARY KEY(id, username);


-- 9. Set Default Value of a Field
ALTER TABLE users
MODIFY last_login_time DATETIME DEFAULT CURRENT_TIMESTAMP;


-- 10. Set Unique Field
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT PRIMARY KEY (id),
ADD UNIQUE (username);


-- 11. Movies Database
-- CREATE DATABASE movies;

CREATE TABLE directors(
id INT PRIMARY KEY AUTO_INCREMENT,
director_name VARCHAR(50) NOT NULL,
notes TEXT
);

CREATE TABLE genres(
id INT PRIMARY KEY AUTO_INCREMENT,
genre_name VARCHAR(50) NOT NULL,
notes TEXT
);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
category_name VARCHAR(50) NOT NULL,
notes TEXT
);

CREATE TABLE movies(
id INT PRIMARY KEY AUTO_INCREMENT,
title VARCHAR (100) NOT NULL,
director_id INT,
copyright_year YEAR,
length TIME,
genre_id INT,
category_id INT,
rating DECIMAL (3, 1),
notes TEXT

-- FOREIGN KEY (director_id) REFERENCES directors(id),
-- FOREIGN KEY (genre_id) REFERENCES genres(id),
-- FOREIGN KEY (category_id) REFERENCES categories(id)
);

INSERT INTO directors (director_name, notes) VALUES
('Christopher Nolan', 'Famous for directing Inception and The Dark Knight trilogy.'),
('Quentin Tarantino', 'Known for Pulp Fiction and Django Unchained.'),
('Steven Spielberg', 'Renowned director of Jurassic Park and E.T.'),
('Greta Gerwig', 'Director of Lady Bird and Little Women.'),
('Martin Scorsese', 'Director of The Wolf of Wall Street and Goodfellas.');

INSERT INTO genres (genre_name, notes) VALUES
('Action', 'Films involving high-intensity sequences, often including physical combat or chase scenes.'),
('Drama', 'Focused on character development and emotional themes.'),
('Comedy', 'Intended to provoke laughter and provide entertainment.'),
('Science Fiction', 'Speculative fiction based on imagined future scientific or technological advances.'),
('Horror', 'Designed to scare or startle the audience with elements of fear and terror.');

INSERT INTO categories (category_name, notes) VALUES
('Adventure', 'Films that involve thrilling journeys or exploration.'),
('Romance', 'Focused on romantic relationships and love stories.'),
('Thriller', 'Intense films designed to keep viewers on the edge of their seats.'),
('Animation', 'Movies created using animation techniques, often targeting younger audiences.'),
('Crime', 'Involves criminal activities, investigations, or law enforcement.');

INSERT INTO movies (title, director_id, copyright_year, length, genre_id, category_id, rating, notes) VALUES
('Inception', 1, 2010, '02:28:00', 1, 1, 8.8, 'Mind-bending thriller by Christopher Nolan.'),
('Pulp Fiction', 2, 1994, '02:34:00', 2, 5, 8.9, 'Classic crime drama directed by Quentin Tarantino.'),
('Jurassic Park', 3, 1993, '02:07:00', 1, 1, 8.1, 'Iconic sci-fi adventure film by Steven Spielberg.'),
('Lady Bird', 4, 2017, '01:34:00', 2, 2, 7.4, 'Coming-of-age drama directed by Greta Gerwig.'),
('The Wolf of Wall Street', 5, 2013, '03:00:00', 3, 5, 8.2, 'Biographical black comedy directed by Martin Scorsese.');


-- 12. Car Rental Database
-- CREATE DATABASE car_rental;

-- USE car_rental;

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    daily_rate DECIMAL(10, 2) NOT NULL,
    weekly_rate DECIMAL(10, 2) NOT NULL,
    monthly_rate DECIMAL(10, 2) NOT NULL,
    weekend_rate DECIMAL(10, 2) NOT NULL
);

CREATE TABLE cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(20) NOT NULL,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    car_year INT NOT NULL,
    category_id INT NOT NULL,
    doors INT NOT NULL,
    picture LONGBLOB,
    car_condition VARCHAR(100),
    available BOOLEAN NOT NULL DEFAULT TRUE
 --   FOREIGN KEY (category_id) REFERENCES categories(id)
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    title VARCHAR(50),
    notes TEXT
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    driver_licence_number VARCHAR(20) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    zip_code VARCHAR(20),
    notes TEXT
);


CREATE TABLE rental_orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    customer_id INT,
    car_id INT,
    car_condition VARCHAR(255),
    tank_level DECIMAL(5, 2), 
    kilometrage_start INT,
    kilometrage_end INT,
    total_kilometrage INT,
    start_date DATE,
    end_date DATE,
    total_days INT,
    rate_applied DECIMAL(10, 2), 
    tax_rate DECIMAL(5, 2), 
    order_status VARCHAR(50),
    notes TEXT
 --   FOREIGN KEY (employee_id) REFERENCES employees(id), 
 --   FOREIGN KEY (customer_id) REFERENCES customers(id), 
 --   FOREIGN KEY (car_id) REFERENCES cars(id) 
);

INSERT INTO categories (category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
VALUES
    ('Economy', 40.00, 250.00, 800.00, 120.00),
    ('Compact', 45.00, 280.00, 900.00, 130.00),
    ('SUV', 60.00, 380.00, 1200.00, 180.00);


INSERT INTO cars (plate_number, make, model, car_year, category_id, doors, car_condition, available)
VALUES
    ('ABC123', 'Toyota', 'Corolla', 2019, 2, 4, 'Excellent', TRUE),
    ('XYZ789', 'Honda', 'Civic', 2020, 2, 4, 'Good', TRUE),
    ('DEF456', 'Ford', 'Escape', 2018, 3, 4, 'Fair', TRUE);


INSERT INTO employees (first_name, last_name, title, notes)
VALUES
    ('John', 'Doe', 'Manager', 'Available Mon-Fri'),
    ('Jane', 'Smith', 'Sales Associate', 'Part-time'),
    ('Mike', 'Johnson', 'Mechanic', 'Certified technician');

INSERT INTO customers (driver_licence_number, full_name, address, city, zip_code, notes)
VALUES
    ('DL123456', 'Alice Johnson', '123 Main St', 'Anytown', '12345', NULL),
    ('DL789012', 'Bob Williams', '456 Elm St', 'Otherville', '54321', 'Preferred customer'),
    ('DL345678', 'Eve Brown', '789 Oak St', 'Sometown', '67890', 'Frequent renter');


INSERT INTO rental_orders (employee_id, customer_id, car_id, car_condition, tank_level, kilometrage_start, kilometrage_end, total_kilometrage, start_date, end_date, total_days, rate_applied, tax_rate, order_status, notes)
VALUES
    (1, 1, 1, 'Clean interior', 75.0, 10000, 10200, 200, '2024-04-01', '2024-04-04', 3, 45.00, 10.0, 'Completed', NULL),
    (2, 2, 2, 'Minor scratches', 80.0, 5000, 5200, 200, '2024-04-05', '2024-04-10', 5, 45.00, 10.0, 'Completed', 'Regular customer'),
    (3, 3, 3, 'Needs oil change', 60.0, 20000, 20100, 100, '2024-04-10', '2024-04-15', 5, 60.00, 10.0, 'Completed', 'Scheduled maintenance');


-- 13. Basic Insert
-- CREATE DATABASE soft_uni;

-- USE soft_uni;

CREATE TABLE towns(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40)
);

CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
address_text TEXT,
town_id INT NOT NULL,
FOREIGN KEY (town_id) REFERENCES towns(id)
);

CREATE TABLE departments(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40)
);

CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(40) NOT NULL,
middle_name VARCHAR(40),
last_name VARCHAR(40) NOT NULL,
job_title VARCHAR(50) NOT NULL,
department_id INT NOT NULL,
hire_date DATE,
salary DECIMAL(10, 2),
address_id INT,
FOREIGN KEY (department_id) REFERENCES departments(id),
FOREIGN KEY (address_id) REFERENCES addresses(id)
);


INSERT INTO towns (`name`) 
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO departments (`name`) 
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);


-- 14. Basic Select All Fields
SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;


-- 15. Basic Select All Fields and Order Them
SELECT * FROM towns ORDER BY `name` ASC;
SELECT * FROM departments ORDER BY `name` ASC;
SELECT * FROM employees ORDER BY salary DESC;


-- 16. Basic Select Some Fields
SELECT `name` FROM towns ORDER BY `name` ASC;
SELECT `name` FROM departments ORDER BY `name` ASC;
SELECT first_name, last_name, job_title, salary FROM employees ORDER BY salary DESC;


-- 17. Increase Employees Salary
UPDATE employees
SET salary = salary * 1.1;

SELECT salary FROM employees;

-- 18. Delete All Records
TRUNCATE TABLE occupancies;
