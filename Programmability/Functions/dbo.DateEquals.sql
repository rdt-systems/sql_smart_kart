SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[DateEquals](@d1 datetime,@d2 datetime)
RETURNS  bit  AS  
BEGIN 

	if convert(varchar,@d1,101)=convert(varchar,@d2,101)
	return 1

return 0
END
GO