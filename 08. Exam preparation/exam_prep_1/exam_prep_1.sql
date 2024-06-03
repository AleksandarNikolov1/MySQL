-- MySQL Exam Preparation 1

-- Football Scout Database

-- Section 0: Database Overview

-- Section 1: Data Definition Language (DDL) – 40 pts

-- 1. Table Design

CREATE TABLE countries(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL
);

CREATE TABLE towns(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45),
country_id INT(11)
);

CREATE TABLE stadiums(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
capacity INT(11) NOT NULL,
town_id INT(11) NOT NULL,

CONSTRAINT fk_town_id FOREIGN KEY(town_id) REFERENCES towns(id)
);

CREATE TABLE teams(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
established DATE NOT NULL,
fan_base BIGINT(20) NOT NULL DEFAULT 0,
stadium_id INT(11),

CONSTRAINT fk_stadium_id FOREIGN KEY (stadium_id) REFERENCES stadiums(id)
);

CREATE TABLE skills_data(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
dribbling INT(11) DEFAULT 0,
pace INT(11) DEFAULT 0,
passing INT (11) DEFAULT 0,
shooting INT (11) DEFAULT 0,
speed INT(11) DEFAULT 0,
strength INT (11) DEFAULT 0
);

CREATE TABLE players(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
age INT(11) NOT NULL DEFAULT 0,
position CHAR(1) CHECK (position IN ('A', 'M', 'D')) NOT NULL,
salary DECIMAL(10, 2) NOT NULL,
hire_date DATETIME,
skills_data_id INT(11) NOT NULL,
team_id INT(11),

CONSTRAINT fk_skills_data_id FOREIGN KEY (skills_data_id) REFERENCES skills_data(id),
CONSTRAINT fk_team_id FOREIGN KEY (team_id) REFERENCES teams(id)
);

CREATE TABLE coaches(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(10) NOT NULL,
last_name VARCHAR(20) NOT NULL,
salary DECIMAL(10, 2) NOT NULL DEFAULT 0,
coach_level INT(11) NOT NULL DEFAULT 0
);

CREATE TABLE players_coaches(
player_id INT(11),
coach_id INT(11),

CONSTRAINT pk_players_coaches PRIMARY KEY (player_id, coach_id),
CONSTRAINT fk_player_id FOREIGN KEY (player_id) REFERENCES players(id),
CONSTRAINT fk_coach_id FOREIGN KEY (coach_id) REFERENCES coaches(id)
);


-- Section 2: Data Manipulation Language (DML) – 30 pts

-- 2. Insert
INSERT INTO coaches(first_name, last_name, salary, coach_level)
SELECT first_name, last_name, salary, LENGTH(first_name) AS coach_level 
FROM players
WHERE age >= 45;

-- 3. Update
UPDATE coaches c
JOIN players_coaches pc ON c.id = pc.coach_id 
SET c.coach_level = c.coach_level + 1
WHERE SUBSTRING(first_name, 1, 1) = 'A' 
AND c.id IN (SELECT pc.coach_id FROM players_coaches);


-- 4. Delete
DELETE FROM players 
WHERE age >= 45;


-- Section 3: Querying – 50 pts

-- 5. Players
SELECT first_name, age, salary 
FROM players
ORDER BY salary DESC;


-- 6. Young offense players without contract
SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS full_name, p.age, p.position, p.hire_date
FROM players p JOIN skills_data sd ON p.skills_data_id = sd.id 
WHERE p.age < 23 AND p.position = 'A' AND p.hire_date IS NULL AND sd.strength > 50
ORDER BY p.salary ASC, p.age ASC;


-- 7. Detail info for all teams
SELECT t.`name`, t.established, t.fan_base, 
(SELECT COUNT(*) FROM players WHERE team_id = t.id) AS players_count_per_team
FROM teams t
ORDER BY players_count_per_team DESC, t.fan_base DESC;


-- 8. The fastest player by towns
SELECT MAX(sd.speed) AS max_speed, t2.`name` AS town_name
FROM skills_data sd
JOIN players p ON sd.id = p.skills_data_id
RIGHT JOIN teams t ON t.id = p.team_id
JOIN stadiums s ON s.id = t.stadium_id
RIGHT JOIN towns t2 ON t2.id = s.town_id
WHERE t.`name` != 'Devify'
GROUP BY t2.id
ORDER BY max_speed DESC, town_name ASC;


-- 9. Total salaries and players by country
SELECT c.`name`, COUNT(p.id) AS total_count_of_players, SUM(p.salary) AS total_sum_of_salaries
FROM countries c 
LEFT JOIN towns t ON c.id = t.country_id
LEFT JOIN  stadiums s ON t.id = s.town_id
LEFT JOIN teams te ON s.id = te.stadium_id
LEFT JOIN players p ON te.id = p.team_id
GROUP BY c.id
ORDER BY total_count_of_players DESC, c.`name` ASC;


-- Section 4: Programmability – 30 pts

-- 10. Find all players that play in the stadium
DELIMITER $$

CREATE FUNCTION udf_stadium_players_count (stadium_name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN

    DECLARE players_count_per_stadium INT;
    SELECT COUNT(p.id) INTO players_count_per_stadium
    FROM players p 
    JOIN teams t ON t.id = p.team_id
    JOIN stadiums s ON s.id = t.stadium_id
    WHERE s.`name` = stadium_name;
    
    RETURN players_count_per_stadium;
END;


-- 11. Find good playmakers by teams
CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT, team_name VARCHAR(45))
BEGIN
    SELECT CONCAT(p.first_name, ' ', p.last_name) AS full_name, 
           p.age, 
           p.salary, 
           sd.dribbling, 
           sd.speed,
           t.`name`
    FROM players p 
    JOIN skills_data sd ON sd.id = p.skills_data_id 
    JOIN teams t ON t.id = p.team_id
    WHERE sd.dribbling > min_dribble_points 
      AND t.`name` = team_name 
      AND sd.speed > (SELECT AVG(sd2.speed) 
                       FROM skills_data sd2
                       JOIN players p2 ON sd2.id = p2.skills_data_id
                       WHERE p2.team_id = p.team_id)
    ORDER BY sd.speed DESC
    LIMIT 1;
END;





















































