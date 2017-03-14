/*
Created by Philip Leitch 4th July 2003

This script checks for differences in views, stored procedures and functions.
If the script identifies missing scripts it adds the new scripts.
If the script identifies different script it drops than re-adds the new scripts.

This is really useful if you have a development database that you want to put into production.
Care should be taken with object level permissions, which are reset with a drop.  If you are 
wishing to maintain current object level permissions you should alter the script to replace “Create”
 with “Alter” where commented.

*/


Create Proc Copy_Script_Objects
	@SourceDatabase as varchar(800),
 	@DestinationDatabase as varchar(800) as
set nocount on


Declare @SQLScript as varchar(8000)
set @SQLScript = 
'IF EXISTS (SELECT ''x'' FROM   sysobjects WHERE  name = ''XTypeToObject'')
	DROP FUNCTION .XTypeToObject
' 
exec (@SQLScript)
set @SQLScript = '
CREATE FUNCTION XTypeToObject 
	(@instring as varchar(5))
RETURNS Varchar(50)
Begin
	Declare @ObjectType as varchar(50)
	set @ObjectType =
		case @instring
--			when ''c'' then ''CHECK constraint''
--			when ''d'' then ''Default or DEFAULT constraint''
--			when ''f'' then ''FOREIGN KEY constraint''
--			when ''l'' then ''Log''
			when ''fn'' then ''Function''
--			when ''if'' then ''Inlined table-function''
			when ''p'' then ''Procedure''
--			when ''pk'' then ''PRIMARY KEY constraint (type is K)''
--			when ''rf'' then ''Replication filter stored procedure''
--			when ''S'' then ''System table''
			when ''TF'' then ''Function''
			when ''TR'' then ''Trigger''
			when ''U'' then ''Table''
--			when ''UQ'' then ''UNIQUE constraint (type is K)''
			when ''V'' then ''View''
--			when ''X'' then ''Extended stored procedure''
			else ''Unknown'' end

	RETURN @ObjectType
End
' 
exec (@SQLScript)

set @SQLScript = 
 'use  ' + @DestinationDatabase  +  '
Declare @ID as int
Declare @CurrentID as int
Declare @Text as varchar(8000)
Declare @ObjectName as varchar(100)
Declare @CurrentObjectName as varchar(100)
Declare @XType as varchar(10)
Declare @CurrentXType as varchar(10)
Declare @Script as varchar(8000)

Declare @DropString as varchar(8000)



Declare builder cursor for
select  SourceScript.Name, SourceComments.id, SourceComments.text, Isnull(DestinationScript.xtype, '''')
from 
' + @SourceDatabase + '..sysobjects as SourceScript 
join ' + @SourceDatabase + '..syscomments as SourceComments on SourceScript.id = SourceComments.id

left outer join ' + @DestinationDatabase + '..sysobjects as DestinationScript on 
SourceScript.name = DestinationScript.name
left outer join ' + @DestinationDatabase + '..syscomments as DestinationComments on DestinationScript.id = DestinationComments.id
and DestinationComments.colid = SourceComments.colid
where

(DestinationScript.id is null 
or DestinationComments.Text <> SourceComments.Text
)

and SourceScript.Xtype in (''P'', ''TF'',''TR'',''V'',''FN'')
/*
C = CHECK constraint
D = Default or DEFAULT constraint
F = FOREIGN KEY constraint
L = Log
FN = Scalar function
IF = Inlined table-function
P = Stored procedure
PK = PRIMARY KEY constraint (type is K)
RF = Replication filter stored procedure 
S = System table
TF = Table function
TR = Trigger
U = User table
UQ = UNIQUE constraint (type is K)
V = View
X = Extended stored procedure
*/
order by SourceScript.id, SourceComments.Colid



open builder


Fetch builder into @ObjectName, @ID, @Text, @XType

While @@fetch_status = 0 
begin
	set @CurrentID = @ID
	set  @CurrentObjectName = @ObjectName
	set @CurrentXType = @XType

	set @Script = ''''

	while @ID = @CurrentID and @@fetch_status = 0 
	begin
		set @Script = @Script + @Text
		Fetch builder into @ObjectName, @ID, @Text, @XType
	end
	if @CurrentXType <> ''''
		begin
		--Change this code to keep object level permissions (and comment out the drop string and execute)
		/*
		set @script = ''Alter'' + right(@script, len(@script) - (charindex(''Create'', @script) +5))
		*/
		set @DropString = ''drop '' + dbo.XTypeToObject(@CurrentXType) + ''  '' + @CurrentObjectName
		exec(@dropstring)

		end
--	exec (@script)

	set @CurrentID = @ID
end
close builder
deallocate builder

'
exec (@sqlScript)
