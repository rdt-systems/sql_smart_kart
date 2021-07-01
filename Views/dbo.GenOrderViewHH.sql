SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[GenOrderViewHH]
AS
SELECT        dbo.ItemMainAndStoreView.Name AS ItemName, dbo.Supplier.Name AS SupplierName, dbo.ItemMainAndStoreView.BarcodeNumber, 
                         dbo.GenPurchaseOrder.ToOrder, dbo.GenPurchaseOrder.ReorderQty AS QtyOrdered, dbo.GenPurchaseOrder.UOMType, 
                         dbo.GenPurchaseOrder.Supplier AS SupplierNo, dbo.GenPurchaseOrder.GenPurchaseOrderID, dbo.GenPurchaseOrder.Status, 
                         dbo.GenPurchaseOrder.ItemNo, dbo.GenPurchaseOrder.DateModified, dbo.GenPurchaseOrder.SortOrder, dbo.GenPurchaseOrder.DateCreated, 
                         dbo.GenPurchaseOrder.StoreID
FROM            dbo.GenPurchaseOrder INNER JOIN
                         dbo.ItemMainAndStoreView ON dbo.GenPurchaseOrder.ItemNo = dbo.ItemMainAndStoreView.ItemStoreID LEFT OUTER JOIN
                         dbo.Supplier ON dbo.GenPurchaseOrder.Supplier = dbo.Supplier.SupplierID
						 Where (dbo.ItemMainAndStoreView.Status >0)
GO