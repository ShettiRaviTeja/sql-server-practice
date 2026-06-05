-- Joins = It is used to join the columns of the multiple tables into one table.
-- INNER JOIN: Returns only matching rows from both tables.
SELECT * 
FROM customers AS a
INNER JOIN 
orders AS b
ON a.id = b.customer_id; 