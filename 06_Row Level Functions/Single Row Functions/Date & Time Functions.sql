/* 3. Date and Time functions: In this we have one structure like
Year - Month - Day  Hours - Minutes - Seconds 
It is nothing but a Timestamp.
We can get the date and time from 3 different sources:
	1. From the table.
	2. By creating a hardcoded value.
	3. By using GetDate() function.

GetDate(): It will return the current date and time at the moment when the query is executed.
*/
SELECT 
	OrderID,
	CreationTime,
	'2026-06-08' Hardcoded,
	GETDATE() Today
FROM Sales.Orders

/* In this we have 4 categories like
	i. Part Extraction
	ii. Format & Casting
	iii. Calculations
	iv. Validation */

-- i. Part Extraction: 
-- DAY(DATE): Returns the day from the date.
-- MONTH(DATE): Returns the month from the date.
-- YEAR(DATE): Returns the year from the date.
-- DATEPART(PART, DATE): Returns a specific part of the date as a number. In this we have different parts like Month, Year, Day, Week, Weekday, Quarter, Hour, Minute, Second.
-- DATEFIRST: If it returns 7, then Sunday is the first day of the week.
-- DATENAME(PART, DATE): Returns the name of specific part of a date.
-- DATETRUNC(PART, DATE): Truncates the date to the specific part. In this Datepart will reset to 01 and Timepart will reset to 00.
-- EOMONTH(DATE): Returns the last day of the month.
SELECT 
	CreationTime,
	DATETRUNC(MONTH, CreationTime) AS Month_trunc,
	DATEPART(Year, CreationTime) AS Year_dp,
	DATEPART(Month, CreationTime) AS Month_dp,
	DATENAME(Month, CreationTime) AS MonthName_dp,
	DATEPART(Day, CreationTime) AS Day_dp,
	DATEPART(Hour, CreationTime) AS Hour_dp,
	DATEPART(MINUTE, CreationTime) AS Minute_dp,
	DATEPART(SECOND, CreationTime) AS Second_dp,
	DATEPART(WEEK, CreationTime) AS Week_dp,
	DATEPART(WEEKDAY, CreationTime) AS Weekday_dp,
	DATENAME(WEEKDAY, CreationTime) AS WeekdayName_dp, 
	DATEPART(QUARTER, CreationTime) AS Quarter_dp,
	DAY(CreationTime) AS day,
	MONTH(CreationTime) AS month,
	YEAR(CreationTime) AS year,
	EOMONTH(CreationTime) as Endofmonth
FROM Sales.Orders

SELECT @@DATEFIRST
SET DATEFIRST 7;

-- If we want monthly sales report, then we should truncate the date upto month.
SELECT 
	DATETRUNC(MONTH,CreationTime) AS Creation,
	COUNT(*) AS Orders
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH,CreationTime)

-- Part extraction use cases: 
-- 1. Data Aggregations:
-- First Question: How many orders were placed each year???
SELECT 
	YEAR(CreationTime) AS Year,
	COUNT(orderID) AS Orders
FROM sales.orders
GROUP BY YEAR(CreationTime)

-- Second Question: How many orders were placed each month???
SELECT
	DATENAME(MONTH, OrderDate) AS Month,
	COUNT(OrderID) AS Orders
FROM Sales.Orders
GROUP BY DATENAME(MONTH, OrderDate)

-- 2. Data Filtering:
-- First Question: Show all orders that were placed during the month of February.
SELECT *
FROM Sales.Orders
WHERE Month(OrderDate) = 2