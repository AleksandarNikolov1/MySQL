-- MySQL Retake Exam

-- SoftUni Game Dev Branch -- 

-- Section 0: Database Overview

-- Section 1: Data Definition Language (DDL) – 40 pts

-- 1. Table Design

CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL
);

CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(10) NOT NULL
);

CREATE TABLE offices(
id INT PRIMARY KEY AUTO_INCREMENT,
workspace_capacity INT NOT NULL,
website VARCHAR(50) NOT NULL,
address_id INT NOT NULL,

FOREIGN KEY(address_id) REFERENCES addresses(id)
);

CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
age INT NOT NULL,
salary DECIMAL(10, 2) NOT NULL,
job_title VARCHAR(20) NOT NULL,
happiness_level CHAR(1) NOT NULL
);

CREATE TABLE teams(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL,
office_id INT NOT NULL,
leader_id INT NOT NULL UNIQUE,

FOREIGN KEY (office_id) REFERENCES offices(id),
FOREIGN KEY (leader_id) REFERENCES employees(id)
);

CREATE TABLE games(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL UNIQUE,
`description` TEXT NOT NULL,
rating FLOAT NOT NULL DEFAULT(5.5),
budget DECIMAL (10, 2) NOT NULL,
release_date DATE,
team_id INT NOT NULL,

FOREIGN KEY (team_id) REFERENCES teams(id)
);

CREATE TABLE games_categories(
game_id INT NOT NULL,
category_id INT NOT NULL,

PRIMARY KEY (game_id, category_id),
FOREIGN KEY (game_id) REFERENCES games(id),
FOREIGN KEY (category_id) REFERENCES categories(id)
);


-- Section 2: Data Manipulation Language (DML) – 30 pts

-- 2. Insert
INSERT INTO games (`name`, rating, budget, team_id)
SELECT SUBSTRING(LOWER(REVERSE(t.`name`)), 2),
t.id, t.leader_id * 1000.00, t.id 
FROM teams t
WHERE t.id BETWEEN 1 AND 9;


-- 3. Update 
UPDATE employees e
SET e.salary = e.salary + 1000
WHERE e.id IN (SELECT leader_id FROM teams)
AND e.age < 40
AND e.salary <= 5000;


-- 4. Delete
DELETE FROM games g
WHERE g.release_date IS NULL
AND g.id NOT IN (SELECT game_id FROM games_categories);


-- 5. Employees
SELECT first_name, last_name, age, salary, happiness_level
FROM employees 
ORDER BY salary ASC, id ASC;


-- 6. Addresses of the teams
SELECT t.`name`, a.`name`, LENGTH(a.`name`) AS count_of_characters
FROM teams t 
JOIN offices o ON t.office_id = o.id
JOIN addresses a ON o.address_id = a.id
WHERE o.website IS NOT NULL
ORDER BY t.`name` ASC, a.`name` ASC;


-- 7. Categories Info
SELECT c.`name`, COUNT(g.id) AS games_count, ROUND(AVG(g.budget), 2) AS avg_budget,
MAX(g.rating) AS max_rating 
FROM categories c 
JOIN games_categories gc ON gc.category_id = c.id
JOIN games g ON gc.game_id = g.id
GROUP BY c.id
HAVING max_rating >= 9.5
ORDER BY games_count DESC, c.`name` ASC;


-- 8. Games of 2022
SELECT g.`name`, g.release_date, CONCAT(SUBSTRING(g.`description`, 1, 10), '...'), 
CASE
        WHEN MONTH(g.release_date) IN (1, 2, 3) THEN 'Q1'
        WHEN MONTH(g.release_date) IN (4, 5, 6) THEN 'Q2'
        WHEN MONTH(g.release_date) IN (7, 8, 9) THEN 'Q3'
        ELSE 'Q4'
    END AS `quarter`,
t.`name`
FROM games g JOIN teams t ON t.id = g.team_id
WHERE YEAR(g.release_date) = 2022
AND SUBSTRING(g.`name`, LENGTH(g.`name`)) = '2'
AND MONTH(g.release_date) % 2 = 0
ORDER BY `quarter`;


-- 9. Full info for games
SELECT g.`name`, 
CASE 
WHEN g.budget < 50000 THEN 'Normal budget'
ELSE 'Insufficient budget'
END AS budget_level,
t.`name`, a.`name`
FROM games g 
JOIN teams t ON g.team_id = t.id
JOIN offices o ON t.office_id = o.id
JOIN addresses a ON o.address_id = a.id
WHERE g.release_date IS NULL AND g.id NOT IN (SELECT game_id FROM games_categories)
ORDER BY g.`name` ASC;


-- 10. Find all basic information for a game
DELIMITER $$

CREATE FUNCTION udf_game_info_by_name (game_name VARCHAR (20))
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE game_info TEXT;
    
    SELECT CONCAT('The ', g.`name`, ' is developed by a ', t.`name`, 
    ' in an office with an address ', a.`name`) INTO game_info
    FROM games g 
    JOIN teams t ON g.team_id = t.id
    JOIN offices o ON t.office_id = o.id
    JOIN addresses a ON o.address_id = a.id
    WHERE g.`name` = game_name;
    
    RETURN game_info;
END;

  
-- 11. Update Budget of the Games
CREATE PROCEDURE udp_update_budget(min_game_rating FLOAT) 
BEGIN
   UPDATE games g 
   SET g.budget = g.budget + 100000,
   g.release_date = DATE_ADD(g.release_date, INTERVAL 1 YEAR)
   WHERE g.id NOT IN (SELECT game_id FROM games_categories) 
   AND g.rating > min_game_rating
   AND g.release_date IS NOT NULL;
END;























































