SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE   FUNCTION [dbo].[GetMaxBatchNumber] (@Register nvarchar(50))  
RETURNS bigint AS  
BEGIN 

declare @delimiter char(1)
SET @delimiter=isnull((select top 1 OptionValue from setupValues where optionID=106),'-')

declare @ret bigint
set @ret= (select max(
case when Isnumeric(right(BatchNumber,len(BatchNumber)-charindex(@delimiter,BatchNumber))) =1 Then 
                                     right(BatchNumber,len(BatchNumber)-charindex(@delimiter,BatchNumber)) else -1 end)
from [Batch]
where 
--status>0 and 
BatchNumber like @Register+@delimiter+'%' )

return @ret
END
GO