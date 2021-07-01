SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[System Tables]
AS
SELECT     TOP 100 PERCENT dbo.SystemTables.SystemTableName, dbo.SystemValues.SystemValueName, dbo.SystemValues.SystemValueNo
FROM         dbo.SystemTables INNER JOIN
                      dbo.SystemValues ON dbo.SystemTables.SystemTableId = dbo.SystemValues.SystemTableNo
ORDER BY dbo.SystemTables.SystemTableName
GO