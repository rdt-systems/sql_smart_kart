﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[strip_spaces](@str varchar(8000))
RETURNS varchar(8000) AS
BEGIN 
    WHILE CHARINDEX('  ', @str) > 0 
        SET @str = REPLACE(@str, '  ', ' ')

    RETURN @str
END
GO