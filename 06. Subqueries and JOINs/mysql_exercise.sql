-- Exercises: Subqueries and JOINs --

-- 1. Employee Address
SELECT e.employee_id, e.job_title, e.address_id, a.address_text
FROM employees e JOIN addresses a ON e.address_id = a.address_id
ORDER BY address_id ASC
LIMIT 5;


-- 2. Addresses with Towns
SELECT e.first_name, e.last_name, t.`name`, a.address_text 
FROM employees e JOIN addresses a ON e.address_id = a.address_id JOIN towns t ON t.town_id = a.town_id
ORDER BY first_name ASC, last_name ASC
LIMIT 5;


--  3. Sales Employee
SELECT e.employee_id, e.first_name, e.last_name, d.`name`
FROM employees e JOIN departments d ON e.department_id = d.department_id
WHERE d.`name` = 'Sales'
ORDER BY e.employee_id DESC;


-- 4. Employee Departments
SELECT e.employee_id, e.first_name, e.salary, d.`name` 
FROM employees e JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;


-- 5. Employees Without Project
SELECT e.employee_id, e.first_name 
FROM employees e LEFT JOIN employees_projects ep ON e.employee_id = ep.employee_id
WHERE e.employee_id NOT IN (SELECT employee_id FROM employees_projects)
ORDER BY employee_id DESC
LIMIT 3;


-- 6. Employees Hired After
SELECT e.first_name, e.last_name, e.hire_date, d.`name` 
FROM employees e JOIN departments d ON e.department_id = d.department_id
WHERE e.hire_date > 1999-01-01 AND d.`name` IN ('Sales', 'Finance')
ORDER BY e.hire_date ASC;


-- 7. Employees with Project
SELECT e.employee_id, e.first_name, p.`name`
FROM employees e JOIN employees_projects ep ON e.employee_id = ep.employee_id JOIN projects p ON p.project_id = ep.project_id
WHERE DATE(p.start_date) > '2002-08-13' AND p.end_date IS NULL
ORDER BY e.first_name ASC, p.`name` ASC
LIMIT 5;


-- 8. Employee 24
SELECT e.employee_id, e.first_name, IF(YEAR(p.start_date) >= 2005, NULL, p.`name`)
FROM employees e JOIN employees_projects ep ON e.employee_id = ep.employee_id JOIN projects p ON p.project_id = ep.project_id
WHERE ep.employee_id = 24
ORDER BY e.first_name ASC, p.`name` ASC
LIMIT 5;


-- 9. Employee Manager
SELECT e.employee_id, e.first_name, e.manager_id, m.first_name AS manager_name
FROM employees e JOIN employees m ON e.manager_id = m.employee_id
WHERE e.manager_id IN (3, 7)
ORDER BY e.first_name ASC;


-- 10. Employee Summary  
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, 
CONCAT(m.first_name, ' ', m.last_name) AS manager_name, d.`name`
FROM employees e JOIN employees m ON e.manager_id = m.employee_id
JOIN departments d ON e.department_id = d.department_id
ORDER BY e.employee_id ASC
LIMIT 5;


-- 11. Min Average Salary
SELECT AVG(salary) average_salary
FROM employees 
GROUP BY department_id
ORDER BY average_salary ASC
LIMIT 1;


-- 12. Highest Peaks in Bulgaria
SELECT mc.country_code, m.mountain_range, p.peak_name, p.elevation
FROM mountains_countries mc JOIN mountains m ON mc.mountain_id = m.id JOIN peaks p ON m.id = p.mountain_id
WHERE mc.country_code = 'BG' AND p.elevation > 2835
ORDER BY p.elevation DESC;


-- 13. Count Mountain Ranges
SELECT mc.country_code, COUNT(m.mountain_range) AS mountain_range
FROM mountains_countries mc JOIN mountains m ON mc.mountain_id = m.id
GROUP BY mc.country_code
HAVING mc.country_code IN ('US', 'RU', 'BG')
ORDER BY mountain_range DESC;



-- 14. Countries with Rivers
SELECT c.country_name, r.river_name 
FROM countries c LEFT JOIN countries_rivers cr ON c.country_code = cr.country_code LEFT JOIN rivers r ON r.id = cr.river_id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name ASC
LIMIT 5;


-- 15. *Continents and Currencies  
SELECT d1.continent_code, d1.currency_code, d1.currency_usage FROM 
	(SELECT `c`.`continent_code`, `c`.`currency_code`,
    COUNT(`c`.`currency_code`) AS `currency_usage` FROM countries as c
	GROUP BY c.currency_code, c.continent_code HAVING currency_usage > 1) as d1
LEFT JOIN 
	(SELECT `c`.`continent_code`,`c`.`currency_code`,
    COUNT(`c`.`currency_code`) AS `currency_usage` FROM countries as c
	 GROUP BY c.currency_code, c.continent_code HAVING currency_usage > 1) as d2
ON d1.continent_code = d2.continent_code AND d2.currency_usage > d1.currency_usage
 
WHERE d2.currency_usage IS NULL
ORDER BY d1.continent_code, d1.currency_code;


-- 16. Countries Without Any Mountains
SELECT COUNT(*) FROM countries
WHERE country_code NOT IN (SELECT country_code FROM mountains_countries);


-- 17. Highest Peak and Longest River by Country
SELECT c.country_name, MAX(p.elevation) AS highest_peak_elevation, MAX(r.length) AS longest_river_length
FROM countries c 
RIGHT JOIN mountains_countries mc ON c.country_code = mc.country_code
RIGHT JOIN peaks p ON p.mountain_id = mc.mountain_id
RIGHT JOIN countries_rivers cr ON c.country_code = cr.country_code
RIGHT JOIN rivers r ON r.id = cr.river_id
GROUP BY c.country_code
ORDER BY highest_peak_elevation DESC, longest_river_length DESC, c.country_name ASC
LIMIT 5;










































