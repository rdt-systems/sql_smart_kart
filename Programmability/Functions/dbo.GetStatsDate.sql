SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  FUNCTION [dbo].[GetStatsDate](@StatDateType int,@StatDateCount int)
RETURNS  datetime  AS  
BEGIN 
declare @x datetime
-- 1 day -- 2 week -- month  
if @StatDateType = 1  
set @x=   convert( datetime,convert(date, DATEADD(d,@StatDateCount*-1,getdate())))
else if @StatDateType = 2 
set @x=   convert( datetime,convert(date, DATEADD(ww,@StatDateCount*-1,getdate())))
else if @StatDateType = 3  
set @x=   convert( datetime,convert(date, DATEADD(mm,@StatDateCount*-1,getdate())))

return  @x

END
GO