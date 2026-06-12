/* We have 2 Types of Tables:
	1. Permanent Tables: These tables are permanently stored in the database.
		- CREATE/SELECT
		- CTAS
	2. Temporary Tables : These tables will be destroyed once the session is ended.


1. Permanent Tables:
	CTAS = CREATE TABLE AS SELECT
	=> Querying Views is slower than querying CTAS tables.  

	Syntax: CREATE TABLE TABLE_NAME AS
			(
				SELECT...
				FROM...
				WHERE...
			)
			This will be used in MySQl, Postgres and Oracle.
	=> But in SQL Server, 
							SELECT...
							INTO NEW_TABLE 
							FROM...
							WHERE

2. Temporary Tables: 
	Syntax:
			SELECT...
			INTO #NEW_TABLE
			FROM...
			WHERE... 

==> How to refresh CTAS: Use T-SQL
*/
SELECT 
	DATENAME(MONTH, OrderDate) OrderMonth,
	COUNT(OrderID) NrofOrders
	INTO Sales.MonthlyOrders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate)


/* 
USE CASES OF PERMANENT TABLES:-
   1: Optimize Performance
   2: Creating a Snapshot
		By taking the snapshot of the table using CTAS, we can able to do the analysis on the data without facing any altering issues in the data during data updation.
   3: Physical Data Marts in DWH
		Persisting the Data Marts of a DWH improves the speed of data retrieval compared to using views. */

-- Task: Create a temporary table of the orders.
SELECT 
*
INTO Sales.#Orders
FROM Sales.Orders

DELETE FROM SALES.#Orders
WHERE OrderStatus = 'Delivered'

SELECT * FROM SALES.#Orders

/*
USE CASES OF TEMPORARY TABLES:-
	1. Intermediate Results
*/