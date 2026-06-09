/* 5. Case Statement: Evaluates a list of conditions and returns a value when the first condition is met.
Syntax: 
		CASE
			WHEN Condition 1 THEN Result 1
			WHEN Condition 2 THEN Result 2
			.
			.
			.
			ELSE Result
		END

Use Case 1: Categorizing Data
			Group the data into differenct categories based on certain conditions. 

Task 1: Generate a report showing the total sales for each category:
		- High = If the sales higher than 50
		- Medium = If the sales are 21 - 50
		- Low = If the sales equal or lower than 20
		Sort the result from lowest to highest. */

SELECT
t.Category,
SUM(t.Sales) TotalSales
FROM(
	SELECT
	Sales,
	CASE
		WHEN Sales > 50 THEN 'High'
		WHEN Sales > 20 THEN 'Medium'
		ELSE 'Low'
	END Category
	FROM Sales.Orders
	) t
	GROUP BY t.Category
	ORDER BY SUM(t.Sales)

-- Rule: CASE Statement can be used anywhere in the query.

/*
Use Case 2: Mapping Values
			Transform the values from one form to another form.

Task 2: Retrieve employee details with gender displayed as full text. */
SELECT 
EmployeeID,
FirstName,
LastName,
Gender,
CASE
	WHEN Gender = 'M' THEN 'Male'
	WHEN Gender = 'F' THEN 'Female'
	ELSE 'Unknown'
END GenderFullText
FROM Sales.Employees

-- Task 3: Retrieve customer details with abbreviated country code.
SELECT 
CustomerID,
FirstName,
LastName,
Country,
CASE
	WHEN Country = 'Germany' THEN 'DE'
	WHEN Country = 'USA' THEN 'US'
	ELSE 'N/A'
END AbbreCountryCode1,
CASE Country
	WHEN 'Germany' THEN 'DE'
	WHEN 'USA' THEN 'US'
	ELSE 'N/A'
END AbbreCountryCode2
FROM Sales.Customers


/* Quick Form:
CASE Country
	WHEN 'Germany' THEN 'DE'
	WHEN 'USA' THEN 'US'
	ELSE 'N/A'
END */


/* Use Case 3: Handling Nulls
			   Replace nulls with a specific value. Nulls can lead to inaccurate results, which can lead to wrong decision-making.
Task 4: Find the average scores of customers and treat nulls as 0. Additionally provide details such as CustomerID and LastName*/
SELECT 
CustomerID,
LastName,
Score,
AVG(Score) OVER() AvgScore,
CASE
	WHEN Score IS NULL THEN 0
	ELSE  Score
END CleanScore,
AVG(CASE
		WHEN Score IS NULL THEN 0
		ELSE  Score
	END ) OVER() CleanScoreAvg
FROM Sales.Customers


/* Use case 4: Conditional Aggregation
Apply aggregate functions only on subsets of data that fulfill certain conditions.
Task 5: Count how many times each customer has made an order with sales greater than 30. */
SELECT 
CustomerID,
SUM(CASE 
	WHEN Sales > 30 THEN 1
	ELSE 0
END) TotalOrdersGreater,
COUNT(OrderID) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID