-- Exercises: Database Programmability and Transactions -- 

-- Part I – Queries for SoftUni Database

-- 1. Employees with Salary Above 35000
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
SELECT first_name, last_name 
FROM employees
WHERE salary > 35000
ORDER BY first_name ASC, last_name ASC, employee_id ASC;
END;


-- 2. Employees with Salary Above Number
CREATE PROCEDURE usp_get_employees_salary_above(salary DECIMAL(10, 4))
BEGIN
SELECT e.first_name, e.last_name 
FROM employees e
WHERE e.salary >= salary
ORDER BY e.first_name ASC, e.last_name ASC, e.employee_id ASC;
END;


-- 3. Town Names Starting With
CREATE PROCEDURE usp_get_towns_starting_with(str VARCHAR(10))
BEGIN
SELECT t.`name`
FROM towns t
WHERE t.`name` LIKE CONCAT(str, '%')
ORDER BY t.`name` ASC;
END;


-- 4. Employees from Town
CREATE PROCEDURE usp_get_employees_from_town (town_name VARCHAR(50))
BEGIN
SELECT e.first_name, e.last_name 
FROM employees e 
JOIN addresses a ON e.address_id = a.address_id
JOIN towns t ON t.town_id = a.town_id
WHERE t.`name` = town_name
ORDER BY e.first_name ASC, e.last_name ASC, e.employee_id ASC;
END;


-- 5. Salary Level Function
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(19, 4))
RETURNS VARCHAR(20)
BEGIN
    DECLARE salary_level VARCHAR(20);
    
    SET salary_level = CASE
        WHEN salary < 30000 THEN 'Low'
        WHEN salary BETWEEN 30000 AND 50000 THEN 'Average'
        WHEN salary > 50000 THEN 'High'
        ELSE 'Unknown' 
    END;
    
    RETURN salary_level;
END;


-- 6. Employees by Salary Level
CREATE FUNCTION ufn_get_salary_level(salary DOUBLE)
RETURNS VARCHAR(50)
BEGIN
	DECLARE result VARCHAR(50);
	SET result = (CASE WHEN salary < 30000 THEN 'Low'
		 WHEN salary BETWEEN 30000 AND 50000 THEN 'Average'
		 ELSE 'High' END);
	RETURN result;
END;

CREATE PROCEDURE usp_get_employees_by_salary_level(sal_level VARCHAR(50))
BEGIN 
	SELECT first_name, last_name FROM employees
	WHERE ufn_get_salary_level(salary) = sal_level
	ORDER BY first_name DESC, last_name DESC;
END;


-- 7. Define Function
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS INT
BEGIN
	   DECLARE result INT;
       DECLARE counter INT;
       DECLARE letter VARCHAR(30);
       
       SET result = 1;
       SET counter = 0;
       
       REPEAT 
		SET letter = SUBSTRING(word, counter, 1);
		SET result = IF(set_of_letters NOT LIKE CONCAT('%', letter, '%'), 0, 1);
		SET counter = counter + 1;
	UNTIL result = 0 OR counter = CHAR_LENGTH(word) + 1
	END REPEAT;
	RETURN result;
END;


-- PART II – Queries for Bank Database

-- 8. Find Full Name
CREATE PROCEDURE usp_get_holders_full_name ()
BEGIN 
	SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM account_holders
	ORDER BY full_name ASC, id ASC;
END;


-- 9. People with Balance Higher Than
CREATE PROCEDURE usp_get_holders_with_balance_higher_than (num INT)
BEGIN 
	SELECT ah.first_name, ah.last_name
    FROM account_holders ah JOIN accounts a ON ah.id = a.account_holder_id
    GROUP BY ah.id 
    HAVING SUM(a.balance) > num
	ORDER BY ah.id ASC;
END;


-- 10. Future Value Function
CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(19, 4), yearly_interest_rate DECIMAL(10, 4), years INT)
RETURNS DECIMAL(19, 4)
BEGIN
	DECLARE result DECIMAL(19, 4);
    SET result = sum * POW((1 + yearly_interest_rate), years);
	RETURN result;
END;


