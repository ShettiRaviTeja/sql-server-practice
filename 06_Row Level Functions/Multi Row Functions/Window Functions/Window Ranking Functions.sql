/* Ranking Window Functions: 
=> In SQL, sorting is the first step before ranking.
=> We have 2 methods to rank our data: 
1. Integer-based ranking: Assign an integer for each row.
	- The values here are discrete values from 1 to so on.
	- We will use this for Top/Bottom N Analysis.
	- The functions we have here are: 
		ROW_NUMBER()
		RANK()
		DENSE_RANK()
		NTILE()
		
2. Percentage-based ranking: Assign a percentage to each row.
	- The values here are continuous values between 0 and 1.
	- We will use this for Distribution Analysis.
	- The functions we have here are:
		CUME_DIST()
		PERCENT_RANK()


1. Integer - Based Ranking:
ROW_NUMBER(): Assign a unique number to each row.
			  It doesn't handle ties.
			  
RANK(): Assign a rank to each row.
		Shared Rank.
		It handles ties.
		It leaves gaps in ranking.

DENSE_RANK(): Assign a rank to each row.
			  It handles ties.
			  Shared Rank.
			  It doesn't leaves gaps in ranking.

NTILE(): Divides the rows into a specified number of approximately equal groups(Buckets).
		 Bucket Size = Number of rows / Number of buckets
		 Syntax: NTILE(Number of Buckets) OVER()
		 SQL Rule: Larger groups come first.
*/

-- Task 1: Rank the orders based on their sales from highest to lowest.
SELECT 
OrderID,
Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) SalesRowNumber,
RANK() OVER(ORDER BY Sales DESC) SalesRank,
DENSE_RANK() OVER(ORDER BY Sales DESC) SalesDenseRank
FROM Sales.Orders

/* Top N Analysis: Analysis the top performers to do targeted marketing.
Task 2: Find the top highest sales for each product. */
SELECT
* 
FROM
(
	SELECT 
	ProductID,
	Sales,
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) TopHighestSales
	FROM Sales.Orders
) t
WHERE TopHighestSales = 1

/* Bottom N Analysis: Help analysis the underperformance to manage risks and to do optimizations.
Task 2: Find the lowest 2 customers based on their total sales. */
SELECT
*
FROM 
(
	SELECT 
	CustomerID,
	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER(ORDER BY SUM(Sales)) SalesRank
	FROM Sales.Orders
	GROUP BY CustomerID
) t
WHERE SalesRank <= 2

-- Task 3: Identify duplicate rows in the table "OrdersArchive" and return a clean result without any duplicates.
SELECT
*
FROM 
(
SELECT 
ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) RowNumber,
*
FROM Sales.OrdersArchive
) t
WHERE RowNumber = 1

-- Task 4: Assign some buckets.
SELECT 
OrderID, 
Sales,
NTILE(1) OVER(ORDER BY Sales DESC) OneBucket,
NTILE(2) OVER(ORDER BY Sales DESC) TwoBuckets,
NTILE(3) OVER(ORDER BY Sales DESC) ThreeBuckets,
NTILE(4) OVER(ORDER BY Sales DESC) FourBuckets
FROM Sales.Orders

/* We will use this NTILE() in different cases:
- Data Analyst: Data Segmentation
			  Divides a dataset into distinct subsets based on certain criteria.
Task 5: Segment all orders into 3 categories: High, Medium, Low. */
SELECT
*,
CASE
	WHEN Segments = 1 THEN 'High'
	WHEN Segments = 2 THEN 'Medium'
	WHEN Segments = 3 THEN 'Low'
	ELSE 'N/A'
END Category
FROM 
(
	SELECT 
	OrderID,
	Sales,
	NTILE(3) OVER(ORDER BY Sales DESC) Segments
	FROM Sales.Orders
) t

/* - Data Engineer: Equalizing Load
When we are loading a big table from one database to another database, it will take more time to load. Sometimes it will fail because of some issues. So that we should make the big table as a small tables using NTILE() and load them instead of whole table. After sending them, we can make it as one table using UNION.


2. Percentage - Based Ranking:
CUME_DIST(): Cumulative Distribution calculates the distribution of data points within a window.
	- CUME_DIST = Position Number / Number of rows.
	- Tie Rule = If it is a tie, then it will take the Position number as the position of the last occurrence of the same value.

PERCENT_RANK(): Calculate the relative position of each row.
	- PERCENT_RANK = (Position Number - 1) / (Number of rows - 1)
	- Tie Rule = It will take the position of the first occurrence. */

-- Task 6: Find the products that fall within the top 40% of the prices.
SELECT
Product
FROM
(
	SELECT 
	*,
	CUME_DIST() OVER(ORDER BY Price DESC) CumeSales,
	PERCENT_RANK() OVER(ORDER BY Price DESC) PercentSales
	FROM Sales.Products
) t 
WHERE CumeSales <= 0.4