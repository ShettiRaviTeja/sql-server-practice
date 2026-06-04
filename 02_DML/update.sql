-- UPDATE is used to change the existing data whereas INSERT is used to insert new records.
-- If we don't use WHERE clause, all rows will be updated.
UPDATE customers
SET 
	score = 100
WHERE score = 0

SELECT * FROM customers