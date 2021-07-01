SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SysTenderTypeView]
AS
SELECT     SystemValueNo, SystemValueName
FROM         dbo.SystemValues
WHERE     (SystemTableNo = 10)
GO