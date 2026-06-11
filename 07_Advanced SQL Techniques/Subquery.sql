/* Subquery: Query inside the another query.
=> We have different categories:
1. Dependancy: We have 2 types of subqueries
			   i. Non-Correlated Subquery
			   ii. Correlated Subquery
2. Result Types: i. Scalar Subquery
				 ii. Row Subquery
				 iii. Table Subquery
3. Location / Clauses: i. SELECT
					   ii. FROM 
					   iii. JOIN
					   iv. WHERE (Comparison and Logical Operators)


Lets start exploring:
2. Result Types:
	i. Scalar Subquery: It will return the single value as an output.
	ii. Row Subquery: Multiple rows and single column.
	iii. Table Subquery: Multiple rows and multiple columns.

3. Location / Clauses: 
	- Subquery in FROM Clause: 
		SELECT column1, column2...
		FROM 
		(
		SELECT column FROM table1 WHERE condition
		) AS alias
 
Task 1: Find the products that have a price higher than the average price of all products. */
-- Main Query
SELECT 
*
FROM
	-- Sub Query
	(SELECT
	*,
	AVG(Price) OVER() AvgPrice
	FROM Sales.Products) t
WHERE Price > AvgPrice

-- Task 2: Rank customers based on their total amount of sales.
-- Main query
SELECT
*,
RANK() OVER(ORDER BY TotalSalesByCustomer DESC) CustomerRank 
FROM
	-- Sub query
	(SELECT 
	CustomerID,
	SUM(Sales) TotalSalesByCustomer
	FROM Sales.Orders
	GROUP BY CustomerID)t

/* The result of the intermediate subquery will go and store in the cache.
The main query will access the result of subquery by interacting with cache.
After execution of everything and getting result, the database engine will go and clean the cache.

	- Subquery in SELECT Clause: Used to aggregate data side by side with the main query's data, allowing for direct comparison.
		SELECT
			column1,
			(SELECT column FROM table1 WHERE condition) AS alias
		FROM table1
	Rule: Only scalar subqueries are allowed to be used.
	=> Subquery is executed first.
Task 3: Show the ProductID's, names, prices and total number of orders. */
-- Main query
SELECT
ProductID,
Product,
Price,
-- Sub query
(SELECT COUNT(OrderID) FROM Sales.Orders) TotalOrders
FROM Sales.Products


/* Subquery in JOIN Clause: Used to prepare the data(filtering or aggregation) before joining it with other tables.
Task 4: Show all customer details and find the total orders for each customer. */
-- Main Query
SELECT 
c.*,
o.NrofOrders
FROM Sales.Customers c
LEFT JOIN(
	-- Sub Query
	SELECT 
	CustomerID,
	COUNT(OrderID) NrofOrders
	FROM Sales.Orders
	GROUP BY CustomerID)o
ON c.CustomerID = o.CustomerID

/* Subquery in WHERE Clause: Used for complex filtering logic and makes query more flexible and dynamic.
=> In this we have 2 operators:
	Comparison Operator - Used to filter data by comparing two values.
	Logical Operator

Task 5: Find the products that have a price higher than the average price of all products. */
SELECT
ProductID,
Product,
Price
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

/* Subquery in IN Operator: IN Operator will go and check whether a value matches any value from a list.
Task 6: Show the details of orders made by customers who are from Germany. */
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany')

/* ANY Operator: Checks if a value matches any value within a list. Used to check if a value is true for atleast one of the values in a list.
Task 7: Find female employees whose salaries are greater than the salaries of any male employees. */

SELECT
	EmployeeID, 
	FirstName, 
	Salary
FROM Sales.Employees 
WHERE Gender = 'F'
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

/* ALL Operator: Check if a value matches all values within a list.
Task 8: Find female employees whose salaries are greater than the salaries of all male employees. */
SELECT
	EmployeeID, 
	FirstName, 
	Salary
FROM Sales.Employees 
WHERE Gender = 'F'
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')


/* Non-Correlated and Correlated Subquery: 
Non-Correlated Subquery: A Subquery that can run independently from the main query.
Correlated Subquery: A Subquery that relays on values from the main query.

Example task for Correlated Subquery: Show all customer details and find the total orders of each customer. */
SELECT *,
(SELECT COUNT(OrderID) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) TotalOrders
FROM Sales.Customers c

/* Correlated Subqueries EXISTS:
Check if a subquery returns any rows .
Task 9: Show the details of orders made by customers in Germany. */
SELECT *
FROM Sales.Orders o
WHERE EXISTS(
			SELECT 1
			FROM Sales.Customers c
			WHERE Country = 'Germany' AND c.CustomerID = o.CustomerID)