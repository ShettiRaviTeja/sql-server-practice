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
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC


-- 4. Update Statistics:

-- Tip: Whenever we joined in a project, first check the stats of the indexes and drop the unused indexes. By doing this, we can save the storage and improve the write performance.