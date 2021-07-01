SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransactionEntryVoid]
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

UPDATE    dbo.TransactionEntry
SET      Status  = 0,
         DateModified = dbo.GetLocalDATE(), 
	 UserModified = @ModifierID
WHERE     TransactionEntryID=@TransactionEntryID 


IF (@TransactionEntryType<>2)
	UPDATE dbo.ItemStore
	SET 	OnHand =(isnull(OnHand,0) + @Qty), 
		MTDQty=isnull(MTDQty,0)-@Qty, 
		PTDQty=isnull(PTDQty,0)-@Qty, 
		YTDQty=isnull(YTDQty,0)-@Qty, 
		MTDDollar=isnull(MTDDollar,0)- ROUND(@UOMQty* @UOMPrice,2), 
		PTDDollar=isnull(PTDDollar,0)-ROUND(@UOMQty* @UOMPrice,2),
		YTDDollar=isnull(YTDDollar,0)-ROUND(@UOMQty* @UOMPrice,2),
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
exec SP_TransactionToWorkOrderVoid @TransactionEntryID,@ModifierID

update TransReturen set Status = 0 where ReturenTransID = @TransactionEntryID  
  /*	UPDATE dbo.ItemStore
  	SET OnHand = OnHand +@OldQty, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
  	WHERE ItemStoreID = @ItemStoreID 

	DECLARE @ID uniqueidentifier
	SET @ID=(SELECT LinkNo  FROM dbo.ItemMainAndStoreView WHERE ItemStoreID = @ItemStoreID)

	IF   (@ID is not null)
	BEGIN
   	 	UPDATE  dbo.ItemStore
   		SET  OnHand =  OnHand +@OldQty, DateModified = dbo.GetLocalDATE(),  UserModified = @ModifierID
    		WHERE  ItemStoreID = (SELECT ItemStoreID  FROM dbo.ItemStore WHERE StoreNo=(Select StoreNo from  dbo.ItemStore where ItemStoreID=@ItemStoreID)  AND  (ItemNo = @ID))
	END*/
GO