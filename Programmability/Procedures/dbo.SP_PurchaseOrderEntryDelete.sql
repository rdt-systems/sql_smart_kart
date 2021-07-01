SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PurchaseOrderEntryDelete]
(@PurchaseOrderEntryId uniqueidentifier, 
@ModifierID  uniqueidentifier) 
     

AS
Declare @OldStatus Decimal 
Set @OldStatus =(Select Status From dbo.PurchaseOrderEntry where  PurchaseOrderEntryId = @PurchaseOrderEntryId)

Declare @ItemNo uniqueidentifier 
Set @ItemNo =(Select ItemNo From dbo.PurchaseOrderEntry where  PurchaseOrderEntryId = @PurchaseOrderEntryId)


UPDATE  dbo.PurchaseOrderEntry            
SET             Status = - 1,   DateModified = dbo.GetLocalDATE(),  UserModified = @ModifierID
WHERE  PurchaseOrderEntryId = @PurchaseOrderEntryId

exec UpdateOnOrderByOrder @ItemNo,@ModifierID
GO