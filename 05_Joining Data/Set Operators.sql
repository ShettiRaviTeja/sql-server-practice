-- Set Operators: These operators are used to combine the rows from the multiple tables. The column names of those tables should be same.

/* Rules of the SET Operator:
1. SET Operator can be used in almost all clauses like WHERE, JOIN, GROUP BY, HAVING. But the ORDER BY is allowed only once at the end of query.
2. The number of columns in each query must be the same.
3. Data Types of columns in each query must be compatible.
4. The order of the columns in each query must be the same.
5. The column names in the result set are determined by the column names specified in the first query.
6. Map the correct columns in order to get the accurate result.*/

-- UNION: It will return all distinct rows from both queries. Remove duplicate rows from the result.
SELECT 
FirstName, 
LastName
FROM Sales.Customers
UNION
SELECT 
FirstName, 
LastName
FROM Sales.Employees;

-- UNION ALL: Return all rows from both queries including duplicates. It is generally faster than UNION.
SELECT 
FirstName, 
LastName
FROM Sales.Customers
UNION ALL
SELECT 
FirstName, 
LastName
FROM Sales.Employees;

-- EXCEPT: Returns all distinct rows from the first query that are not found in the second query.
SELECT 
FirstName, 
LastName
FROM Sales.Employees
EXCEPT
SELECT 
FirstName, 
LastName
FROM Sales.Customers;

-- INTERSECT: Returns only the rows that are common in both queries.
SELECT 
FirstName, 
LastName
FROM Sales.Customers
INTERSECT
SELECT 
FirstName, 
LastName
FROM Sales.Employees;


-- UNION USE CASES: COMBINE INFORMATION
SELECT * 
FROM SALES.ORDERS
UNION
SELECT * 
FROM SALES.OrdersArchive