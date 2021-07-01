SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SystemTableShiftNo]
AS
--SELECT        TOP (100) PERCENT SystemValueNo, SystemValueName, SortOrder, SystemTableNo, SystemValueNameHe, DateModified, 1 AS Status
--FROM            dbo.SystemValues
--WHERE        (SystemTableNo = 53)

SELECT       TOP (100) PERCENT PhoneNoteIDVal AS SystemValueNo, Value AS SystemValueName,Sort AS SortOrder, 53 AS SystemTableNo, Value AS SystemValueNameHe, dbo.GetLocalDATE() as DateModified, Status
FROM            PhoneNote
WHERE        (Type = 0)
GO