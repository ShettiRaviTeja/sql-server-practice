/* 2. Numeric functions: 
In this we have ROUND function to round the numbers.
*/
SELECT 
3.516 AS number,
ROUND(3.516, 2) AS round_2,
ROUND(3.516, 1) AS round_3,
ROUND(3.516, 0) AS round_0

-- ABS(Absolute): It will returns the absolute(Positive) value of a number, removing any negative sign.
SELECT 
ABS(-10) AS abs_number