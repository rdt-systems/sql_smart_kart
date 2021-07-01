SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_GetAliseAndItemStoreID]
AS SELECT     dbo.ItemMainAndStoreView.ItemStoreID, dbo.ItemAliasView.BarcodeNumber, dbo.ItemMainAndStoreView.LinkNo
FROM         dbo.ItemMainAndStoreView RIGHT OUTER JOIN
                      dbo.ItemAliasView ON dbo.ItemMainAndStoreView.ItemID = dbo.ItemAliasView.ItemNo
WHERE     (dbo.ItemMainAndStoreView.LinkNo IS NULL) and dbo.ItemAliasView.Status>0
GO