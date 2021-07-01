SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE VIEW [dbo].[ItemAliasViewPOS]
AS
Select
    ItemAlias.BarcodeNumber AS AliasUPC,
    ItemMain.BarcodeNumber As ItemMainUPC,
    ItemAlias.AliasId,
    ItemAlias.DateModified,
    ItemAlias.Status
From
    ItemMain Inner Join
    ItemAlias On ItemAlias.ItemNo = ItemMain.ItemID
GO