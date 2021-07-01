SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE   FUNCTION [dbo].[GetMaxShifthNumber] (@Register nvarchar(50))  
RETURNS bigint AS  
BEGIN 

declare @delimiter char(1)
SET @delimiter=isnull((select top 1 OptionValue from setupValues where optionID=106),'-')

declare @ret bigint
set @ret= (select max(
case when Isnumeric(right(ShiftNO,len(ShiftNO)-charindex(@delimiter,ShiftNO))) =1 Then 
                                     right(ShiftNO,len(ShiftNO)-charindex(@delimiter,ShiftNO)) else -1 end)
from [RegShift] 
where 
--status>0 and 
ShiftNO like @Register+@delimiter+'%' )

return @ret
END
GO