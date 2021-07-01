SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[SystemTableOrderType]
AS
SELECT        TOP (100) PERCENT SystemValueNo, SystemValueName, SortOrder, SystemTableNo, SystemValueNameHe, DateModified, 1 AS Status
FROM            dbo.SystemValues
WHERE        (SystemTableNo = 56)
GO