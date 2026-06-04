-- Comparison Operator = It is used to compare two things.
-- '=': 
SELECT *
FROM customers
WHERE country = 'Germany';

-- '!= or <>':
SELECT *
FROM customers
WHERE country <> 'Germany';

-- '>':
SELECT * 
FROM customers
WHERE score > 500;

-- '>=':
SELECT *
FROM customers
WHERE score >= 500

-- '<':
SELECT *
FROM customers
WHERE score < 500

-- '<=':
SELECT *
FROM customers
WHERE score <= 500


-- Logical Operator 
-- 'AND': All conditions must be true.
SELECT *
FROM customers
WHERE country = 'USA' AND score > 500

-- 'OR': Atleast one condition must be true.
SELECT *
FROM customers
WHERE country = 'USA' OR score > 500

-- 'NOT': It excludes the matching values.
SELECT *
FROM customers
WHERE NOT score < 500


-- Range Operator
-- 'BETWEEN': Check if a value is within a range.
SELECT *
FROM customers
WHERE score BETWEEN 100 AND 500;


-- Membership Operator
-- 'IN': Check if a value exist in a list.
SELECT *
FROM customers
WHERE country IN ('Germany', 'USA');

-- 'NOT IN': Check if a value is not exist in a list.
SELECT *
FROM customers
WHERE country NOT IN ('Germany', 'USA');


-- Search Operator
/* 'LIKE': Search for a pattern in a text.
In this we have two symbols: 
	% = many characters or 1 or 0
	_ = exact 1 character
*/
-- First_name starts with M
SELECT * 
FROM customers
WHERE first_name LIKE 'M%'

-- First_name ends with n
SELECT * 
FROM customers
WHERE first_name LIKE '%n'

-- First_name contains r
SELECT * 
FROM customers
WHERE first_name LIKE '%r%'

-- First_name has r in the 3rd position
SELECT * 
FROM customers
WHERE first_name LIKE '__r%'