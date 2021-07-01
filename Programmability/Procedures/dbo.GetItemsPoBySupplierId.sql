SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetItemsPoBySupplierId](@SupplierID uniqueidentifier)
AS SELECT     dbo.ItemMainAndStoreView.Name, dbo.ItemMainAndStoreView.Department, dbo.ItemMainAndStoreView.Price, 
                      dbo.PurchaseOrderEntryView.PurchaseOrderNo
FROM         dbo.ItemMainAndStoreView INNER JOIN
                      dbo.PurchaseOrderEntryView ON dbo.ItemMainAndStoreView.ItemStoreID = dbo.PurchaseOrderEntryView.ItemNo INNER JOIN
                      dbo.PurchaseOrdersView ON dbo.PurchaseOrderEntryView.PurchaseOrderNo = dbo.PurchaseOrdersView.PurchaseOrderId
WHERE     (dbo.PurchaseOrdersView.SupplierNo = @SupplierID)
GO