-- List all indexes on a specific table.
sp_helpindex 'Sales.DBCustomers'

-- Monitoring index usage
SELECT
tbl.name TableName,
idx.name IndexName,
idx.type_desc IndexType,
idx.is_unique IsUnique,
idx.is_primary_key IsPrimaryKey,
idx.is_disabled IsDisabled
FROM sys.indexes idx
JOIN sys.tables tbl
ON idx.object_id = tbl.object_id


select * from sys.tables