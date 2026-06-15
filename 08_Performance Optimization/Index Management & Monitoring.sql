-- List all indexes on a specific table.
sp_helpindex 'Sales.DBCustomers'

-- Dynamic Management View: It provides real-time insights into Database performance and system health.
SELECT * FROM sys.dm_db_index_usage_stats

-- 1. Monitoring Index Usage
SELECT
	tbl.name TableName,
	idx.name IndexName,
	idx.type_desc IndexType,
	idx.is_unique IsUnique,
	idx.is_primary_key IsPrimaryKey,
	idx.is_disabled IsDisabled,
	s.user_seeks UserSeeks,
	s.user_scans UserScans,
	s.user_lookups UserLookups,
	s.user_updates UserUpdates,
	COALESCE(s.last_user_seek, s.last_user_scan) Last_Updates
FROM sys.indexes idx
INNER JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
ON s.object_id = idx.object_id
AND	s.index_id = idx.index_id
ORDER BY tbl.name, idx.name


-- 2. Monitoring Missing Indexes: We will get the missing index recommendations from the database.
SELECT * FROM sys.dm_db_missing_index_details


-- 3. Monitoring Duplicate Indexes: 
SELECT 
	tbl.name TableName,
	col.name IndexColumn,
	idx.name IndexName,
	idx.type_desc IndexType,
	COUNT(*) OVER (PARTITION BY tbl.name, col.name) ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic ON ic.object_id = idx.object_id AND ic.index_id = idx.index_id
JOIN sys.columns col ON idx.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC


-- 4. Update Statistics:
SELECT 
	SCHEMA_NAME(t.schema_id) SchemaName,
	t.name TableName,
	s.name StatisticName,
	sp.last_updated LastUpdate,
	DATEDIFF(day, sp.last_updated, GETDATE()) LastUpdateDay,
	sp.rows Rows,
	sp.modification_counter ModificationSinceLastUpdate
FROM sys.stats s
JOIN sys.tables t
ON s.object_id = t.object_id
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) sp
ORDER BY ModificationSinceLastUpdate DESC

-- To check whether the auto stats is on or off:
SELECT name,
       is_auto_create_stats_on,
       is_auto_update_stats_on
FROM sys.databases
WHERE name = DB_NAME();


-- Important Commands:
UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000004_2739D489;
UPDATE STATISTICS Sales.DBCustomers;
EXEC sp_updatestats;
sp_helpindex 'Sales.DBCustomers';
SELECT * FROM sys.indexes;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT * FROM sys.dm_db_index_usage_stats

-- Tip: Whenever we joined in a project, first check the stats of the indexes and drop the unused indexes. By doing this, we can save the storage and improve the write performance.

/*
INDEX COMMANDS:
						CREATE CLUSTERED INDEX
						CREATE NONCLUSTERED INDEX
						DROP INDEX
						ALTER INDEX ... DISABLE;
						ALTER INDEX ... REBUILD;
						ALTER INDEX ... REORGANIZE;
						sp_helpindex 'TableName';

STATISTICS COMMANDS: 
						UPDATE STATISTICS TableName; (It is a Sampled and SQL Server may sample rows)
						UPDATE STATISTICS TableName WITH FULLSCAN;
						UPDATE STATISTICS TableName StatisticName;
						EXEC sp_updatestats;
						DBCC SHOW_STATISTICS
						(
							'Table_Name'
							'Index_Name'
						);
						SELECT * FROM sys.stats;

PERFORMANCE COMMANDS:
						SET STATISTICS IO ON;
						SET STATISTICS TIME ON;

MONITORING COMMANDS:	
						SELECT * FROM sys.dm_db_index_usage_stats;
						SELECT * FROM sys.indexes;
*/


/* 5. Monitor Fragmentations: Unused spaces in the data pages. Data pages are out of order.
=> We have 2 methods:
	 Reorganize - Defragments the leaf nodes to keep them sorted. It is light operation.
	 Rebuild - Recreated index from scratch. It is heavy operation.  
=> Parameters: (databaseID, objectID, indexID, PartitionNumber, mode)
=> modes are Limited, Sampled, Detailed.

=> How to find the fragmentations???
*/
SELECT 
	tbl.name TableName,
	idx.name IndexName,
	ps.avg_fragmentation_in_percent,
	ps.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ps
JOIN sys.tables tbl
ON ps.object_id = tbl.object_id
JOIN sys.indexes idx
ON ps.object_id = idx.object_id
AND ps.index_id = idx.index_id
ORDER BY avg_fragmentation_in_percent DESC

/* When to defragment???
	< 10% = No Action Needed
	10 - 30% = Reorganize
	> 30% = Rebuild */

-- To REORGANIZE the indexes:
ALTER INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers REORGANIZE

-- To REBUILD the indexes:
ALTER INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers REORGANIZE