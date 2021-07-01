SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PurchaseOrderEntryInsert_HandHeld]
(@PurchaseOrderEntryId uniqueidentifier, 
@PurchaseOrderNo uniqueidentifier, 
@ItemNo uniqueidentifier, 
@QtyOrdered decimal(19, 3), 
@PricePerUnit  money,
@ModifierID  uniqueidentifier) 
     
AS
INSERT INTO dbo.PurchaseOrderEntry
                      (PurchaseOrderEntryId, PurchaseOrderNo, ItemNo,  QtyOrdered,  PricePerUnit,UserModified)
VALUES     (@PurchaseOrderEntryId, @PurchaseOrderNo, @ItemNo, @QtyOrdered, @PricePerUnit,@ModifierID)

exec UpdateOnOrderByOrder @ItemNo,@ModifierID
GO