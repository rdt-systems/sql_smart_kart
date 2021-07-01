SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PurOrderEntryPPC]
AS
SELECT     dbo.ItemMain.Name AS ItemName, dbo.ItemMain.BarcodeNumber AS BarCode, dbo.PurchaseOrderEntry.UOMQty AS QtyOrdered, 
                      dbo.PurchaseOrderEntry.PurchaseOrderEntryId, dbo.PurchaseOrderEntry.PurchaseOrderNo AS PurchaseOrderID, dbo.PurchaseOrderEntry.ItemNo, 
                      dbo.PurchaseOrderEntry.UOMType, dbo.PurchaseOrderEntry.PricePerUnit AS UOMPrice, dbo.PurchaseOrderEntry.SortOrder
FROM         dbo.ItemStore INNER JOIN
                      dbo.ItemMain ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID INNER JOIN
                      dbo.PurchaseOrderEntry ON dbo.ItemStore.ItemStoreID = dbo.PurchaseOrderEntry.ItemNo
GO