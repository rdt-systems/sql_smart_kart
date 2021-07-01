SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionEntryDelete]
(@TransactionEntryID uniqueidentifier,
@ModifierID uniqueidentifier)
AS

DECLARE @Qty decimal(19,3)
SET @Qty = (SELECT Qty FROM dbo.TransactionEntry WHERE TransactionEntryID=@TransactionEntryID)
DECLARE @UOMQty decimal(19,3)
SET @UOMQty = (SELECT UOMQty FROM dbo.TransactionEntry WHERE TransactionEntryID=@TransactionEntryID)
DECLARE @UOMPrice money
SET @UOMPrice = (SELECT UOMPrice FROM dbo.TransactionEntry WHERE TransactionEntryID=@TransactionEntryID)
DECLARE @ItemStoreID uniqueidentifier
SET @ItemStoreID = (SELECT ItemStoreID FROM dbo.TransactionEntry WHERE TransactionEntryID=@TransactionEntryID)
DECLARE @TransactionEntryType int
SET @TransactionEntryType = (SELECT TransactionEntryType FROM dbo.TransactionEntry WHERE TransactionEntryID=@TransactionEntryID)

Declare @s int
SET @s=(Select status from TransactionEntry WHERE     TransactionEntryID=@TransactionEntryID )

UPDATE    dbo.TransactionEntry
SET      Status  = -1,
         DateModified = dbo.GetLocalDATE(), 
	 UserModified = @ModifierID
WHERE     TransactionEntryID=@TransactionEntryID 

UPDATE    dbo.W_TransactionEntry
SET      Status  = -1,
         DateModified = dbo.GetLocalDATE(), 
	 UserModified = @ModifierID
WHERE     TransactionEntryID=@TransactionEntryID 

if @s=1
begin

	IF (@TransactionEntryType<>2)
		UPDATE dbo.ItemStore
		SET 	OnHand =(isnull(OnHand,0) + @Qty), 
			MTDQty=isnull(MTDQty,0)-@Qty, 
			PTDQty=isnull(PTDQty,0)-@Qty, 
			YTDQty=isnull(YTDQty,0)-@Qty, 
			MTDDollar=isnull(MTDDollar,0)- ROUND(@UOMQty* @UOMPrice,2), 
			PTDDollar=isnull(PTDDollar,0)- ROUND(@UOMQty* @UOMPrice,2),
			YTDDollar=isnull(YTDDollar,0)- ROUND(@UOMQty* @UOMPrice,2),
			DateModified=dbo.GetLocalDATE(),
			UserModified=@ModifierID
		WHERE ItemStoreID= @ItemStoreID
	ELSE
		UPDATE dbo.ItemStore
		SET 	OnHand =(isnull(OnHand,0) + @Qty), 
			MTDReturnQty=isnull(MTDReturnQty,0)+@Qty,  
			PTDReturnQty=isnull(PTDReturnQty,0)+@Qty,
			YTDReturnQty=isnull(YTDReturnQty,0)+@Qty, 
			DateModified=dbo.GetLocalDATE(),
			UserModified=@ModifierID
		WHERE ItemStoreID= @ItemStoreID
	
	EXEC UpdateParent @ItemStoreID,@ModifierID,1,0,0
end

exec SP_TransactionToWorkOrderDelete @TransactionEntryID,@ModifierID

declare @DamageItem uniqueidentifier
set @DamageItem=(Select top 1 DamageItemID from DamageItem where TransactionEntryID=@TransactionEntryID and status>0)
exec dbo.SP_DamageItemDelete @DamageItem,@ModifierID
GO