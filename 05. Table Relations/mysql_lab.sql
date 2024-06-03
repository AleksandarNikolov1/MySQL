-- Lab: Table Relations --

-- 1. Mountains and Peaks
CREATE TABLE mountains(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50)
);

CREATE TABLE peaks(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50),
mountain_id INT NOT NULL,
CONSTRAINT fk_mountain_id FOREIGN KEY (mountain_id) REFERENCES mountains(id)
);


-- 2. Trip Organization
SELECT v.driver_id, v.vehicle_type, CONCAT(c.first_name, ' ', c.last_name) AS 'driver_name'
FROM vehicles v JOIN campers c 
ON c.id = v.driver_id;


-- 3. SoftUni Hiking
SELECT r.starting_point, r.end_point, c.id, CONCAT(c.first_name, ' ', c.last_name) AS 'leader_name'
FROM routes r JOIN campers c ON c.id = r.leader_id;


-- 4. Delete Mountains
CREATE TABLE mountains(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50)
);

CREATE TABLE peaks(
id INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50),
mountain_id INT NOT NULL,
CONSTRAINT fk_mountain_id FOREIGN KEY (mountain_id) REFERENCES mountains(id)
ON DELETE CASCADE
);


-- 5. Project Management DB*
CREATE TABLE clients(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
client_name VARCHAR(100)
);

CREATE TABLE employees(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30),
last_name VARCHAR(30),
project_id INT(11),

CONSTRAINT fk_project_id FOREIGN KEY (project_id) REFERENCES projects(id)
);

CREATE TABLE projects(
id INT(11) PRIMARY KEY AUTO_INCREMENT,
client_id INT(11) NOT NULL,
project_lead_id INT(11) NOT NULL,

CONSTRAINT fk_client_id FOREIGN KEY (client_id) REFERENCES clients(id),
CONSTRAINT fk_project_lead_id FOREIGN KEY (project_lead_id) REFERENCES employees(id)
);