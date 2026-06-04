/* 
INSERT command is used to insert the values into the table manually.
If we want to enter the values for each and every column, then no need to mention the columns in the query.
Columns and values must be in the same order.
Always list columns explicitly for clarity and maintainability.
*/
INSERT INTO customers (id, first_name, country, score) 
VALUES 
	(6, 'Rosy', 'UK', NULL),
	(7, 'Baraa', 'USA', 950)

SELECT * FROM customers


/*
We can also insert using the SELECT command. From the source table to the target table.
Focus on the target table columns while writing the SELECT command.
*/
INSERT INTO persons (id, person_name, birth_date, phone)
SELECT 
	id,
	first_name,
	NULL,
	'Unknown'
FROM customers

SELECT * FROM persons