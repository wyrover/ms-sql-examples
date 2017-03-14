CREATE FUNCTION dbo.find_regular_expression
	(
		@source varchar(5000),
		@regexp varchar(1000),
		@ignorecase bit = 0
	)
RETURNS bit
AS
	BEGIN
		DECLARE @hr integer
		DECLARE @objregexp integer
		DECLARE @objmatches integer
		DECLARE @objmatch integer
		DECLARE @count integer
		DECLARE @results bit

		EXEC @hr = sp_oacreate 'VBScript.RegExp', @objregexp OUTPUT
		IF @hr <> 0 BEGIN
			SET @results = 0
			RETURN @results
		END
		EXEC @hr = sp_oasetproperty @objregexp, 'Pattern', @regexp
		IF @hr <> 0 BEGIN
			SET @results = 0
			RETURN @results
		END
		EXEC @hr = sp_oasetproperty @objregexp, 'Global', FALSE
		IF @hr <> 0 BEGIN
			SET @results = 0
			RETURN @results
		END
		EXEC @hr = sp_oasetproperty @objregexp, 'IgnoreCase', @ignorecase
		IF @hr <> 0 BEGIN
			SET @results = 0
			RETURN @results
		END
		EXEC @hr = sp_oamethod @objregexp, 'Test', @results OUTPUT, @source
		IF @hr <> 0 BEGIN
			SET @results = 0
			RETURN @results
		END
		EXEC @hr = sp_oadestroy @objregexp
		IF @hr <> 0 BEGIN
			SET @results = 0
			RETURN @results
		END
	RETURN @results
	END
