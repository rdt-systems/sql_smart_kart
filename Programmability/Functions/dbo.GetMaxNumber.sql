SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE   FUNCTION [dbo].[GetMaxNumber] (@Register nvarchar(50))  
RETURNS bigint AS  
BEGIN 

declare @delimiter char(1)
SET @delimiter=isnull((select top 1 OptionValue from setupValues where optionID=106),'-')

declare @ret bigint
set @ret= (select max(
case when Isnumeric(REVERSE(SUBSTRING(REVERSE(TransactionNo), 1, CHARINDEX('-', REVERSE(TransactionNo), 1) - 1))) =1 Then 
                                    REVERSE(SUBSTRING(REVERSE(TransactionNo), 1, CHARINDEX('-', REVERSE(TransactionNo), 1) - 1)) else -1 end)
									
from [transaction]
where 
--status>0 and 
transactionno like @Register+@delimiter+'%' )

return @ret
END
GO