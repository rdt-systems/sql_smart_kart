SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[Random] (@Upper INT,@Lower INT, @randomvalue numeric(18,10))
RETURNS INT
AS
BEGIN
DECLARE @Random INT
SELECT @Random = ROUND(((@Upper - @Lower -1) * @randomvalue + @Lower), 0)
RETURN @Random
END;
GO