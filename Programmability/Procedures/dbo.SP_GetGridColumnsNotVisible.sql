SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


create procedure [dbo].[SP_GetGridColumnsNotVisible]

as 
select GridNumber,FieldName
from  dbo.GridColumnsNotVisible
GO