/* Index: Data Structure provides quick access to data, optimizing the speed of your queries.
=> Types of Indexes:
	1. Structure
		- Clustered Index
		- Non-Clustered Index
	2. Storage (SQL Server Tables are RowStore by default)
		- Rowstore Index 
		- Columnstore Index
	3. Functions
		- Unique Index
		- Filtered Index

=> How the data will be stored in the DB:-
	Usually the data will be stored in the Data Files in the DB. In Data Files, we have Pages like Data Pages, Index Pages and other pages. 
=> Page: The smallest unit of data storage in a database (8kb). It stores anything like Data, Metadata, Indexes, etc.
	- Mainly we have 2 pages: Data Page and Index Page
	Eg: 1:100 (1 is FileID and 100 is Page Number)
============================================================================================================================
1. Structure:
- Clustered Index: If we create a Clustered Index, then the database will store the data in an ascending order physically. After storing, the first record of the first page is the lowest and last record of last page is highest value.
=> After that, SQL will structure the B-Tree (Balanced Tree).
	Balanced Tree: Hierarchical structure storing data at leaves, to help quickly locate data.
	Structure: 
					Root Level			 |		Index Page (1:300)
												Intermediate Level Pages: 1 -> 1:200, 11 -> 1:201
				-----------------------------------------------------------------------------------------			
					Intermediate Level	 |		Index Page (1:200)
												Leaf Level Pages: 1 -> 1:100, 6 -> 1:101
												  - Here 1 is Key and 1:100 is the Value(Pointer to Data Page)
				-----------------------------------------------------------------------------------------				 
					Leaf Level           |		Well Structured & Ordered Data Pages (1:100, 1:101, 1:102...)

=> Index Page: It stores key values (pointers) to another page. It doesn't store the actual rows.
	- From the above structure: The data from 1 to 5 records will search in the 1:100 Page and 6 to 10 records in the 1:101 Page.

- Non-Clustered Index: Here the data will not be stored in the ordered way.
=> Structure:	
					Root Node			 |		1:400 (1 -> 1:300, 11 -> 1:301)
				----------------------------------------------------------------------------------------
					Intermediate Node	 |		1:300 (1 -> 1:200, 6 -> 1:201...)
				----------------------------------------------------------------------------------------
					Leaf Node			 |		1:200 (1->1:102:96, 2->1:101:140, 3->1:101:188...)
				----------------------------------------------------------------------------------------
					Base Data Pages      |		Consists of Data Pages (1:100, 1:101,1:102...)
=> 1 -> 1:101:140
		Here 1 = CustomerID
			 1:101 = FileID:PageNumber
			 140 = Offset
		Completely we will call it as RID (Row Identifier)

============================================================================================================================
HOW TO CREATE INDEX???
Syntax:	
		CREATE [CLUSTERED / NONCLUSTERED] INDEX index_name ON table_name (column1, column2....) => Default is NONCLUSTERED.

HOW TO DROP INDEX???
Syntax:
		DROP INDEX INDEX_NAME ON TABLE_NAME

Note: If we create a column using Primary key, then automatically a clustered index will be created by default.
	  Only one clustered index will be created per table. */

-- Creating the indexes:
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers (CustomerID);
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName ON Sales.DBCustomers (LastName);
CREATE INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers (FirstName);


-- Create another table without any indexes:
SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers

SELECT FirstName 
FROM SALES.DBCustomers
WHERE LastName = 'Brown'

SELECT LastName
FROM Sales.DBCustomers
WHERE FirstName = 'Anna'

-- ========================================================================================================================
-- Composite Index: In this, we can specify more than 2 columns.
-- For example, we have a query like:
SELECT 
*
FROM Sales.Customers
WHERE Country = 'USA' AND Score > 400;

-- Then we should create a Composite Index.
-- The columns in this should match the order of columns in query.
CREATE INDEX idx_DBCustomers_CountryScore ON Sales.DBCustomers (Country, Score);

-- => After creating the composite index, if we write the query using only the first column mentioned in the index, then it will use the LEFTMOST PREFIX RULE. By using this rule, it will use the index for the first column. It won't work if you skip the column.
-- =========================================================================================================================
/* 2. Storage: 
- Columnstore Index: Columns will be divided into segments and index will be assigned to it.
					 We can create only one COLUMNSTORE index for each table.
Process:
		1. Row Groups
		2. Column Segment
		3. Compression
		4. Store
=> Now it will use the page called LOB (Large Object Page). This LOB page is connected to the Dictionary Page.

=> If we use CLUSTERED COLUMNSTORE INDEX, our heap table (rowstore) will be replaced with the COLUMNS created by CLUSTERED COLUMNSTORE INDEX.
		* Converts the entire table into columnstore format.

=> If we use NONCLUSTERED COLUMNSTORE INDEX, our heap table (rowstore) will not be replaced. The result table will act as a companion to the heap table (rowstore).
		* Adds a columnstore index while keeping the table as a normal rowstore table. 
============================================================================================================================

- Create Non-Clustered Columnstore Index: */
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CCS_FirstName
ON Sales.DBCustomers (FirstName)

SELECT LEN(FirstName)
FROM Sales.DBCustomers

-- ========================================================================================================================
/* 
=> A Rowstore Table can have:
	1 Clustered Rowstore Index
	+
	Many Nonclustered Rowstore Indexes
	+
	1 Nonclustered Columnstore Index

=> A Columnstore Table can have:
	1 Clustered Columnstore Index
	+
	Many Nonclustered Rowstore Indexes */
-- ========================================================================================================================