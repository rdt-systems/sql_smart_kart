SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE   FUNCTION [dbo].[GetAgingDiff] (@d1 datetime,@d2 datetime)  
RETURNS int AS  
BEGIN 

declare @D int 
set @d=datediff(day,@d1,@d2)
if @d<0
	return -1
if @d<30
	return 0
if @d<60
	return 1
if @d<90
	return 2
if @d<120
	return 3
return 4

END
GO