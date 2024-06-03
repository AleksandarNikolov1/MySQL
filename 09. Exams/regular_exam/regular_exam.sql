-- MySQL Exam

-- SoftUni Taxi Company

-- Section 0: Database Overview

-- Section 1: Data Definition Language (DDL) – 40 pts

-- 1. Table Design
CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(100) NOT NULL
);

CREATE TABLE clients(
id INT PRIMARY KEY AUTO_INCREMENT,
full_name VARCHAR(50) NOT NULL,
phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
age INT NOT NULL,
rating FLOAT DEFAULT(5.5)
);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(10) NOT NULL
);

CREATE TABLE cars(
id INT PRIMARY KEY AUTO_INCREMENT,
make VARCHAR(20) NOT NULL,
model VARCHAR(20) NOT NULL,
`year` INT NOT NULL DEFAULT (0),
mileage INT DEFAULT (0),
`condition` CHAR(1) NOT NULL,
category_id INT NOT NULL,

FOREIGN KEY(category_id) REFERENCES categories(id)
);

CREATE TABLE cars_drivers(
car_id INT NOT NULL,
driver_id INT NOT NULL,

PRIMARY KEY(car_id, driver_id),
FOREIGN KEY(car_id) REFERENCES cars(id),
FOREIGN KEY(driver_id) REFERENCES drivers(id)
);

CREATE TABLE courses(
id INT PRIMARY KEY AUTO_INCREMENT,
from_address_id INT NOT NULL,
`start` DATETIME NOT NULL,
car_id INT NOT NULL,
client_id INT NOT NULL,
bill DECIMAL(10, 2) NOT NULL DEFAULT(10),

FOREIGN KEY(from_address_id) REFERENCES addresses(id),
FOREIGN KEY(car_id) REFERENCES cars(id),
FOREIGN KEY(client_id) REFERENCES clients(id)
);


-- Section 2: Data Manipulation Language (DML) – 30 pts

-- 2. Insert
INSERT INTO clients (full_name, phone_number)
SELECT CONCAT(first_name, ' ', last_name) AS full_name, 
CONCAT('(088) 9999', id * 2) AS phone_number
FROM drivers 
WHERE id >= 10 AND id <= 20;


-- 3. Update
UPDATE cars 
SET `condition` = 'C'
WHERE mileage >= 800000 OR mileage IS NULL
AND `year` <= 2010
AND make != 'Mecedes-Benz';


-- 4. Delete 
DELETE FROM clients
WHERE id NOT IN (SELECT client_id FROM courses)
AND LENGTH(full_name) > 3; 


-- 5. Cars
SELECT make, model, `condition` 
FROM cars 
ORDER BY id ASC;


-- 6. Drivers and Cars
SELECT d.first_name, d.last_name, c.make, c.model, c.mileage
FROM drivers d 
JOIN cars_drivers cd ON d.id = cd.driver_id
JOIN cars c ON c.id = cd.car_id
WHERE c.mileage IS NOT NULL
ORDER BY c.mileage DESC, d.first_name ASC;


-- 7. Number of courses for each car
SELECT car.id, car.make, car.mileage, COUNT(co.id) AS count_of_courses, ROUND(AVG(co.bill), 2) AS avg_bill
FROM cars car
LEFT JOIN courses co ON car.id = co.car_id
GROUP BY car.id
HAVING count_of_courses != 2
ORDER BY count_of_courses DESC, car.id ASC;


-- 8. Regular clients
SELECT cl.full_name, COUNT(cars.id) AS count_of_cars, SUM(cr.bill) AS total_sum
FROM clients cl 
JOIN courses cr ON cl.id = cr.client_id
JOIN cars ON cars.id = cr.car_id
WHERE SUBSTRING(cl.full_name, 2, 1) = 'a'
GROUP BY cl.id
HAVING count_of_cars > 1
ORDER BY cl.full_name ASC;


-- 9. Full information on courses
SELECT addresses.`name`, 
CASE   
   WHEN HOUR(courses.`start`) >= 6 AND HOUR(courses.`start`) <= 20 THEN 'Day'
   ELSE 'Night'
END AS day_time,
courses.bill, clients.full_name, cars.make, cars.model, categories.`name`
FROM addresses 
JOIN courses ON addresses.id = courses.from_address_id
JOIN clients ON clients.id = courses.client_id
JOIN cars ON cars.id = courses.car_id
JOIN categories ON categories.id = cars.category_id
ORDER BY courses.id ASC;


-- Section 4: Programmability – 30 pts

-- 10. Find all courses by client's phone number
DELIMITER $$

CREATE FUNCTION udf_courses_by_client (phone_num VARCHAR (20))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE courses_count INT;
    
    SELECT COUNT(co.id) INTO courses_count
    FROM courses co 
    JOIN clients cl ON cl.id = co.client_id 
    WHERE cl.phone_number = phone_num
    GROUP BY co.client_id;
    
    RETURN courses_count;
END;


-- 11. Full info for address
CREATE PROCEDURE udp_courses_by_address(address_name VARCHAR(100))
BEGIN
   SELECT a.`name`, cl.full_name, 
   CASE 
   WHEN co.bill <= 20 THEN 'Low'
   WHEN co.bill <= 30 THEN 'Medium'
   ELSE 'High'
   END AS level_of_bill, 
   car.make, car.`condition`, cat.`name`
   FROM addresses a 
   JOIN courses co ON a.id = co.from_address_id
   JOIN cars car ON car.id = co.car_id
   JOIN clients cl ON cl.id = co.client_id
   JOIN categories cat ON cat.id = car.category_id
   WHERE a.`name` = address_name
   ORDER BY car.make ASC, cl.full_name ASC;

END;