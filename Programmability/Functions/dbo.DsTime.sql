SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[DsTime](@d datetime)
RETURNS  varchar(50)  AS  
BEGIN 
declare @x varchar(50)
set @x=  convert(varchar,@d,20)

return  @x

END
GO