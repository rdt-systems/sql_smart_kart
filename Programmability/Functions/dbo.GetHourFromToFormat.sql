SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[GetHourFromToFormat](
    @d DATETIME, 
    @AM bit =1
)RETURNS  varchar(50)  

AS  

BEGIN 

declare @format VARCHAR(16)
if  @AM=1 
	set @format='HH:MM 12'
else set @format='HH:MM 24'

return dbo.FormatDateTime(dateadd(minute,- datepart(minute,@d),@d),@format)+' - '+
		dbo.FormatDateTime(dateadd(minute,- datepart(minute,@d),dateadd(hh,1,@d)),@format)
--return LTRIM(SUBSTRING(CONVERT(VARCHAR(20),@d , 22), 10, 2) +':00'
--        + RIGHT(CONVERT(VARCHAR(20), @d, 22), 3)+' - '+SUBSTRING(CONVERT(VARCHAR(20),dateadd(hh,1,@d) , 22), 10, 2) +':00'
--        + RIGHT(CONVERT(VARCHAR(20), dateadd(hh,1,@d), 22), 3))

END
GO