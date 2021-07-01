SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[SysCommissionTypeView]
WITH SCHEMABINDING 
AS
SELECT        SystemValueNo, SystemValueName, SortOrder, SystemTableNo, SystemValueNameHe, DateModified
FROM           dbo.SystemValues
WHERE        (SystemTableNo = 4)
GO