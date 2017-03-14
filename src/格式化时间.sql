
ALTER FUNCTION dbo.KillTime
(
	@Dat smalldatetime
	/*
	@parameter1 datatype = default value,
	@parameter2 datatype
	*/
)
RETURNS smalldatetime
AS
	
BEGIN
	declare @Dat1 smalldatetime
		
	set @Dat1 = Cast(rtrim(ltrim(cast(year(@Dat) as char(4)))) + '-' + rtrim(ltrim(cast(month(@Dat) as char(2)))) + '-'  + rtrim(ltrim(cast(day(@Dat) as char(2)))) as smalldatetime)
	RETURN @Dat1	
END
