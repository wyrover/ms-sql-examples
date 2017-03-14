create FUNCTION Base64_To_Text 
	(@source as varchar(8000))
returns Varchar(8000)
begin
/*
Author Philip Leitch 6/1/04
Converts Base 64 text to standard Ascii characters (text or not)

Notes:
Essentially, this is a conversion of a base 64 numbering system into a base 256 numbering system.

It is made easier by breaking it into two steps:
	Step 1 - convert from Base 64 to Base 10/2*
			* shown to us as base 10, but stored as base 2.  This is significant because we use the base 2 
			   properties by shifting the bits left and right.
			
	Step 2 - convert from Base 10/2 to Base 256



1 ascii character = 8 bits
3 ascii characters = 24 bits
1 base 64 character = 6 bits
4 base 64 characters = 24 bits.

Therefore 3 ascii characters are represented by 4 base 64 character.
Therefore 4 base 64 character is the minimum that can be used.

The underlying number doesn't change.  By underlying number (or base number) I mean that text is actually 
a base 256 numbering system, and the number is just being stored in a different base format.

Or in other words:
Bits that make up the characters "ABC" are 10000010100001001000011
10000010100001001000011 in Base10 = 4,276,803
4,276,803 in base 64 = QUJD
QUID in base2 = 10000010100001001000011
Ergo - QUID(base64) = ABC(base256) and ABC(base256) = 4,276,803 (Base10) = 10000010100001001000011(base2)
We are just chaning the representation (base numbering format) of the same number)



By default base 64 is represented as:
A-Z = 0-25
a-z = 26-51
0-9 = 52-63

***
Note In any base system the base number never exists, it is the cycle point.
Therefore in base 2 there is only a 0 and a 1. 
In Hex (base 16) there is only 15 (F).
In Base 10 there is only 9, no single character for 10
***

To build the various base numbers I am essentialy right or left shifting.

We don't have that ability in SQL server, but dividing by 2 is a right shift of 1, multiplying by 2 is a right shift of 1.

Here is an example of right shifting 8 bits:
a = 97 = 1100001
97 * (2^8) = 97 * 256 = 24832 = 110000100000000

Dividing by multiples of 2, ignoring any remainder, shifts to the left
Cast to int is used to make it obvious that remainder is removed (floor is taken).
cast(9.9999 as int) = 9


*/
Declare @Message as varchar(8000)

set @Message = ''

Declare @Digest_Number as int --Used to convert the 4 base64 numbers into one large base 10, which is much easier to
Declare @Character_Number as bigint
Declare @Construct_Char as int
declare @i as int

while len(@source) > 0
	begin
	Set @i = 1	
	set @Character_Number = 0
	while @i <=4 
		begin
		--Create one large number from the 4 base 64 characters (see notes above)
		set @Digest_Number = case 	when  ascii(substring(@source,@i,1)) between Ascii('A') and Ascii('Z')
						then   ascii(substring(@source,@i,1)) - Ascii('A')
						when ascii(substring(@source,@i,1)) between Ascii('a') and Ascii('z')
						then   ascii(substring(@source,@i,1)) - Ascii('a')+ 26
						when ascii(substring(@source,@i,1)) between Ascii('0') and Ascii('9')
						then   ascii(substring(@source,@i,1)) - Ascii('0') + 52
						else 
							-1
						end
		if @digest_number = -1
			begin
			set @digest_number = 0
			end
	
		--Constructing a four character base 64 number
		--Each character advancement multiplies by 64.... because this is base 64...
		set @Character_Number = @Character_Number * 64 + @digest_number 

		if len(@source) = @i
			set @i = 5
		else
			set @i = @i+1
		end

	--Now remove the base 64 characters that we have just processed (should never be less than 4 as the mod (%) of the len by 4 should be 0)
	if len(@source) <=4
		set @source = ''
	else
		set @source = right(@source,len(@source) - 4)



	set @Construct_Char = 0

	--At this stage we have a base10/2 number, we can now get our base256 numbers out

	--Dividing to shift left (see notes)
	set @Construct_char = cast(@Character_Number /65536 as int) --shift 2 bytes left.  Two bytes = 18 bits = 2^16 = 65536
	set @message = @message + case when @Construct_char = 254 then char(13)
					     when @Construct_char = 192 then char(10)
					     when @Construct_char = 2 then''
						else char(@Construct_Char) end
	set @Character_Number = @Character_Number & 65535 --bitwise and to ONLY include bits under 2^16 that are "on" (removes anything over bit 16)

	set @Construct_char = cast(@Character_Number /256 as int) --shift 1 byte left - 2^8 = 256
	set @message = @message + case when @Construct_char = 254 then char(13)
					     when @Construct_char = 192 then char(10)
					     when @Construct_char = 2 then ''
						else char(@Construct_Char) end
	set @Character_Number = @Character_Number & 255

	set @Construct_char = cast(@Character_Number as int)

	set @message = @message + case when @Construct_char = 254 then char(13)
					     when @Construct_char = 192 then char(10)
					     when @Construct_char = 2 then ''
						else char(@Construct_Char) end
	set @Character_Number = 0
	end

	return @message

end
go
select dbo.Base64_To_Text('QUJD')
go
select dbo.Base64_To_Text('VGVzdGluZywgMSwyLGJsYWggYmxhaCBiYmxhaCB0ZXN0')

