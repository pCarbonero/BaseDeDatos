--CONSULTAS

--1
SELECT title, price, notes FROM titles
WHERE type = 'mod_cook'

--2 
SELECT * From jobs
SELECT job_id, job_desc, max_lvl, min_lvl FROM jobs
WHERE min_lvl <= 110 AND max_lvl >= 110

--3
SELECT * From titles
SELECT title, title_id, type From titles
WHERE titles.notes like '%and%'

--4
Select * From publishers
Select pub_name, city From publishers
WHERE country like 'USA' AND city NOT LIKE 'California' AND city NOT LIKE 'Texas'

--5
Select title, price, title_id from titles
WHERE (type like 'psychology' or type like 'business') AND price between 10 and 20

--6
SElect * FROM authors
Select au_fname, au_lname, address from authors
WHERE city NOT LIKE 'California' OR city NOT LIKE 'Oregón'

--7
Select au_fname, au_lname, address from authors
WHERE au_lname LIKE 'D%' OR au_lname LIKE 'G%' OR au_lname LIKE 'S%'

--8
SELECT * FROM employee
Select emp_id, job_lvl, fname, lname from employee
WHERE job_lvl < 100

--MODIFICACIONES

--1
INSERT into authors 
values ('420-69-1994', 'Way', 'Gerard', '420 069-1111', '48 Cleveland Av. #13', 'San Jose', 'CA', '95128', 1) 

SELECT * FROM authors

--2


SELECT * FROM titleauthor

--3
UPDATE jobs
SET min_lvl = 90
WHERE min_lvl > 90

SELECT * FROM jobs

--4
INSERT INTO publishers (pub_id, pub_name, city, country) 
VALUES('9908', 'Mostachon Books', 'Sevilla', 'Spain')

SELECT * FROM publishers

--5
UPDATE publishers
SET city = 'Stuttgart' WHERE pub_name = 'GGG&G'

UPDATE publishers
SET pub_name = 'Machen Wücher' WHERE pub_name = 'GGG&G'