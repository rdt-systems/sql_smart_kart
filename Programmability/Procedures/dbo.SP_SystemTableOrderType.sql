SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_SystemTableOrderType]
(
@DateModified datetime=null
)
AS 
SELECT        TOP (100) PERCENT SystemValueNo, SystemValueName, SortOrder, SystemTableNo, SystemValueNameHe, DateModified, 1 AS Status
FROM            dbo.SystemValues
WHERE        (SystemTableNo = 56) AND (ISNULL(DateModified,dbo.GetLocalDate()) >@DateModified)
GO