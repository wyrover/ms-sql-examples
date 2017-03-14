-- t-sql scriptlet to drop all constraints on a table
DECLARE @database nvarchar(50)
DECLARE @table nvarchar(50)

set @database = 'dotnetnuke'
set @table = 'tabs'

DECLARE @sql nvarchar(255)
WHILE EXISTS(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where constraint_catalog = @database and table_name = @table)
BEGIN
    select    @sql = 'ALTER TABLE ' + @table + ' DROP CONSTRAINT ' + CONSTRAINT_NAME 
    from    INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where    constraint_catalog = @database and 
            table_name = @table
    exec    sp_executesql @sql
END

