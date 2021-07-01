SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[PurOrderHistoryPPC]
AS
SELECT     dbo.PurchaseOrders.PurchaseOrderId AS PurchaseID, dbo.PurchaseOrders.StoreNo, dbo.PurchaseOrders.SupplierNo, dbo.PurchaseOrders.PurchaseOrderDate, 
                      dbo.Supplier.Name AS Supplier, dbo.PurchaseOrders.GrandTotal
FROM         dbo.PurchaseOrders INNER JOIN
                      dbo.Supplier ON dbo.PurchaseOrders.SupplierNo = dbo.Supplier.SupplierID
WHERE     (dbo.PurchaseOrders.Status > - 1)
GO