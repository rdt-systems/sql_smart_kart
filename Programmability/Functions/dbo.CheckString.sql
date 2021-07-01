SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  FUNCTION [dbo].[CheckString](@Str nvarchar(4000))
RETURNS nvarchar(4000)  AS  
BEGIN 
	declare @RetStr nvarchar(4000)
	IF @Str IS NULL
		set @RetStr= @Str
	else if (Select COUNT(*) From Store Where StoreID IN ('8303C0EE-16F0-4121-B72A-2DA8198E9DEE','CECE2869-DEC8-4B9E-BE8B-D74CC24661A6','2F30DB61-7BCF-4C87-823B-BC6CFCED26E9')) >0
	set @RetStr= @Str
	Else
	begin
		declare @ToUpper int 
		set @ToUpper=(select TOP(1) OptionValue from dbo.SetUpValuesView where OptionID=121 and StoreID <>'00000000-0000-0000-0000-000000000000')
		if @ToUpper=1
			set @RetStr= upper(@Str)
		else if @ToUpper=2
		BEGIN
		 
			DECLARE @InputString varchar(4000)
			DECLARE @Index          INT
			DECLARE @Char           CHAR(1)
			DECLARE @PrevChar       CHAR(1)
			DECLARE @OutputString   VARCHAR(255)
			SET @InputString = @Str 
			SET @OutputString = LOWER(@InputString)
			SET @Index = 1

			WHILE @Index <= LEN(@InputString)
			BEGIN
				SET @Char     = SUBSTRING(@InputString, @Index, 1)
				SET @PrevChar = CASE WHEN @Index = 1 THEN ' '
									 ELSE SUBSTRING(@InputString, @Index - 1, 1)
								END

				IF @PrevChar IN (' ', ';', ':', '!', '?', ',', '.', '_', '-', '/', '&', '''', '(')
				BEGIN
					IF @PrevChar != '''' OR UPPER(@Char) != 'S'
						SET @OutputString = STUFF(@OutputString, @Index, 1, UPPER(@Char))
				END 
				SET @Index = @Index + 1
			END
			SET @RetStr =@OutputString 
		END
		ELSE
			set @RetStr= @Str
	end

return @RetStr
END
GO