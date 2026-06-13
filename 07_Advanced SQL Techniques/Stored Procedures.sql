/* Stored Procedures: A Stored Procedure is a pre-written and saved set of SQL statements stored in the database. It can be executed whenever needed, allowing code reuse, better organization, and easier maintenance.
Syntax: 
	Stored Procedure Definition:
								CREATE PROCEDURE PROCEDURE_NAME AS
								BEGIN
									- SQL STATEMENTS GO HERE
								END
	Stored Procedure Execution: 
								EXEC ProcedureName 

Parameters: Placeholders used to pass values as input from the caller to the procedure, allowing dynamic data to be processed.
=> We can define the paratmeter using @ symbol.
=> We can define the default value for the parameter.
=> The parameter value getting from the user will have more priority.

Variables: Placeholders used to store values to be used later in the procedure.
=> Variables temporarily store and manipulate data during its execution.

Control Flow: It is used to check the conditons and execute the related statements.
Syntax: IF
		BEGIN
		END

		ELSE
		BEGIN
		END

Error Handling (Try-Catch): It is used to handle the errors while executing the query.
Syntax: BEGIN TRY
			-- SQL Statements that might cause an error
		END TRY

		BEGIN CATCH
			-- SQL Statements to handle the error.
		END CATCH
*/


-- Task 1: Write a query for US customers, find the total number of customers and the average score. 
-- Creation of Procedure
ALTER PROCEDURE GetCustomersInfo @Country NVARCHAR(50) = 'USA' AS
BEGIN
	BEGIN TRY
		DECLARE @TotalCustomers INT, @AvgScore FLOAT;

		-- ================================
		-- Step 1: Prepare and Cleanup Data
		-- ================================
		IF EXISTS (SELECT 1 FROM SALES.Customers WHERE COUNTRY = @Country AND SCORE IS NULL)
		BEGIN
			PRINT ('Updating NULL Scores to 0')
			UPDATE Sales.Customers
			SET Score = 0
			WHERE Score IS NULL AND Country = @Country
		END

		ELSE
		BEGIN
			PRINT('No NULL Scores found')
		END

		-- ==========================
		-- Step 2: Generating Reports
		-- ==========================
		-- Calculate Total Customers and Average Score for Specific Country.
		SELECT 
			@TotalCustomers = COUNT(CustomerID),
			@AvgScore = AVG(Score)
		FROM Sales.Customers
		WHERE Country = @Country;

		PRINT 'Total Customers from ' + @Country + ' : ' + CAST(@TotalCustomers AS NVARCHAR);
		PRINT 'Average Score of Customers' + ' : ' + CAST(@AvgScore AS NVARCHAR);

		-- Calculate Total Sales and Number of Orders for Specific Country.
		SELECT
			COUNT(OrderID) NrofOrders,
			SUM(Sales) TotalSales
		FROM Sales.Orders o
		JOIN Sales.Customers c
		ON o.CustomerID = c.CustomerID
		WHERE c.Country = @Country;
	END TRY

	BEGIN CATCH

		-- =====================
		-- Step 3: Error Handler
		-- =====================
		PRINT('An error occured.')
		PRINT('Error Message: ' + ERROR_MESSAGE())
		PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR))
		PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR))
		PRINT('Error Procedure: ' + ERROR_PROCEDURE())
	END CATCH
END

-- Execution of Procedure
EXEC GetCustomersInfo 
EXEC GetCustomersInfo @Country = 'Germany'