SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_OrderItemForHistory]
AS SELECT     dbo.PurchaseOrders.SupplierNo, dbo.PurchaseOrders.PurchaseOrderDate, dbo.PurchaseOrderEntryView.PricePerUnit, 
                      dbo.PurchaseOrderEntryView.IsSpecialPrice, dbo.PurchaseOrderEntryView.ItemNo
FROM         dbo.PurchaseOrderEntryView INNER JOIN
                      dbo.PurchaseOrders ON dbo.PurchaseOrderEntryView.PurchaseOrderNo = dbo.PurchaseOrders.PurchaseOrderId
GO