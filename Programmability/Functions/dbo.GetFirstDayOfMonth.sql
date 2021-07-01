SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create function [dbo].[GetFirstDayOfMonth] (@Date datetime) 
returns datetime as
begin
	declare @RetDate datetime
	set @RetDate=Cast (Cast(year(@Date)as nvarchar) +'-'
				+      Cast(Month(@Date)as nvarchar)+'-1'
				 as DateTime)
	return @RetDate			
end
GO