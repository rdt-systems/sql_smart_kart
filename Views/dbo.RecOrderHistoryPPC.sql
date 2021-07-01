SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[RecOrderHistoryPPC]
AS
SELECT     dbo.ReceiveOrder.ReceiveID, dbo.ReceiveOrder.Total AS GrandTotal, dbo.ReceiveOrder.StoreID, dbo.ReceiveOrder.SupplierNo, dbo.ReceiveOrder.ReceiveOrderDate, 
                      dbo.Supplier.Name AS Supplier, dbo.ReceiveOrder.BillID
FROM         dbo.ReceiveOrder INNER JOIN
                      dbo.Supplier ON dbo.ReceiveOrder.SupplierNo = dbo.Supplier.SupplierID
WHERE     (dbo.ReceiveOrder.Status > - 1)
GO