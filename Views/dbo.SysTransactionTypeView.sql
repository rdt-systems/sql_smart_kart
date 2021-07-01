SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SysTransactionTypeView]
AS
SELECT     dbo.SystemValues.*
FROM         dbo.SystemValues
WHERE     (SystemTableNo = 16)
GO