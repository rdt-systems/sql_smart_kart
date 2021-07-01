SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SysUOMTypeView]
AS
SELECT     dbo.SystemValues.*
FROM         dbo.SystemValues
WHERE     (SystemTableNo = 23)
GO