SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SysPCUserType]
AS
SELECT     SystemValueNo, SystemValueName
FROM         dbo.SystemValues
WHERE     (SystemTableNo = 31)
GO