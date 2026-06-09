/* Window Basics: 
What is Window functions?
=> Perform calculations(e.g: Aggregation) on a specific subset of data, without losing the level of details of rows.
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