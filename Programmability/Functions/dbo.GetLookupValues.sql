SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE function [dbo].[GetLookupValues] (@Id uniqueidentifier) 
returns varchar(50)
WITH SCHEMABINDING 
 as
begin

declare 
 @ValueName varchar(50)

select @ValueName= ValueName
from dbo.ItemsLookupValues
 where ValueID =@Id
 return @ValueName

	
end
GO