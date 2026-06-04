-- DELETE is used to delete the records from the table.
-- If we not use the WHERE condition, then all records will be deleted.
SELECT *
FROM customers

DELETE FROM customers
WHERE id > 5

/*
We can use the DELETE command to delete all records from the table. But it will take time, because it will consider some checking before deleting. We can use this for a small table.
So we can use TRUNCATE command to do that. It is fast and it won't check for anything.
*/
SELECT *
FROM persons;
DELETE FROM persons
-- OR
TRUNCATE TABLE persons