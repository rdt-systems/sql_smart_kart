SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE procedure [dbo].[GetSecuirtyOfColumns]
(@GroupID uniqueidentifier,
 @GridType NvarChar(50))
as 
select ColumnName as [Name],2 as Status From SecurityOfColumns 
where GroupID=@GroupID and GridType=@GridType
GO