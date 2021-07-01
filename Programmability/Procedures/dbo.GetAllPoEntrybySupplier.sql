SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[GetAllPoEntrybySupplier]
AS SELECT     dbo.ItemMain.Name, dbo.Supplier.Name AS SupName, dbo.PurchaseOrders.PoNo, dbo.PurchaseOrderEntry.QtyOrdered, 
                      dbo.PurchaseOrderEntry.PricePerUnit, dbo.Supplier.WebSite
FROM         dbo.ItemSupply RIGHT OUTER JOIN
                      dbo.ItemStore ON dbo.ItemSupply.ItemStoreNo = dbo.ItemStore.ItemStoreID RIGHT OUTER JOIN
                      dbo.ItemMain ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID RIGHT OUTER JOIN
                      dbo.Supplier INNER JOIN
                      dbo.PurchaseOrders ON dbo.Supplier.SupplierID = dbo.PurchaseOrders.SupplierNo LEFT OUTER JOIN
                      dbo.PurchaseOrderEntry ON dbo.PurchaseOrders.PurchaseOrderId = dbo.PurchaseOrderEntry.PurchaseOrderNo ON 
                      dbo.ItemStore.ItemStoreID = dbo.PurchaseOrderEntry.ItemNo
GO