--select * from sysobjects where name like 'df%'
alter Proc Script_Differences 
	 @SourceDatabase as varchar(800)= '',
	 @DestinationDatabase as varchar(800) = ''
as



Declare @SQLScript as varchar(8000)
set @SQLScript = 
'IF EXISTS (SELECT ''x'' FROM   sysobjects WHERE  name = ''XTypeToString'')
	DROP FUNCTION XTypeToString
' 
exec (@SQLScript)
set @SQLScript = '
CREATE FUNCTION XTypeToString 
	(@instring as varchar(5))
RETURNS Varchar(50)
Begin
	Declare @ObjectType as varchar(50)
	set @ObjectType =
		case @instring
			when ''c'' then ''CHECK constraint''
			when ''d'' then ''Default or DEFAULT constraint''
			when ''f'' then ''FOREIGN KEY constraint''
			when ''l'' then ''Log''
			when ''fn'' then ''Scalar function''
			when ''if'' then ''Inlined table-function''
			when ''p'' then ''Stored procedure''
			when ''pk'' then ''PRIMARY KEY constraint (type is K)''
			when ''rf'' then ''Replication filter stored procedure''
			when ''S'' then ''System table''
			when ''TF'' then ''Table function''
			when ''TR'' then ''Trigger''
			when ''U'' then ''User table''
			when ''UQ'' then ''UNIQUE constraint (type is K)''
			when ''V'' then ''View''
			when ''X'' then ''Extended stored procedure''
			else ''Unknown'' end

	RETURN @ObjectType
End
' 
exec (@SQLScript)
set @SQLScript = 
'
select distinct  SourceScript.name, case when DestinationScript.id is null then ''Missing'' else ''Different'' end as problem, dbo.XTypeToString(SourceScript.xtype) as SourceType, case when DestinationScript.xtype is null then '''' else dbo.XTypeToString(DestinationScript.xtype) end as DestinationType
from 
' + @SourceDatabase + '..sysobjects as SourceScript 
join ' + @SourceDatabase + '..syscomments as SourceComments on SourceScript.id = SourceComments.id
left outer join ' + @DestinationDatabase + '..sysobjects as DestinationScript on 
SourceScript.name = DestinationScript.name
left outer join ' + @DestinationDatabase + '..syscomments as DestinationComments on DestinationScript.id = DestinationComments.id
and DestinationComments.colid = SourceComments.colid
where

(DestinationScript.id is null or DestinationComments.Text <> SourceComments.Text)
--and not SourceScript.name  like ''df%''
--and not SourceScript.name  like ''sys%''
and SourceScript.Xtype in (''P'', ''TF'',''TR'',''V'',''FN'',''U'',''d'')
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
order by SourceScript.name
'
exec (@sqlScript)