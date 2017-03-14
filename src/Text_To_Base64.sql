Create FUNCTION Text_To_Base64
	(@source as varchar(8000))
returns Varchar(8000)
begin
/*
Author Philip Leitch 6/1/04
Converts Base 256 Ascii characters (text or not) to Base64 characters

Notes:
see Base64_To_Text for extensive commenting on base conversion as this is a quick run down.

This is a conversion of a base 256 numbering system into a base 64 numbering system.
It is made easier by breaking it into two steps:
	Step 1 - convert from Base 256 to Base 10/2
			* shown to us as base 10, but stored as base 2.  This is significant because we use the base 2 
			   properties by shifting the bits left and right.
			
	Step 2 - Convert from Base 10/2 to base 64

*/


declare @Number_Builder as int

Declare @char1 as smallint
declare @char2 as smallint
declare @char3 as smallint
declare @char4 as smallint
declare @result as varchar(8000)
set @result = ''

declare @i as int
while len(@source) > 0
	begin
	set @i = 1
	set @Number_Builder = 0
	while @i <= 3
		begin
		--Constructing a 3 character base 256 number
		--Each character advancement multiplies by 256.... because this is base 256...
		if @i > len(@source)
			begin
			set @Number_Builder = @Number_Builder*256
			end
		else
			begin
			set @Number_Builder = @Number_Builder*256 + ascii(substring(@source, @i, 1))
			end
		set @i = @i +1
		end
	--Remove the base 256 characters we have just used
	if len(@source) > 3
		set @source = right(@source, len(@source) - 3)
	else
		set @source = ''

	--At this stage we have a base10/2 number, we can now get our base64 numbers out

	set @char1 = @Number_Builder/262144 -- 64^3 (first number)
	set @Number_Builder = @Number_Builder & 262143
	set @char2 = @Number_Builder/4096	 --64^2 (second number)
	set @Number_Builder = @Number_Builder & 4095
	set @char3 = @Number_Builder/64	--64^1 (third number)
	set @Number_Builder = @Number_Builder & 63
	set @char4 = @Number_Builder  	--64^0 (fifth number)

	
	--Convert from actual base64 to ascii representation of base 64
	set @char1 =@char1 + case 	when @char1 between 0 and 25 	then  ascii('A')
					When @char1 between 26 and 51 	then ascii('a') - 26
					When @char1 between 52 and 63 	then ascii('0') - 52 end
	set @char2 = @char2 + case 	when @char2 between 0 and 25 	then ascii('A')
					When @char2 between 26 and 51 	then ascii('a') - 26
					When @char2 between 52 and 63 	then ascii('0') - 52 end
	set @char3 = @char3 + case 	when @char3 between 0 and 25 	then ascii('A')
					When @char3 between 26 and 51 	then ascii('a') - 26
					When @char3 between 52 and 63 	then ascii('0') - 52 end
	set @char4 = @char4 + case 	when @char4 between 0 and 25 	then ascii('A')
					When @char4 between 26 and 51 	then ascii('a') - 26
					When @char4 between 52 and 63 	then ascii('0') - 52 end

	--Add these four characters to the string
	set @result =@result +  char(@char1) + char(@char2) +char(@char3) +char(@char4) 

	end	
	return @result
end
go

select dbo.text_to_base64('ABC')

select dbo.text_to_base64('Testing, 1,2,blah blah bblah test')
