SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PurchaseOrdersInsert_HandHeld]
(@PurchaseOrderId uniqueidentifier,
@SupplierNo uniqueidentifier,
@StoreNo uniqueidentifier,
@GrandTotal money,
@ModifierID uniqueidentifier)
AS INSERT INTO dbo.PurchaseOrders
           (PurchaseOrderId, SupplierNo,StoreNo,GrandTotal,UserModified)
VALUES     (@PurchaseOrderId, @SupplierNo, @StoreNo,@GrandTotal,@ModifierID)
GO