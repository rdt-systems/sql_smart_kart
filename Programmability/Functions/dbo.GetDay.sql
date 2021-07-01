SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE function [dbo].[GetDay] (@Date datetime) 
returns datetime
WITH SCHEMABINDING 
 as
begin
	declare @RetDate datetime
	set @RetDate=cast(Cast(year(@Date)as nvarchar)+'-'
				+Cast(Month(@Date)as nvarchar)+'-'
				+Cast(Day(@Date)as nvarchar) as DateTime)
	return @RetDate			
end
GO