/* Triggers: Triggers are special stored procedure(set of statements) that automatically runs in response to a specific event on a table or view.
=> We have different types of Triggers:
	1. DML Triggers 
		- INSERT
		- UPDATE
		- DELETE
		--> For DML Triggers, we have AFTER, INSTEAD OF
	2. DDL Triggers
		- CREATE
		- ALTER
		- DROP
	3. LOGON
=> Syntax: 
			CREATE TRIGGER TriggerName ON TableName
			AFTER/INSTEAD OF INSERT/UPDATE/DELETE
			AS
			BEGIN
				-- SQL STATEMENTS GO HERE
			END
=> INSERTED: It is a special virtual table created automatically by SQL Server inside a trigger. This table is only available during the execution of the trigger.

USE CASE: LOGGING */

-- STEP 1: Create LOG Table
CREATE TABLE Sales.EmployeeLogs(
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR(255),
	LogDate DATE
)


-- Step 2: Create Trigger on Employees Table
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
	INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New Employee Added - ' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM INSERTED
END


-- Step 3: Insert the new record into the Employees table.
INSERT INTO Sales.Employees VALUES
(6, 'Rosy', 'Joy', 'HR', '1975-10-15', 'F', 80000, 3)


-- New Record is inserted automatically into the logs table.
SELECT * FROM Sales.EmployeeLogs