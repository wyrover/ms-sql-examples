DECLARE @intLength AS INTEGER
DECLARE @vchRegularExpression AS VARCHAR(50)
DECLARE @vchSourceString as VARCHAR(50)
DECLARE @vchSourceString2 as VARCHAR(50)
DECLARE @bitHasNoSpecialCharacters as BIT

-- Initialize variables
SET @vchSourceString = 'Test one This is a test!!'
SET @vchSourceString2 = 'Test two This is a test'

-- Our regular expression should read as:
-- [a-zA-Z ]{}
-- eg. [a-zA-Z ]{10}  ...  For a string of 10 characters

-- Get the length of the string
SET @intLength = LEN(@vchSourceString)

-- Set the completed regular expression
SET @vchRegularExpression = '[a-zA-Z ]{' + 
CAST(@intLength as varchar) + '}'

-- get whether or not there are any special characters
SET @bitHasNoSpecialCharacters = dbo.find_regular_expression(
@vchSourceString, @vchRegularExpression,0)

PRINT @vchSourceString
IF @bitHasNoSpecialCharacters = 1 BEGIN
	PRINT 'No special characters.'
END ELSE BEGIN
	PRINT 'Special characters found.'
END

PRINT '---'

-- Get the length of the string
SET @intLength = LEN(@vchSourceString2)

-- Set the completed regular expression
SET @vchRegularExpression = '[a-zA-Z ]{' + 
CAST(@intLength as varchar) + '}'

-- get whether or not there are any special characters
SET @bitHasNoSpecialCharacters = dbo.find_regular_expression(
@vchSourceString2, @vchRegularExpression,0)

PRINT @vchSourceString2
IF @bitHasNoSpecialCharacters = 1 BEGIN
	PRINT 'No special characters.'
END ELSE BEGIN
	PRINT 'Special characters found.'
END

GO
