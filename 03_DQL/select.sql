-- SELECT command is used to select the particular columns (filtering columnwise).
-- By seeing this we can understand the order of query writing.
SELECT top 1 
	country,
	SUM(score)
FROM customers
WHERE score != 0
GROUP BY country
HAVING SUM(score) > 750