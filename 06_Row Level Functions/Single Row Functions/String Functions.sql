/* 1. String functions: To manipulate the string values we use some functions like CONCAT, UPPER, LOWER, TRIM, REPLACE. 
To do calculations on the string values we use LEN function.
To extract something from the string value we use LEFT, RIGHT, SUBSTRING functions. */
-- CONCAT(): Combine multiple strings into one.
-- LOWER(): It converts all characters to lowercase.
-- UPPER(): It converts all characters to uppercase.
-- TRIM(): Remove leading and trailing spaces.
-- REPLACE(): Replaces a specific character with a new character.
-- LEN(): Counts the number of characters.
-- LEFT(): Extract specific number of characters from the start.
-- RIGHT(): Extract specific number of characters from the end.
-- SUBSTRING(): Extracts a part of string at a specified position.

SELECT
'123-456-7890' AS phone_number,
first_name,
country,
CONCAT(first_name, ' ', country) AS name_country,
LOWER(first_name) AS lowercase_name,
UPPER(first_name) AS uppercase_name,
TRIM(first_name) AS trimmed_name,
REPLACE('123-456-7890', '-', '') AS new_phone,
LEN(first_name) AS name_length,
LEFT(TRIM(first_name), 2) AS first_char,
RIGHT(first_name,2) AS end_char,
SUBSTRING(first_name, 1, 2) AS string_part
FROM customers


-- Find the firstname which have extra spaces in it.
SELECT 
first_name,
TRIM(first_name) AS trim_name,
LEN(first_name) AS name_length,
LEN(TRIM(first_name)) as length_after_trim,
LEN(first_name) - LEN(TRIM(first_name)) flag
FROM customers
WHERE LEN(first_name) != LEN(TRIM(first_name))
-- WHERE first_name != TRIM(first_name)