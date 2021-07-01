SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SysVisaType]
AS
SELECT     dbo.SystemValues.*
FROM         dbo.SystemValues
WHERE     (SystemTableNo = 5)
GO