-- 11. Calculating Interest
CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(19, 4), yearly_interest_rate DECIMAL(10, 4), years INT)
RETURNS DECIMAL(19, 4)
BEGIN
	DECLARE result DECIMAL(19, 4);
    SET result = sum * POW((1 + yearly_interest_rate), years);
	RETURN result;
END;


CREATE PROCEDURE usp_calculate_future_value_for_account (account_id INT, interest_rate DOUBLE)
BEGIN 
	SELECT a.id, ah.first_name, ah.last_name, a.balance AS current_balance,
	ufn_calculate_future_value(a.balance, interest_rate, 5) AS balance_in_5_years
	FROM accounts a
	JOIN account_holders ah ON a.account_holder_id = ah.id
	WHERE a.id = account_id;
END;


-- 12. Deposit Money
CREATE PROCEDURE usp_deposit_money (account_id INT, money_amount DECIMAL(19, 4))
BEGIN
START TRANSACTION;
	CASE WHEN money_amount < 0 
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts a
		SET a.balance = a.balance + money_amount
		WHERE a.id = account_id;
	END CASE;
COMMIT;
END; 


-- 13. Withdraw Money
CREATE PROCEDURE usp_withdraw_money (account_id INT, money_amount DECIMAL(19, 4))
BEGIN
START TRANSACTION;
	CASE WHEN money_amount < 0 OR money_amount > (SELECT balance FROM accounts WHERE id = account_id)
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts a
		SET a.balance = a.balance - money_amount
		WHERE a.id = account_id;
	END CASE;
COMMIT;
END;


-- 14. Money Transfer
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(20,4))
BEGIN
	START TRANSACTION;
	CASE WHEN ((SELECT a.id FROM accounts a WHERE a.id = from_account_id) IS NULL)
			OR ((SELECT a.id FROM accounts a WHERE a.id = to_account_id) IS NULL)
			OR from_account_id = to_account_id
			OR amount < 0 
			OR amount > (SELECT a.balance 
                         FROM accounts a
                         WHERE a.id = from_account_id)
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts a
		SET a.balance = a.balance - amount
		WHERE a.id = from_account_id;
		UPDATE accounts a
		SET a.balance = a.balance + amount
		WHERE a.id = to_account_id;
	END CASE;
	COMMIT;
END; 


-- 15. Log Accounts Trigger
CREATE TABLE `logs`(
log_id INT PRIMARY KEY AUTO_INCREMENT,
account_id INT NOT NULL,
old_sum DECIMAL(19, 4) NOT NULL,
new_sum DECIMAL(19, 4) NOT NULL
);

CREATE TRIGGER log_balance_changes AFTER UPDATE ON accounts 
FOR EACH ROW
BEGIN
	CASE 
		WHEN OLD.balance != NEW.balance THEN 
		INSERT INTO `logs`(account_id, old_sum, new_sum)
		VALUES (OLD.id, OLD.balance, NEW.balance);
	ELSE
		BEGIN END;
	END CASE;
END;


-- 16. Emails Trigger
CREATE TABLE `logs`(
log_id INT PRIMARY KEY AUTO_INCREMENT,
account_id INT NOT NULL,
old_sum DECIMAL(19, 4) NOT NULL,
new_sum DECIMAL(19, 4) NOT NULL
);

CREATE TRIGGER log_balance_changes AFTER UPDATE ON accounts 
FOR EACH ROW
BEGIN
	CASE 
		WHEN OLD.balance != NEW.balance THEN 
		INSERT INTO `logs`(account_id, old_sum, new_sum)
		VALUES (OLD.id, OLD.balance, NEW.balance);
	ELSE
		BEGIN END;
	END CASE;
END;


CREATE TABLE notification_emails(
id INT PRIMARY KEY AUTO_INCREMENT,
recipient INT NOT NULL,
`subject` TEXT NOT NULL,
body TEXT NOT NULL
);

CREATE TRIGGER create_notification_email AFTER INSERT ON `logs` 
FOR EACH ROW
BEGIN 
	INSERT INTO notification_emails (recipient, `subject`, body)
	VALUES 
    (NEW.account_id, 
    CONCAT('Balance change for account: ', NEW.account_id),
	CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y'), ' at ', DATE_FORMAT(NOW(), '%r'),
	' your account balance was changed from ', NEW.old_sum, ' to ', NEW.new_sum, '.'));
END;







































































