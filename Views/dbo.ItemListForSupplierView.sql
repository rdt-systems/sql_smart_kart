SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE      VIEW [dbo].[ItemListForSupplierView]
AS
SELECT     dbo.ItemStore.Status, dbo.ItemMain.ItemType, dbo.ItemStore.StoreNo, dbo.ItemSupply.SupplierNo, dbo.ItemMain.LinkNo, dbo.ItemMain.Name, 
                      dbo.ItemMain.ItemID, dbo.ItemMain.BarcodeNumber AS UPC, dbo.ItemSupply.AverageDeliveryDelay AS [Average Delivery Delay],
                      isnull(dbo.ItemSupply.TotalCost,0) AS Cost, dbo.ItemSupply.MinimumQty AS [Min Qty], dbo.ItemSupply.IsOrderedOnlyInCase AS [Case Only],isnull(dbo.ItemSupply.IsMainSupplier,0) as [Main Supplier]
FROM         dbo.ItemSupply INNER JOIN
                      dbo.ItemStore ON dbo.ItemSupply.ItemStoreNo = dbo.ItemStore.ItemStoreID and dbo.ItemStore.Status>-1 INNER JOIN
                      dbo.ItemMain ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID and  dbo.ItemMain.Status>-1
where dbo.ItemSupply.Status>0
GO