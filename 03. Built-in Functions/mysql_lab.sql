-- Lab: Built-in Functions --

-- 1. Find Book Titles
SELECT title FROM books 
WHERE SUBSTRING(title, 1, 3) = 'The'
ORDER BY id ASC;


-- 2. Replace Titles
SELECT REPLACE(title, 'The' , '***') AS 'Title' FROM books
WHERE SUBSTRING(title, 1, 3) = 'The'
ORDER BY id ASC;


-- 3. Sum Cost of All Books
SELECT ROUND(SUM(cost), 2) AS 'Total cost' FROM books;


-- 4. Days Lived
SELECT CONCAT(first_name, ' ', last_name) AS 'Full Name', 
TIMESTAMPDIFF(DAY, born, died) AS 'Days Lived'
FROM authors;


-- 5. Harry Potter Books
SELECT title FROM books 
WHERE title LIKE 'Harry Potter%';
