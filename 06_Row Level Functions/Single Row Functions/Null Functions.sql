/* 4. Null Functions: NULL means nothing, unknown!
Null is not equal to anything.
- Null is not zero.
- Null is not blank space.
- Null is not empty string.

If we want to replace the NULL value with any other value, then we have 2 functions: ISNULL, COALESCE
If we want to replace the value with the NULL value, then we have function: NULLIF

REPLACE VALUES:
					NULL ----> Any value (ISNULL, COALESCE)
					Any value ----> NULL (NULLIF)

CHECK FOR NULLS:
					NULL ----> TRUE (IS NULL)
					NULL ----> FALSE (IS NOT NULL)
*/

-- ISNULL(): Replace NULL with a specified value.
	-- Syntax: ISNULL(value, replacement_value)
SELECT 
ISNULL(ShipAddress, 'UNKNOWN')
FROM Sales.Orders

-- COALESCE(): Returns the first non-null value from a list.
	-- Syntax: COALESCE(value1, value2, value3...)
-- If the first value is null then it will check the next value. If the second value is also null, then it will check the next value. At last if everything is Null, then we will keep the default value.
SELECT 
COALESCE(ShipAddress, BillAddress, 'N/A')
FROM Sales.Orders

/*
Comparison between ISNULL & COALESCE:
=> ISNULL is limited to two values. COALESCE is unlimited.
=> ISNULL is fast. COALESCE is slow.
=> ISNULL in different databases like:
	SQL Server = ISNULL
	Oracle = NVL
	MySQL = IFNULL
=> COALESCE = Available in all databases.
*/

-- Question 1: Find the average scores of the customers.
SELECT 
AVG(ISNULL(Score, 0)) OVER() AvgScore
FROM Sales.Customers 

-- Question 2: Display the full name of the customers in a single field by merging their first and last names, and add 10 bonus points to each customer's score.
SELECT 
CustomerID,
FirstName,
LastName,
FirstName + ' ' + COALESCE(LastName, '') FullName,
Score,
COALESCE(Score, 0) + 10 UpdatedScore
FROM Sales.Customers

-- Question 3: Sort the customers from lowest to highest scores, with nulls appearing last.
	-- Method 1: Replace the NULLs with very big number. (Lazy Method)
SELECT 
CustomerID,
Score,
COALESCE(Score, 99999999) Nonullscore
FROM Sales.Customers
ORDER BY COALESCE(Score, 99999999)

	-- Method 2: Use Case Statement and flag. (Professional Method)
SELECT 
CustomerID,
Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score

/* NULLIF(): Compares two expressions and returns:
				- Null, if they are equal
				- First value, if they are not equal
Syntax: NULLIF(Value1, Value2)
Use cases: Preventing the error of dividing by zero. */
SELECT 
OrderID,
Quantity,
Sales,
Sales / NULLIF(Quantity,0) AS Sales_Price
FROM Sales.Orders

/* IS NULL: Returns TRUE if the value IS NULL.
IS NOT NULL: Returns TRUE if the value IS NOT NULL.
Use Case: 
1. Filtering Data
Task 1: Identify the customers who have no scores. */
SELECT *
FROM Sales.Customers
WHERE Score IS NULL

-- Task 2: List all customers who have scores.
SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL

-- 2. Anti joins: Finding the unmatched rows between two tables.
-- Task 1: List all details for customers who have not placed any orders.
SELECT 
c.*,
o.OrderId
FROM Sales.Customers c
LEFT JOIN Sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL


/* NULL vs EMPTY STRING vs SPACE
NULL = Nothing, Unknown.
EMPTY STRING = String value has zero characters.
BLANK SPACE = String value has one or more space characters. */


/* Data Policy: Set of rules that defines how data should be handled.
1. Only use NULLs and Empty strings, but avoid blank spaces.
	Use TRIM() to remove the unwanted leading and trailing spaces.
2. Only use NULLs and avoid using empty strings and blank spaces.
	Use TRIM() to remove the unwanted spaces and use NULLIF() to remove the empty strings.
3. Use the default value "Unknown" and avoid using NULLs, Empty Strings and blank spaces. 
	Use ISNULL() or COALESCE() to replace the null values with the default value.