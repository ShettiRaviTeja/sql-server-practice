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
	ii. Formatting & Casting
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

/* Functions Comparison:
DAY, MONTH, YEAR, DATEPART => Output datatype is INT.
DATENAME => STRING
DATETRUNC => DATETIME
EOMONTH => DATE */


-- ii. Formatting & Casting:
/* We have different types of Date & Time formats:
	International Standard (ISO 8601): YYYY - MM - DD
	USA Standard: MM - DD - YYYY
	European Standard: DD - MM - YYYY
	SQL SERVER STANDARD: International Standard (YYYY - MM - DD)

Formatting: Changing the format of the value from one to another. Changing how the data looks.
Casting: Changing the data type from one to another. */

-- Format(): Formats a date or time value.
	-- Syntax: Format(value, format, [culture])

-- Show CreationTime using following format: Day Wed Jan Q1 2025 12:34:56 PM
SELECT 
	'Day ' + FORMAT(CreationTime, 'ddd MMM') + ' Q' + DATENAME(QUARTER, CreationTime) + ' ' + FORMAT(CreationTime, 'yyyy hh:mm:ss tt') Customformat
FROM Sales.Orders

-- Formatting use cases:
-- 1. Data Aggregations:
SELECT
	FORMAT(CreationTime,'MMM yy') AS TimePeriod,
	COUNT(*) AS Orders
FROM Sales.Orders
GROUP BY FORMAT(CreationTime,'MMM yy')

-- 2. Data Standardization: In real time, we will extract the data from different sources like CSV, API, DB. We will get the different formats for same thing. At that time we should change that into a standard format using FORMAT(). Then we can use that in our analysis.


--CONVERT():Converts a date and time value to a different data type & formats the value. Syntax: CONVERT(data_type, value [, style])
SELECT
	CONVERT(DATE, CreationTime) [Datetime to Date],
	CONVERT(VARCHAR, CreationTime, 101) [USA.Std],
	CONVERT(VARCHAR, CreationTime, 103) [UK.Std]
FROM Sales.Orders

-- CAST(): Converts a value to a specified data type. Syntax: CAST(Value AS data_type). Only used for type conversion.
SELECT 
CAST('123' AS INT)


/* Comparison between CAST, FORMAT, CONVERT:
CAST: (Value AS data_type)
	Casting: Any type to any type
	Formatting: No formatting 
FORMAT: (Value, format [,culture])
	Casting: Any type to only String
	Formatting: Formats Date & Time, Numbers
CONVERT: (data_type, value [,style])
	Casting: Any type to any type
	Formatting: Formats only Date & Time */


-- iii. Calculations: It is used to perform mathematical operations on the date.
/* DATEADD(): Adds or subtracts a specific time interval to/from a date.
Syntax: (part, interval, date) */
SELECT 
	OrderDate [Original Date],
	DATEADD(YEAR, 2, OrderDate) [Two Years Later],
	DATEADD(MONTH, 3, OrderDate) [Three Months Later],
	DATEADD(DAY, -10, OrderDate) [Ten Days before]
FROM Sales.Orders

/* DATEDIFF(): Find the difference between two dates.
Syntax: (part, start_date, end_date) */
SELECT 
	DATEDIFF(YEAR, BirthDate, GETDATE()) 
FROM Sales.Employees

-- Question 1: Find the average shipping duration in days for each month.
SELECT 
	MONTH(OrderDate) OrderDate,
	AVG(DATEDIFF(DAY, OrderDate, ShipDate)) AS [Avg Shipping duration]
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

-- Question 2: Find the number of days between each order and previous order.
SELECT 
OrderID,
OrderDate AS CurrentOrderDate,
LAG(OrderDate) OVER	(ORDER BY OrderDate) AS PreviousOrderDate,
DATEDIFF(DAY, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) AS Noofdays
FROM Sales.Orders


/* iv. Validation:
ISDATE(): Check if a value is a date. Returns 1 if the string value is a valid date.
Syntax: ISDATE(Value) 
It will understand only the standard format of the date and the year.
*/
SELECT 
	ISDATE('123') AS Datecheck1,
	ISDATE('2026-06-08') AS Datecheck2,
	ISDATE('2026') AS Datecheck3,
	ISDATE('08') AS Datecheck4,
	ISDATE('08-06-2026') AS Datecheck5

-- When we will use the ISDATE function??? Consider the following scenario:
SELECT
	OrderDate,
	ISDATE(OrderDate) AS CheckDate,
	CASE 
		WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
		ELSE '9999-01-01'
	END NewOrderDate
FROM
(
	SELECT '2026-06-08' AS OrderDate UNION
	SELECT '2026-06-09' UNION
	SELECT '2026-06-10' UNION
	SELECT '2026-06'
) t 