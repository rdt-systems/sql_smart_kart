SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[SysBarcodeTypeView]
WITH SCHEMABINDING 
AS
SELECT        SystemValueNo, SystemValueName, SortOrder, SystemTableNo, SystemValueNameHe, DateModified
FROM            dbo.SystemValues
WHERE        (SystemTableNo = 12)
GO