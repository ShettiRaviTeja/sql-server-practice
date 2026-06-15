/* Performance Tips: 
=> For small - medium tables, the query optimizer may react similarly to different query styles.
=> *** Always check the execution plan to confirm performance improvements when optimizing your query. If there's no improvement, then just focus on readability. */

-- ================================================================================
-- Tip 1: Select Only What You Need
SELECT * 
FROM Sales.Customers; -- Bad

SELECT 
	FirstName, 
	LastName, 
	Country 
FROM Sales.Customers; -- Good

-- =================================================================================
-- Tip 2: Avoid unnecessary DISTINCT & ORDER BY
SELECT DISTINCT 
	FirstName
FROM Sales.Customers
ORDER BY FirstName;  -- Bad

SELECT FirstName
FROM Sales.Customers; -- Good

-- =================================================================================
-- Tip 3: For exploration purpose, Limit Rows
SELECT
	OrderID,
	Sales
FROM Sales.Orders -- Bad

SELECT TOP 5
	OrderID,
	Sales
FROM Sales.Orders -- Good

-- =================================================================================
-- Tip 4: Create nonclustered index on frequently used columns in WHERE clause.
SELECT *
FROM Sales.Orders 
WHERE OrderStatus = 'Delivered' 

CREATE INDEX idx_Orders_OrderStatus ON Sales.Orders (OrderStatus)

-- =================================================================================
-- Tip 5: Avoid applying functions to columns in WHERE Clause.
-- Functions on columns can block index usage.
SELECT *
FROM Sales.Orders
WHERE LOWER(OrderStatus) = 'Shipped' -- Bad 

SELECT *
FROM Sales.Orders
WHERE OrderStatus = 'Shipped' -- Good

SELECT *
FROM Sales.Customers
WHERE SUBSTRING(FirstName, 1, 1) = 'A' -- Bad

SELECT *
FROM Sales.Customers
WHERE FirstName LIKE 'A%' -- Good

SELECT *
FROM Sales.Orders
WHERE YEAR(OrderDate) = 2025 -- Bad

SELECT *
FROM Sales.Orders
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-12-31' -- Good

-- =================================================================================
-- Tip 6: Avoid using leading wildcards, as they prevent index usage
SELECT *
FROM Sales.Customers
WHERE LastName LIKE '%GOLD%' -- Bad

SELECT *
FROM Sales.Customers
WHERE LastName LIKE 'GOLD%' -- Good

-- =================================================================================
-- Tip 7: Use IN instead of multiple OR
SELECT * 
FROM Sales.Orders
WHERE CustomerID = 1 OR CustomerID = 2 OR CustomerID = 3 -- Bad

SELECT * 
FROM Sales.Orders
WHERE CustomerID IN (1, 2, 3) -- Good

-- =================================================================================
-- Tip 8: Understand the speed of joins and use INNER JOIN when possible
-- Best Performance
SELECT o.OrderID, c.FirstName FROM Sales.Orders o INNER JOIN Sales.Customers c ON o.CustomerID = c.CustomerID 

-- Slightly Slower Performance
SELECT o.OrderID, c.FirstName FROM Sales.Orders o LEFT JOIN Sales.Customers c ON o.CustomerID = c.CustomerID 
SELECT o.OrderID, c.FirstName FROM Sales.Orders o RIGHT JOIN Sales.Customers c ON o.CustomerID = c.CustomerID 

-- Worst Performance
SELECT o.OrderID, c.FirstName FROM Sales.Orders o OUTER JOIN Sales.Customers c ON o.CustomerID = c.CustomerID

-- =================================================================================
-- Tip 9: Use Explicit Join (ANSI Join) Instead of Implicit Join (non-ANSI Join)
SELECT o.OrderID, c.FirstName 
FROM Sales.Orders o, Sales.Customers c 
WHERE o.CustomerID = c.CustomerID -- Bad 

SELECT o.OrderID, c.FirstName 
FROM Sales.Orders o 
INNER JOIN Sales.Customers c 
ON o.CustomerID = c.CustomerID -- Good

-- =================================================================================
-- Tip 10: Make sure to Index the columns used in the ON Clause
SELECT o.OrderID, c.FirstName 
FROM Sales.Orders o 
INNER JOIN Sales.Customers c 
ON o.CustomerID = c.CustomerID 

CREATE INDEX idx_Orders_CustomerID ON Sales.Orders (CustomerID)

-- =================================================================================
-- Tip 11: Better to filter data before joining (Big Tables). Try to isolate the preparation step in a CTE or subquery.

-- =================================================================================
-- Tip 12: Aggregate before joining (Big Tables)

-- =================================================================================
-- Tip 13: Use UNION instead of OR in Joins
SELECT o.OrderID, c.FirstName
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
OR o.SalesPersonID = c.CustomerID; -- Bad

SELECT o.OrderID, c.FirstName
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
UNION
SELECT o.OrderID, c.FirstName
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.SalesPersonID = c.CustomerID; -- Good

-- ==================================================================================
-- Tip 14: Check for nested loops and use SQL Hints
SELECT o.OrderID, c.FirstName
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID

-- Good practice for having Big table and small table
SELECT o.OrderID, c.FirstName
FROM Sales.Orders o
INNER JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
OPTION (HASH JOIN)

-- ===================================================================================
-- Tip 15: Use UNION ALL Instead of using UNION if Duplicates are acceptable

-- ===================================================================================
-- Tip 16: Use UNION ALL + DISTINCT instead of UNION if Duplicates are not acceptable

-- ===================================================================================
-- Tip 17: Use Columnstore Index for Aggregations on Large Table

-- ===================================================================================
-- Tip 18: Pre-Aggregate Data and store it in new table for reporting (CTAS or Tables)

-- ===================================================================================
