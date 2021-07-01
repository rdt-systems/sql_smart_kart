SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetSystemTable]
(@TableName nvarchar(50),@Language bit=null)
AS 
if @Language is null
	SELECT SystemValuesView.SystemValueNo, SystemValuesView.SystemValueName, SystemValuesView.SortOrder
	FROM      SystemValuesView INNER JOIN
						  SystemTables ON SystemValuesView.SystemTableId = SystemTables.SystemTableId
	WHERE     (dbo.SystemTables.SystemTableName = @TableName)
	ORDER BY SystemValuesView.SortOrder

else
	SELECT     dbo.SystemValuesView.SystemValueNo, dbo.SystemValuesView.SystemValueNameHe as SystemValueName, dbo.SystemValuesView.SortOrder
	FROM         dbo.SystemValuesView INNER JOIN
						  dbo.SystemTables ON dbo.SystemValuesView.SystemTableId = dbo.SystemTables.SystemTableId
	WHERE     (dbo.SystemTables.SystemTableName = @TableName)
	ORDER BY SystemValuesView.SortOrder
GO