CREATE TABLE CR (ID tinyint IDENTITY PRIMARY KEY,
                 Project varchar(30),
					  StartDate datetime)
go
CREATE PROCEDURE pr_CR_INSERT
@Project varchar(30),
@StartDate datetime,
@ReturnValue tinyint OUTPUT
AS
INSERT CR VALUES (@Project,@StartDate)
SET @ReturnValue=@@IDENTITY
go




²âÊÔ


DECLARE @ProcName sysname,
        @CmdName varchar(30)
SET @ProcName='pr_CR_INSERT'
SET @CmdName='cmd1'


SELECT @CmdName+'.Parameters.Append '+
       @CmdName+'.CreateParameter("'+SUBSTRING(Parameter_Name,2,128)+'",'+
       CASE Data_Type
        WHEN 'varchar' THEN 'adVarChar'
        WHEN 'char' THEN 'adVarChar'
        WHEN 'nvarchar' THEN 'adVarWChar'
        WHEN 'int' THEN 'adInteger'
        WHEN 'smallint' THEN 'adSmallInt'
        WHEN 'tinyint' THEN 'adUnsignedTinyInt'
        WHEN 'datetime' THEN 'adDate'
        ELSE 'AdVarchar'
       END+','+
       CASE WHEN Parameter_Mode='IN' THEN 'adParamInput,' ELSE 'adParamOutput' END+
       CASE WHEN Character_Maximum_Length IS NULL THEN '' ELSE CAST(Character_Maximum_Length AS varchar) END+
       CASE WHEN Parameter_Mode='IN' THEN ',request("'+SUBSTRING(Parameter_Name,2,128)+'")' ELSE '' END+')'
FROM Information_Schema.Parameters
WHERE Specific_Name=@ProcName
