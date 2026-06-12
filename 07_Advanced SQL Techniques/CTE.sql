/* CTE - Common Table Expression: Temporary, named result set(virtual table), that can be used multiple times within your query to simplify and organize complex query.
=> It is identical to Subquery but the intermediate result is used only once in the subquery.
=> Whereas in CTE, the result is stored in the virtual table and it is used in any place within the query.
=> By using CTE, we can reduce the redundancy of the query.
=> It will provide, 
				    - Modularity
					- Readability
					- Reusability
=> The result table of the CTE is stored in the cache.
=> We can use anything in the CTE like SELECT, FROM, WHERE, GROUP BY, HAVING, WINDOW_FUNCTIONS.... But only one thing we cannot use directly within the CTE, that is ORDER BY.
=> Syntax:
			WITH CTE_NAME AS
			(
				SELECT ...
				FROM...
				WHERE...
			)
			This is the CTE definition.

=> To access the CTE,
			SELECT ...
			FROM CTE_NAME
			WHERE...

=> We have 2 types of CTE:
	1. None - Recursive CTE
		- Standalone CTE
		- Nested CTE
	2. Recursive CTE


1. None-Recursive CTE: Executed only once without any repetition.
- Standalone CTE: Defined and used independently. Runs independently as it's self-contained and doesn't rely on other CTE's or queries.
	- Multiple Standalone CTE: We can define multiple standalone CTE's by using comma(,) between them.
- Nested CTE: CTE inside another CTE. A nested CTE uses the result of another CTE, so it can't run independently.
	Syntax:	
			WITH CTE_NAME1 AS
			(
				SELECT...
				FROM...						--------> This is Standalone CTE
				WHERE...
			),
			CTE_NAME2 AS
			(
				SELECT...
				FROM CTE_NAME1				--------> This is Nested CTE
				WHERE...
			)

2. Recursive CTE: Self-referencing query that repeatedly processes data until a specific condition is met.
=> CTE will generate one result, that result is checked by the CTE itself and see whether it reached specific condition or not. If not, it will interact again with database and retrieve data until the specific condition is reached.
=> Syntax:
			WITH CTE_NAME AS
			(
				SELECT...
				FROM...				--------> Anchor Query
				WHERE...

				UNION ALL

				SELECT...
				FROM CTE_NAME		--------> Recursive Query
				WHERE [Break Condition]
			)
=> It will execute the Anchor Query only once and keep looping the Recursive Query until certain condition is met.


CTE Best Practices: 
	1. Rethink and refactor your CTEs before starting a new one.
	2. Don't use more than 5 CTEs in one query; Otherwise, your code will be hard to understand and maintain. 
 */

-- MINI PROJECT:

-- Step 1 - Find the total sales per customer. (Standalone CTE)
/* WITH Total_Sales_CTE AS
(
SELECT 
	CustomerID,
	SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)

-- Step 2 - Find the last order date per customer. (Standalone CTE)
, Last_Order_CTE AS
(
SELECT
	CustomerID,
	MAX(OrderDate) LastOrderDate
FROM Sales.Orders
GROUP BY CustomerID
)

-- Step 3: Rank customers based on total sales per customer. (Nested CTE)
, Customer_Rank_CTE AS
(
SELECT
	CustomerID,
	TotalSales,
	RANK() OVER(ORDER BY TotalSales DESC) CustomerRank 
FROM Total_Sales_CTE
)

-- Step 4: Segment customers based on their total sales. (Nested CTE)
, Customer_Segment_CTE AS
(
SELECT
	CustomerID,
	TotalSales,
	CASE
		WHEN TotalSales > 100 THEN 'High'
		WHEN TotalSales > 80 THEN 'Medium'
		ELSE 'Low'
	END CustomerSegments
FROM Total_Sales_CTE
)

-- Main Query
SELECT 
	c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.TotalSales,
	clo.LastOrderDate,
	csr.CustomerRank,
	css.CustomerSegments
FROM Sales.Customers c
LEFT JOIN Total_Sales_CTE cts
ON cts.CustomerID = c.CustomerID 
LEFT JOIN Last_Order_CTE clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN Customer_Rank_CTE csr
ON csr.CustomerID = c.CustomerID
LEFT JOIN Customer_Segment_CTE css
ON css.CustomerID = c.CustomerID */

-- Task 1: Generate a sequence of Numbers from 1 to 20
/* WITH Number_Generate_CTE AS
(
	-- Anchor Query
	SELECT 
	1 My_Number
	UNION ALL
	-- Recursive Query
	SELECT
	My_Number + 1
	FROM Number_Generate_CTE
	WHERE My_Number < 20
)

-- Main Query
SELECT * FROM Number_Generate_CTE
OPTION (MAXRECURSION 20) -- By using this, we can set a limit of recursions. Default limit is 100. */

-- Task 2: Show the employee hierarchy by displaying each employee's level within the organization.
WITH EMP_Hierarchy_CTE AS
( 
-- Anchor Query
SELECT
EmployeeID,
FirstName,
ManagerID,
1 Level
FROM Sales.Employees
WHERE ManagerID IS NULL
UNION ALL
-- Recursive Query
SELECT
e.EmployeeID,
e.FirstName,
e.ManagerID,
Level + 1
FROM Sales.Employees e
INNER JOIN EMP_Hierarchy_CTE ceh
ON ceh.EmployeeID = e.ManagerID 
)

SELECT * FROM EMP_Hierarchy_CTE
ORDER BY EmployeeID

-- Important Point: The JOIN operation in a recursive CTE works exactly like a normal JOIN. The difference is that one side of the JOIN is the recursive CTE, whose contents change after each iteration. The JOIN repeatedly uses the newly generated rows from the CTE to find the next level of related rows.