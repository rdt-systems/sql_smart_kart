SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetActivityHistory]
(@RowID uniqueidentifier)
AS 
select * from ActivityView where Rowid = @RowID or Rowid = (select top 1 ItemNo from itemstore where Itemstoreid = @RowID)
order by datecreated desc
GO