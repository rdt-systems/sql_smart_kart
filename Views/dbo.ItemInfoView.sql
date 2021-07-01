SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ItemInfoView]
AS
SELECT     dbo.ItemStore.ItemStoreID, dbo.ItemMain.Name, dbo.ItemMain.ModalNumber, dbo.ItemMain.Description, dbo.ItemMain.CaseQty, 
                      dbo.ItemMain.BarcodeNumber AS UPC, dbo.ItemMain.Size
FROM         dbo.ItemMain INNER JOIN
                      dbo.ItemStore ON dbo.ItemMain.ItemID = dbo.ItemStore.ItemNo
GO