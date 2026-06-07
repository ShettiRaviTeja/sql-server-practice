-- Joins = It is used to join the columns of the multiple tables into one table.

-- Basic Join types:
-- INNER JOIN: Returns only matching rows from both tables.
SELECT * 
FROM customers AS a
INNER JOIN 
orders AS b
ON a.id = b.customer_id; 

-- Column Ambiguity: Add the table name before the column to avoid the confusion in joins with same-named columns.

-- LEFT JOIN: Returns all the rows from the left table and matching rows from the right table.
SELECT *
FROM orders AS o
LEFT JOIN customers AS c
ON c.id = o.customer_id;

-- RIGHT JOIN: Returns all rows from the right table and matching rows from the left table.
SELECT *
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id;

-- NOTE: LEFT JOIN is more important than the RIGHT JOIN. Most of the times we will use the left join in the real time. So focus more on the left join. We can get the same result as right join if we use left join by changing the order of tables.

-- FULL JOIN: Returns all the rows from both tables.
SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id

-- Advanced join types:
-- LEFT ANTI JOIN: Returns rows from the left table that has no match in the right. We don't have any particular syntax for this. We should use WHERE clause to filter after joining the tables using the left join.
SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL 

-- RIGHT ANTI JOIN: Returns rows from the right table that has no match in the left. Similarly, we will use the WHERE clause along with the LEFT JOIN.
SELECT *
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id IS NULL 

-- FULL ANTI JOIN: Returns only rows that don't match in either tables.
SELECT * 
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE 
	c.id IS NULL 
	OR 
	o.customer_id IS NULL


-- CHALLENGE: Get all customers along with their orders, but only for customers who have placed an order. (Without using INNER JOIN).
SELECT *
FROM customers AS c
FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE 
	c.id IS NOT NULL
	AND
	o.customer_id IS NOT NULL


-- CROSS JOIN: Combines every row from the left with every row from the right table. All possible combinations (Cartesian Join). No condition is needed to create this join.
SELECT *
FROM customers
CROSS JOIN orders


-- HOW TO CHOOSE THE CORRECT JOIN TYPE BASED ON THE SITUATION??? 
/*
If we want only matching rows, then we should use INNER JOIN.
If we want all rows:
	Only one table is important(master table): LEFT JOIN
	Both tables are important: FULL JOIN
If we want only unmatching rows:
	Only one table is important(master table): LEFT ANTI JOIN
	Both tables are important: FULL ANTI JOIN.
*/


/* USING SALESDB, RETRIEVE A LIST OF ALL ORDERS ALONG WITH THE RELATED CUSTOMER, PRODUCT AND EMPLOYEE DETAILS. FOR EACH ORDER DISPLAY:
Order ID, Customer's name, Product name, Sales, Price, Sales Person's name */

SELECT 
	o.OrderID,
	o.Sales,
	c.FirstName AS CustomerFirstName,
	c.LastName AS CustomerLastName,
	p.Product,
	p.Price,
	e.FirstName AS EmployeeFirstName,
	e.LastName AS EmployeeLastName
FROM Sales.orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID 