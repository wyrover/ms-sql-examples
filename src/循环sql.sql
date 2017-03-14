USE [DBNAME]
GO

declare @Proc nvarchar(50)
declare @RowCnt int
declare @MaxRows int
declare @ExecSql nvarchar(255)

select @RowCnt = 1
select @Proc = 'usp_InsertUser'

-- These next two rows are specific to source table or query
declare @Import table (rownum int IDENTITY (1, 1) Primary key NOT NULL , EmployeeID varchar(9))
insert into @Import (EmployeeID) select EmployeeID from EmployeeImportTable

select @MaxRows=count(*) from @Import

while @RowCnt <= @MaxRows
begin
    select @ExecSql = 'exec ' + @Proc + ' ''' + EmployeeID + '''' from @Import where rownum = @RowCnt 
    --print @ExecSql
    execute sp_executesql @ExecSql
    Select @RowCnt = @RowCnt + 1
end


