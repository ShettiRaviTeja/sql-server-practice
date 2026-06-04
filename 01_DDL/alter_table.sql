-- To add the new column to the table: Always added at the end.
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;

-- To delete the column from the table
ALTER TABLE persons
DROP COLUMN phone;