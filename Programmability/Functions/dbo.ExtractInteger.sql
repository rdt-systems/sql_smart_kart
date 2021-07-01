SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[ExtractInteger](@string VARCHAR(2000))
RETURNS VARCHAR(2000)
    AS

    BEGIN
        DECLARE @count int
        DECLARE @intNumbers VARCHAR(1000)
        SET @count = 0
        SET @intNumbers = ''

        WHILE @count <= LEN(@string)
        BEGIN 
            IF SUBSTRING(@string, @count, 1)>='0' and SUBSTRING (@string, @count, 1) <='9'
                BEGIN
                    SET @intNumbers = @intNumbers + SUBSTRING (@string, @count, 1)
                END
            SET @count = @count + 1
        END
        RETURN @intNumbers
    END
GO