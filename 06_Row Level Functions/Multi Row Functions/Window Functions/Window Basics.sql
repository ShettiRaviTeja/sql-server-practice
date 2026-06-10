/* Window Basics: 
What is Window functions?
=> Perform calculations(e.g: Aggregation) on a specific subset of data, without losing the level of details of rows. It will maintain the granularity.

Task 1: Find the total sales across all orders. */
SELECT
SUM(sales) TotalSales
FROM Sales.Orders

-- Task 2: Find the total sales for each product. Additionally provide details such as OrderID and OrderDate
SELECT
OrderID,
OrderDate,
ProductID,
SUM(Sales) OVER(PARTITION BY ProductID) TotalSales
FROM Sales.Orders

/* Window Syntax:
(WINDOW FUNCTION)  (OVER CLAUSE)
In OVER clause, we have Partition clause, Order clause, and Frame clause.
Here WINDOW FUNCTION: It is used to perform the calculations on the window.
	=> We categorized the functions into 3: 
		- Aggregate functions 
		- Rank functions
		- Value(Analytics) functions
=> OVER clause tells SQL that the function used is a window function. It defines a window or subset of data.

=> PARTITION BY: Divides the result set into partitions (Windows). Calculations is done on individual windows.
=> If we are not specifying anything in the OVER, then the entire data is considered as one window. Calculation is done on entire dataset.
=> It is optional for all functions.

Task 3: Find the total sales across all orders,
		Find the total sales for each product, 
		Find the total sales for each combination of Product and order status,
		Additionally provide details such as orderid and orderdate. */
SELECT 
OrderID,
OrderDate,
ProductID,
OrderStatus,
Sales,
SUM(Sales) OVER() TotalSales,
SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProduct,
SUM(Sales) OVER (PARTITION BY ProductID, OrderStatus) SalesByProductsAndStatus
FROM Sales.Orders

/* ORDER BY: It is used to sort the data within a window. (Ascending/Descending)
=> It is optional for Aggregate functions but required for Value and Rank functions.

Task 4: Rank each order based on their sales from highest to lowest,
		Additionally provide details such as OrderID and OrderDate. */
SELECT
OrderID,
OrderDate,
Sales,
RANK() OVER(ORDER BY Sales DESC) Rank
FROM Sales.Orders

/* WINDOW FRAME: Defines a subset of rows within each window that is relevant for the calculation.

FRAME Clause Syntax: 
	- (Frame Types) BETWEEN (Frame Boundary - Lower Value) AND (Frame Boundary - Higher Value)
	=> Frame Types = Rows
					 Range
	=> Frame Boundary - Lower = Current Row
								N Preceding
								Unbounded Preceding
	=> Frame Boundary - Higher = Current Row
								 N Following
								 Unbounded Following
Rules:
	=> Frame Clause can only be used together with Order By clause.
	=> Lower value must be before the higher value.

=> We can use shortcut by using only Preceding. Not possible for Following. 
=> SQL uses default frame if ORDER BY is used without frame:
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW.

4x Rules:
	1. Window Functions can be used only in SELECT and ORDER BY Clause.
	   Window functions can't be used to filter data.
	2. Nested Window Functions are not allowed.
	3. SQL executes window functions after WHERE clause.
	4. Window function can be used together with GROUP BY in the same query, only if the same columns are used. */

-- Task 5: Find the total sales for each order status, only for two products 101, 102.
SELECT 
OrderStatus,
SUM(Sales) OVER(PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
WHERE ProductID IN (101, 102)

-- Task 6: Rank customers based on their total sales.
SELECT 
CustomerID,
SUM(SALES) TotalSales,
RANK() OVER(ORDER BY SUM(SALES) DESC) CustomerSalesRank
FROM Sales.Orders
GROUP BY CustomerID