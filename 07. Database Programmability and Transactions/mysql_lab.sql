-- Lab: Database Programmability and Transactions --

-- 1. Count Employees by Town
DELIMITER $$

CREATE FUNCTION ufn_count_employees_by_town (town_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE employees_count INT;
    
    SELECT COUNT(e.employee_id) INTO employees_count
    FROM employees e
    JOIN addresses a ON e.address_id = a.address_id
    JOIN towns t ON t.town_id = a.town_id
    WHERE t.name = town_name;
    
    RETURN employees_count;
END;


-- 2. Employees Promotion
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN
UPDATE employees e
JOIN departments d ON e.department_id = d.department_id
SET salary = salary * 1.05
WHERE d.`name` = department_name;
END;


-- 3. Employees Promotion by ID

CREATE PROCEDURE usp_raise_salary_by_id(e_id INT)
BEGIN
UPDATE employees
SET salary = salary * 1.05
WHERE employee_id = e_id;
END;


-- 4. Triggered
CREATE TABLE deleted_employees(
employee_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30),
last_name VARCHAR(30),
middle_name VARCHAR(30),
job_title VARCHAR(30),
department_id INT,
salary DECIMAL (10, 2)
);

CREATE TRIGGER tr_deleted_employees
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
INSERT INTO deleted_employees (first_name, last_name, middle_name, job_title, department_id, salary)
VALUES(OLD.first_name, OLD.last_name, OLD.middle_name, OLD.job_title, OLD.department_id, OLD.salary);
END;