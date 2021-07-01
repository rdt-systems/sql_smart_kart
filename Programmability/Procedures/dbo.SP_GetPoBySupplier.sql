SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_GetPoBySupplier](@SupplierID uniqueidentifier)
AS SELECT     dbo.PurchaseOrderEntry.*
FROM         dbo.Supplier RIGHT OUTER JOIN
                      dbo.PurchaseOrders ON dbo.Supplier.SupplierID = dbo.PurchaseOrders.SupplierNo RIGHT OUTER JOIN
                      dbo.PurchaseOrderEntry ON dbo.PurchaseOrders.PurchaseOrderId = dbo.PurchaseOrderEntry.PurchaseOrderNo
WHERE     (dbo.PurchaseOrders.SupplierNo = @SupplierID)
GO