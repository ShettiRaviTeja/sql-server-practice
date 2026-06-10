/* Window Value Functions: Access a value from other row.
=> In this we have different functions like:
	1. LAG(expr, offset, default)
	2. LEAD(expr, offset, default)
	3. FIRST_VALUE(expr)
	4. LAST_VALUE(expr)


1. LAG(): Access a value from the previous row within a window.
2. LEAD(): Access a value from the next row within a window.
3. FIRST_VALUE(): Access a value from the first row within a window.
4. LAST_VALUE(): Access a value from the last row within a window.

USE CASE 1: Time Series Analysis: MoM or YoY
Task 1: Analyze the Month-Over-Month(MoM) performance by finding the percentage change in sales between the current and previous month. */
SELECT
*,
ROUND(CAST((CurrentMonthTotalSales - PreviousMonthTotalSales) AS FLOAT)/PreviousMonthTotalSales * 100, 2) MoMPercentageChange
FROM
(
	SELECT 
	MONTH(OrderDate) OrderMonth,
	SUM(Sales) CurrentMonthTotalSales,
	LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) PreviousMonthTotalSales
	FROM Sales.Orders
	GROUP BY MONTH(OrderDate)
) t

/* USE CASE 2: Customer Retention Analysis = Measures customer behavior and loyalty to help businesses to build strong relationships with customers.
Task 2: In order to analyze customer loyalty, rank customers based on the average days between their orders. */
SELECT
CustomerID,
AVG(DaysUntilNextOrder) AvgOrders,
Rank() OVER(ORDER BY COALESCE(AVG(DaysUntilNextOrder), 999999)) LoyaltyRank
FROM
(
	SELECT
	OrderID,
	CustomerID,
	OrderDate CurrentDate,
	LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
	DATEDIFF(DAY, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
	FROM Sales.Orders
) t
GROUP BY CustomerID

-- Default 
-- Task 3: Find the lowest and highest sales for each product.
SELECT
ProductID,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales,
LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales
FROM Sales.Orders