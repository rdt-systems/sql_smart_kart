SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_ItemAliasViewPOS]
(
@DateModified datetime=null
)
AS 
  Select
    ItemAlias.BarcodeNumber AS AliasUPC,
    ItemMain.BarcodeNumber As ItemMainUPC,
    ItemAlias.AliasId,
    ItemAlias.DateModified,
    ItemAlias.Status
From
    dbo.ItemMain WITH (NOLOCK) Inner Join
    dbo.ItemAlias WITH (NOLOCK)  On ItemAlias.ItemNo = ItemMain.ItemID WHERE ((ItemAlias.DateModified>= @DateModified) OR (@DateModified is null))
	--and (ItemAlias.Status>0 or @ActiveOnly=0)
GO