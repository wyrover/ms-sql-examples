' ------------------------------------------------------------
'  Copyright ©2001 Mike G --> IvbNET.COM
'  All Rights Reserved, http://www.ivbnet.com
'  EMAIL : webmaster@ivbnet.com
' ------------------------------------------------------------
'  You are free to use this code within your own applications,
'  but you are forbidden from selling or distributing this
'  source code without prior written consent.
' ------------------------------------------------------------


--CONVERT to Julian date
CREATE FUNCTION [dbo].[ToJulDate] (@month smallint,@day smallint,@year smallint)  
RETURNS INT
AS  

BEGIN 
DECLARE @jdate int
SELECT @jdate = (@year - 1) * 365 - @year/100 + @year/400 + (@year - 1 ) / 4 
 IF @month > 2 AND ( ( @year%100 != 0 AND @year%4 = 0 ) OR @year%400 = 0 ) 
 SELECT @jdate = @jdate + 1 
 SELECT @jdate = @jdate + 31 * ( @month - 1 ) + @day

IF ( @month > 2 ) 
 SELECT @jdate = @jdate - 3 
IF ( @month > 4 )  
 SELECT @jdate = @jdate -  1       
IF ( @month > 6 ) 
 SELECT @jdate = @jdate - 1 
IF ( @month > 9 ) 
 SELECT @jdate = @jdate - 1 
IF ( @month > 11 ) 
 SELECT @jdate = @jdate - 1 
RETURN @jdate

END


--CONVERT FROM Julian date
CREATE FUNCTION [dbo].[JulDate] (@Date int)  
RETURNS datetime AS  
BEGIN 
	RETURN(DATEADD(DAY,@Date - 722815,'1/1/80')) 
END


