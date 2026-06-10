/* Window Aggregate Functions: 

COUNT(): Returns the number of rows within a window.
=> COUNT(*) = Count all rows in the table regardless of whether any value is NULL.
=> COUNT(*) = COUNT(1)
=> It allows all datatypes and count the rows regardless of the datatype. 

USE CASE 1: OVERALL ANALYSIS
			It is nothing but the quick summary or the snapshot of the entire dataset.
USE CASE 2: TOTAL PER GROUPS
			Group-wise analysis, to understand patterns within different categories.
USE CASE 3: DATA QUALITY CHECK
			Detecting number of NULLs by comparing to total number of rows.
USE CASE 4: IDENTIFY DUPLICATES
			Identify duplicate rows to improve data quality.

Task 1: Find the total number of Orders. 
		Find the total number of orders for each customers.
		Additionally provide details such as order id and order date. */
SELECT 
OrderID,
OrderDate,
CustomerID,
COUNT(OrderID) OVER() TotalOrders,
COUNT(OrderID) OVER(PARTITION BY CustomerID) TotalOrdersByCustomer
FROM Sales.Orders 

/* Task 2: Find the total number of customers.
		   Find the total number of scores for the customers.
		   Additionally provide all customers details. */
SELECT 
*,
COUNT(CustomerID) OVER() TotalCustomers,
COUNT(Score) OVER() TotalScores
FROM Sales.Customers

/* Task 3: Check whether the table "OrdersArchive" contains any duplicate rows. */
SELECT *
FROM(
	SELECT 
	OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) CheckDuplicates
	FROM Sales.OrdersArchive
)t
WHERE CheckDuplicates > 1


/* SUM(): Returns sum of all values within a window.
=> It allows only numbers and avoid the NULL values.

Task 1: Find the total sales across all orders,
		and the total sales for each product,
		additionally provide the details such as orderid and order date. */
SELECT 
OrderID,
OrderDate,
Sales,
SUM(Sales) OVER() TotalSales,
ProductID,
SUM(Sales) OVER(PARTITION BY ProductID) ProductSales
FROM Sales.Orders

-- Task 2: Find the percentage contribution of each product's sales to the total sales.
SELECT 
OrderID,
ProductID,
Sales,
SUM(Sales) OVER() TotalSales,
ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER() * 100, 2) PercentageContibution
FROM Sales.Orders


/* AVG(): Returns the average of values within a window.
=> Before doing any aggregations we should handle the NULLs to get the accurate results. 

Task 1: Find the average sales across all orders,
		and the average sales for each product,
		also provide additional details such as OrderID and OrderDate. */
SELECT 
OrderID,
OrderDate,
ProductID,
Sales,
AVG(Sales) OVER() TotalAvgSales,
AVG(Sales) OVER(PARTITION BY ProductID) AvgSalesByProduct
FROM Sales.Orders

/* Task 2: Find the avg scores of customers.
		   Additionally provide details such as CustomerID and LastName. */
SELECT
CustomerID,
LastName,
Score,
AVG(COALESCE(Score, 0)) OVER() AvgCustomerScore
FROM Sales.Customers

/* Task 3: Find all orders where sales are higher than the average sales across all orders. */
SELECT
*
FROM(
	SELECT 
	OrderID,
	Sales,
	AVG(Sales) OVER() AvgSales
	FROM Sales.Orders
) t
WHERE Sales > AvgSales


/* MIN() and MAX():
=> MIN() will returns the lowest value within a window.
=> MAX() will returns the highest value within a window.

Task 1: Find the highest and lowest sales of all orders.
		Find the highest and lowest sales for each product.
		Additionally provide the details like order id and order date. */
SELECT
OrderID,
OrderDate,
Sales,
MIN(Sales) OVER() LowestSales,
MAX(Sales) OVER() HighestSales,
ProductID,
MIN(Sales) OVER(PARTITION BY ProductID) LowestSalesByProduct,
MAX(Sales) OVER(PARTITION BY ProductID) HighestSalesByProduct
FROM Sales.Orders

/* Task 2: Show the employees who have the highest salaries. */
SELECT
EmployeeID,
FirstName,
Department,
Salary
FROM(
	SELECT
	*,
	MAX(Salary) OVER() HighestSalary
	FROM Sales.Employees
) t
WHERE SALARY = HighestSalary

/* Task 3: Find the deviation of each sales from both the minimum and maximum sales amounts. */
SELECT 
OrderID,
Sales,
MIN(Sales) OVER() LowestSales,
MAX(Sales) OVER() HighestSales,
Sales - MIN(Sales) OVER() DeviationFromMin,
MAX(Sales) OVER() - Sales DeviationFromMax
FROM Sales.Orders


/* RUNNING AND ROLLING TOTAL:
	They aggregate sequence of members, and the aggregation is updated each time a new member is added.
Main difference between them:
	Running Total: Aggregate all values from the beginning upto the current point without dropping off older data.
	Rolling Total: Aggregate all values within a fixed time window (e.g.30 Days). As new data is added, the oldest data point will be dropped. 

Task 4: Calculate moving average of sales for each product over time. */
SELECT 
ProductID,
OrderID,
OrderDate,
Sales,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAverage
FROM Sales.Orders

-- Task 5: Calculate the moving average of sales for each product over time, including only the next order.
SELECT 
OrderID,
OrderDate,
ProductID,
Sales,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAverage
FROM Sales.Orders