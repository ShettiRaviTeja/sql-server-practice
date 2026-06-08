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
	iv. Validation