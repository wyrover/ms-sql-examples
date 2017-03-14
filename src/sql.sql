/*
Title: Capitalize First Character in SQL SERVER
Description: Here is a procedure for SQL Server which can be created in a module and called from a query using InitCap([fieldname])....thanks to Paul
This file came from Planet-Source-Code.com...the home millions of lines of source code
You can view comments on this code/and or vote on it at: http://www.Planet-Source-Code.com/vb/scripts/ShowCode.asp?txtCodeId=581&lngWId=5

The author may have retained certain copyrights to this code...please observe their request and the law by reviewing all copyright conditions at the above URL.
*/












EXECUTE Initcap @StrStr='String to be converted 

Again, any word enclosed within parentheses or quotes is left untouched, all others are converted into first letter uppercase and the rest lower. 

/* Procedure: InitCap will capitalise all initial letters 
              of a string passed in @StrStr
   Usage: EXECUTE InitCap @StrStr='String to be capitalised' 
for this code credit should go to
Paul Webster 
*/ 

CREATE PROCEDURE [InitCap] 
@StrStr varchar(50) 

AS 

BEGIN 
DECLARE @StrNew varchar(50) 
DECLARE @StrCurrent     varchar(1) 
DECLARE @StrPrevious    varchar(1) 
DECLARE @x              integer 
DECLARE @StrLen         integer 
DECLARE @CloseBracket   varchar(5) 
DECLARE @OpenBracket    varchar(5) 

SELECT  @StrPrevious = LEFT(@StrStr,1),@StrNew = ' ',@x = 1, @StrLen = LEN(@StrStr)+1 
SELECT @OpenBracket = CHAR(34) + CHAR(39) + CHAR(40) + CHAR(91) + CHAR(123) 
SELECT @CloseBracket = CHAR(34) + CHAR(39) + CHAR(41) + CHAR(93) + CHAR(125) 

WHILE @x < @StrLen 
        BEGIN 
        SET @StrCurrent = SUBSTRING(@StrStr,@x,1) 
        IF @x = 1 AND @StrCurrent <> ' ' SET @StrNew = @StrNew + UPPER(@StrCurrent) 
        ELSE BEGIN 
                IF (@StrPrevious = ' ' AND @StrCurrent <> ' ') 
                         SET @StrNew = @StrNew + UPPER(@StrCurrent) 
                ELSE IF CHARINDEX(@StrPrevious,@OpenBracket) <> 0 
                BEGIN 
                        SET @StrNew = @StrNew + @StrCurrent 
                        SET @x = @x +1 
                        SET @StrCurrent = SUBSTRING(@StrStr,@x,1) 
                        WHILE CHARINDEX(@StrCurrent,@CloseBracket) = 0 
                        BEGIN 
                                SET @StrNew = @StrNew + @StrCurrent 
                                SET @x = @x +1 
                                SET @StrCurrent = SUBSTRING(@StrStr,@x,1) 
                        END 
                        SET @StrNew = @StrNew + @StrCurrent 
                END 
                ELSE SET @StrNew = @StrNew + LOWER(@StrCurrent) 
        END 
        SET  @StrPrevious = @StrCurrent 
        SET @x = @x +1 
END 
PRINT @StrNew 
END 

