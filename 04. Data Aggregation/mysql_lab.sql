-- Lab: Data Aggregation --

-- 1. Departments Info
SELECT e.department_id, COUNT(e.id) AS employees_count
FROM employees AS e
GROUP BY e.department_id
ORDER BY department_id ASC, employees_count ASC;


-- 2. Average Salary
SELECT e.department_id, ROUND(AVG(e.salary), 2) AS 'Average Salary'
FROM employees AS e
GROUP BY e.department_id
ORDER BY e.department_id ASC;


-- 3. Min Salary
SELECT e.department_id, ROUND(MIN(e.salary), 2) AS min_salary
FROM employees AS e
GROUP BY e.department_id
HAVING min_salary > 800;


-- 4. Appetizers Count
SELECT COUNT(category_id) FROM products
WHERE category_id = 2 AND price > 8.0
GROUP BY category_id;


-- 5. Menu Prices
SELECT p.category_id, 
ROUND(AVG(price), 2) AS 'Average Price', 
ROUND(MIN(price), 2) AS 'Cheapest Product', 
ROUND(MAX(price), 2) AS 'Most Expensive Product'
FROM products AS p
GROUP BY p.category_id;