SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE function [dbo].[GetFirstDayOfWeek] (@Date datetime,@FirstDayOfWeek smallint) 
returns datetime
 as
begin

	set @Date=dateadd(day,- 
			            case when (datepart(dw,@Date)>=@FirstDayOfWeek) 
					         then (datepart(dw,@Date)-@FirstDayOfWeek) 
							 else (datepart(dw,@Date)-@FirstDayOfWeek+7) 
						end,@Date) 

declare @RetDate datetime 
set @RetDate=     cast(Cast(year (@Date)as nvarchar)+'-'
				+Cast(Month(@Date)as nvarchar)+'-'
				+Cast(Day(@Date)as nvarchar) as DateTime)

return @RetDate			
end
GO