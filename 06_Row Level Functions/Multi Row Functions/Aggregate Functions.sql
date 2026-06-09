/* Aggregate Functions: It will take multiple values as an input and provide the single output value.
We have different functions like: SUM(), MAX(), MIN(), COUNT(), AVG() */
SELECT 
customer_id,
COUNT(*) TotalOrders,
SUM(sales) TotalSales,
AVG(sales) AvgSales,
MAX(sales) HighestSales,
MIN(sales) LowestSales
FROM orders
GROUP BY customer_id