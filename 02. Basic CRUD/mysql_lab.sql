-- Lab: Basic CRUD --


-- Problem 1: Select Employee Information
SELECT id, first_name, last_name, job_title FROM employees ORDER BY id;


-- Problem 2: Select Employees with Filter
SELECT id, CONCAT(first_name, ' ', last_name) AS full_name, job_title, salary FROM employees
WHERE salary > 1000.00;


-- Problem 3: Update Employees Salary
UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';

SELECT salary FROM employees;


-- Problem 4: Top Paid Employee
CREATE VIEW v_most_paid_employee AS
SELECT * FROM employees ORDER BY salary DESC LIMIT 1;

SELECT *  FROM v_most_paid_employee;


-- Problem 5: Select Employees by Multiple Filters
SELECT * FROM employees WHERE department_id = 4 AND salary >= 1000;


-- Problem 6: Delete from Table
DELETE FROM employees WHERE department_id = 2 OR department_id = 1;
SELECT * FROM employees;