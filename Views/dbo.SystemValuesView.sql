SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SystemValuesView]
AS
SELECT     TOP 100 PERCENT dbo.SystemValues.SystemValueNo, dbo.SystemValues.SystemValueName, dbo.SystemValues.SortOrder, 
                      dbo.SystemTables.SystemTableId, dbo.SystemValues.SystemValueNameHe
FROM         dbo.SystemValues INNER JOIN
                      dbo.SystemTables ON dbo.SystemValues.SystemTableNo = dbo.SystemTables.SystemTableId
ORDER BY dbo.SystemTables.SystemTableName, dbo.SystemValues.SortOrder
GO