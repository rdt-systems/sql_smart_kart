SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[SupplierListView]
AS
SELECT     dbo.Supplier.Name AS SupplierName, dbo.ReceiveEntry.NetCost, dbo.ReceiveEntry.UOMQty, dbo.ReceiveEntry.ItemStoreNo, dbo.ReceiveOrder.ReceiveOrderDate, 
                      dbo.Supplier.SupplierID AS SupplierNo
FROM         dbo.ReceiveEntry INNER JOIN
                      dbo.ReceiveOrder ON dbo.ReceiveEntry.ReceiveNo = dbo.ReceiveOrder.ReceiveID RIGHT OUTER JOIN
                      dbo.Supplier ON dbo.ReceiveOrder.SupplierNo = dbo.Supplier.SupplierID
WHERE     (dbo.ReceiveEntry.Status > - 1) AND (dbo.ReceiveOrder.Status > - 1) AND (dbo.Supplier.Status > - 1)
GO