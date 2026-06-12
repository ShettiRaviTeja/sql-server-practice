/* Views: Views are the virtual tables that shows data without storing it physically.
=> In order to understand the VIEWS, we should know about the 3-Level Architecture of the Database.

												VIEW level
													|
											   LOGICAL level
													| 
											   PHYSICAL level

1. Physical Level: (Physical Layer or Internal Layer)
	=> It is the lowest level of the database where the actual data is stored in a physical storage. 
	=> Only DBA are allowed to access it.
	=> It is the lowest level of abstraction.
	=> In this layer, we should manage:
		- Data Files
		- Partitions
		- Logs
		- Catalog
		- Blocks
		- Caches

2. Logical Level: (Logical Layer or Conceptual Layer)
	=> In this level, we will have Application developers or Data Engineers and they will focus only on structuring the data rather than storing it in DB.
	=> In this we will manage:
		- Tables
		- Relationship between tables
		- Views
		- Indexes
		- Procedures
		- Functions 

3. View Level: (View Layer or External Layer)
	=> It is the highest level of abstraction.
	=> We can create multiple views which can be accessed by different end users like Business Analyst, Power BI and etc.
	=> In this level, the people will only deal with the views.

VIEWS: It is the virtual table based on the result set of a query, without storing the data in database.
=> A query is attached to the view.
=> When we access the view, the query will be executed and that query will access the information from the physical table.
=> We are directly querying the view, but indirectly querying the physical table.
=> Views are read only, whereas tables are read and write.
Note: If we create a table or view without specifying a schema, then it will take the default schema as dbo.

CREATE, UPDATE and DROP the Views:
Syntax: 
	TO CREATE:
			CREATE VIEW VIEW_NAME AS
			(
				SELECT...
				FROM...
				WHERE...
			)

	TO DROP:
			DROP VIEW VIEW_NAME

	TO UPDATE OR REPLACE:
			IF OBJECT_ID ('VIEW_NAME', 'V') IS NOT NULL
				DROP VIEW VIEW_NAME
			GO
			CREATE VIEW VIEW_NAME AS (
				SELECT...
				FROM...
				WHERE...
			)
		Or use: CREATE OR ALTER VIEW...


USE CASE 1: CENTRAL COMPLEX QUERY LOGIC
=> Store central, complex query logic in the database for access by multiple queries reducing project complexity.

Task 1: Find the running total of sales for each month. */
-- Creating View
CREATE OR ALTER VIEW Sales.Monthly_Summary_View AS
(
	SELECT 
		DATETRUNC(month, OrderDate) OrderMonth,
		SUM(Sales) TotalSales,
		COUNT(OrderID) TotalOrders
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
) 

-- Using View to find the running total of sales.
SELECT 
OrderMonth,
TotalSales,
SUM(TotalSales) OVER(ORDER BY OrderMonth) SalesRunningTotal
FROM Sales.Monthly_Summary_View


/* USE CASE 2: HIDE COMPLEXITY
=> Views can be used to hide the complexity of database tables and offers users more friendly and easy-to-consume objects.
Task 2: Provide a view that combines details from orders, products, customers and employees.
-- Creating a view: */
CREATE VIEW Sales.Order_Details_V AS
(
	SELECT 
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.Category,
	COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') CustomerName,
	c.Country CustomerCountry,
	COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') SalesPersonName,
	e.Department,
	o.Sales,
	o.Quantity
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON o.ProductID = p.ProductID
	LEFT JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	LEFT JOIN Sales.Employees e
	ON o.SalesPersonID = E.EmployeeID
)


/* USE CASE 3: DATA SECURITY
=> Use Views to enforce security and protect sensitive data, by hiding columns/rows from tables.
Task 3: Provide a view for EU Sales Team that combine details from all tables. 
		Exclude data related to USA. */
CREATE VIEW Sales.EU_Sales_Team_V AS
(
	SELECT 
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.Category,
	COALESCE(c.FirstName, '') + ' ' + COALESCE(c.LastName, '') CustomerName,
	c.Country CustomerCountry,
	COALESCE(e.FirstName, '') + ' ' + COALESCE(e.LastName, '') SalesPersonName,
	e.Department,
	o.Sales,
	o.Quantity
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON o.ProductID = p.ProductID
	LEFT JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	LEFT JOIN Sales.Employees e
	ON o.SalesPersonID = E.EmployeeID
	WHERE c.Country <> 'USA'
)


/* USE CASE 4: FLEXIBILITY AND DYNAMIC
=> If we want to change anything in our table or data model, then we can provide a view to users and do the changes to our tables or data models.

USE CASE 5: MULTIPLE LANGUAGES
USE CASE 6: VIRTUAL DATA MARTS IN DWH