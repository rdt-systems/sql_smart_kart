SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE VIEW [dbo].[ItemAliasView]
AS
SELECT     AliasId, ItemNo, BarcodeNumber, Status, DateCreated, UserCreated, DateModified, UserModified
FROM         dbo.ItemAlias
--WHERE     (Status > - 1)
GO