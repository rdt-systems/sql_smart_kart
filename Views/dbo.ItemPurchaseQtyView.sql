SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ItemPurchaseQtyView]
AS
SELECT     SUM(dbo.PurchaseOrderEntry.QtyOrdered) AS QtySum, dbo.PurchaseOrderEntry.ItemNo
FROM         dbo.PurchaseOrderEntry INNER JOIN
                      dbo.PurchaseOrders ON dbo.PurchaseOrderEntry.PurchaseOrderNo = dbo.PurchaseOrders.PurchaseOrderId
GROUP BY dbo.PurchaseOrderEntry.ItemNo
GO