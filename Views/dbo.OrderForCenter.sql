SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE    VIEW [dbo].[OrderForCenter]
AS
SELECT     PurchaseOrderId, PoNo, 0 AS Type, PurchaseOrderDate, GrandTotal,
                         Postatus,SupplierNo, StoreNo,dbo.PurchaseOrders.Status as IsVoid
FROM         dbo.PurchaseOrders 
where Status>-1
GO