/* SQL PARTITIONS: Divides big tables into small partitions while still being treated as a single logical table.
=> If we divide a big table into multiple partitions, then each partition will have its own index.
=> First check whether any partitions are there in the database.

# Building Partitions:
1. Create Partition Function
	- Define the logic on how to divide your data into partitions based on the partition key like Column, Region.
Syntax: 
		CREATE PARTITION FUNCTION PartitionName (DATATYPE)
		AS RANGE LEFT 
		FOR VALUES ('Boundary1', 'Boundary2', ...) */

CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT 
FOR VALUES ('2024-12-31', '2025-12-31', '2026-12-31')

-- To list all Partition Functions
SELECT * FROM sys.partition_functions;

----------------------------------------------------------------------------------------------
/* 2. Create Filegroups
	Logical container of one or more data files to help organize partitions. */
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2027;

-- To remove the filegroup
ALTER DATABASE SalesDB REMOVE FILEGROUP FG_2024;

-- To list all filegroups
SELECT * FROM sys.filegroups

-- PRIMARY FG: Default Filegroup where all objects of database is stored. 

------------------------------------------------------------------------------------------------
-- 3. Create Data Files
ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2024, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\ P_2024.ndf'
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2025, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\ P_2025.ndf'
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2026, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\ P_2026.ndf'
) TO FILEGROUP FG_2026;

ALTER DATABASE SalesDB ADD FILE 
(
	NAME = P_2027, -- Logical Name
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\ P_2027.ndf'
) TO FILEGROUP FG_2027;

SELECT 
	fg.name FileGroupName,
	mf.name LogicalFileName,
	mf.physical_name PhysicalFilePath,
	mf.size / 128 SizeInMB
FROM sys.master_files mf
JOIN sys.filegroups fg 
ON mf.data_space_id = fg.data_space_id
WHERE mf.database_id = DB_ID('SalesDB')

------------------------------------------------------------------------------------------------
-- 4. Create Partition Scheme
CREATE PARTITION SCHEME PartitionSchemeByYear
AS PARTITION PartitionByYear
TO (FG_2024, FG_2025, FG_2026, FG_2027)

-- Query List all Partition Scheme
SELECT 
	ps.name PartitionSchemeName,
	pf.name PartitionFunctionName,
	ds.destination_id PartitionNumber,
	fg.name FileGroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id

-----------------------------------------------------------------------------------------------
-- 5. Create Partitioned Table
CREATE TABLE Sales.Orders_Partitioned
(
	OrderID INT,
	OrderDate DATE,
	Sales INT
) ON PartitionSchemeByYear (OrderDate)

-- Insert the values into the table.
INSERT INTO Sales.Orders_Partitioned VALUES (2, '2027-12-5', 100)
INSERT INTO Sales.Orders_Partitioned VALUES (3, '2021-10-15', 1000)
INSERT INTO Sales.Orders_Partitioned VALUES (4, '2026-12-31', 5000)
INSERT INTO Sales.Orders_Partitioned VALUES (5, '2027-12-31', 1000)
INSERT INTO Sales.Orders_Partitioned VALUES (3, '2025-12-31', 1000)

SELECT *
FROM SALES.Orders_Partitioned

-- Check whether data added to correct partition or not
SELECT 
	p.partition_number PartitionNumber,
	fg.name PartitionFileGroup,
	p.rows NumberOfRows
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON dds.destination_id = p.partition_number
JOIN sys.filegroups fg ON fg.data_space_id = dds.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned'

-- By this we can check the partition number of the record.
SELECT $Partition.PartitionByYear('2021-10-15')

-- For all records at a time
SELECT *,
$Partition.PartitionByYear(OrderDate) PartitionNumber
FROM SALES.Orders_Partitioned
