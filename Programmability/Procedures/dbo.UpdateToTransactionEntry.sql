SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateToTransactionEntry]
(@Total  decimal(19,3),
@Qty decimal(19,3),
@ItemStoreID uniqueidentifier,
@TransactionEntryType int,
@ModifierID uniqueidentifier,
@UpdateParent bit =1)
as

IF (SELECT        ISNULL(ItemMain.ItemType, 0) AS ItemType
FROM            dbo.ItemStore WITH (NOLOCK) INNER JOIN
                         dbo.ItemMain WITH (NOLOCK) ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemStore.ItemStoreID = @ItemStoreID)) IN (3,5,7,9)
BEGIN	
IF (@TransactionEntryType<>2) --not return item entry
UPDATE dbo.ItemStore
	SET 	OnHand = 0 , 
		MTDQty=isnull(MTDQty,0)+@Qty, 
		PTDQty=isnull(PTDQty,0)+@Qty, 
		YTDQty=isnull(YTDQty,0)+@Qty, 
		MTDDollar=isnull(MTDDollar,0)+ ROUND(@Total,2), 
		PTDDollar=isnull(PTDDollar,0)+ ROUND(@Total,2),
		YTDDollar=isnull(YTDDollar,0)+ ROUND(@Total,2),
		DateModified = dbo.GetLocalDATE(), 
		UserModified = @ModifierID
	WHERE ItemStoreID = @ItemStoreID
		ELSE
	UPDATE dbo.ItemStore
	SET 	OnHand = 0, 
		MTDReturnQty=isnull(MTDReturnQty,0)-@Qty,  -- Qty Is Minus in case of return item so it comes out plus 
		PTDReturnQty=isnull(PTDReturnQty,0)-@Qty,
		YTDReturnQty=isnull(YTDReturnQty,0)-@Qty, 
	 	DateModified = dbo.GetLocalDATE(), 
		UserModified = @ModifierID
	WHERE ItemStoreID = @ItemStoreID

END
	ELSE BEGIN
	IF (@TransactionEntryType<>2) --not return item entry
	UPDATE dbo.ItemStore
	SET 	OnHand = isnull(OnHand,0) - @Qty , 
		MTDQty=isnull(MTDQty,0)+@Qty, 
		PTDQty=isnull(PTDQty,0)+@Qty, 
		YTDQty=isnull(YTDQty,0)+@Qty, 
		MTDDollar=isnull(MTDDollar,0)+ ROUND(@Total,2), 
		PTDDollar=isnull(PTDDollar,0)+ ROUND(@Total,2),
		YTDDollar=isnull(YTDDollar,0)+ ROUND(@Total,2),
		DateModified = dbo.GetLocalDATE(), 
		UserModified = @ModifierID
	WHERE ItemStoreID = @ItemStoreID
		ELSE
	UPDATE dbo.ItemStore
	SET 	OnHand = isnull(OnHand,0)-@Qty, 
		MTDReturnQty=isnull(MTDReturnQty,0)-@Qty,  -- Qty Is Minus in case of return item so it comes out plus 
		PTDReturnQty=isnull(PTDReturnQty,0)-@Qty,
		YTDReturnQty=isnull(YTDReturnQty,0)-@Qty, 
	 	DateModified = dbo.GetLocalDATE(), 
		UserModified = @ModifierID
	WHERE ItemStoreID = @ItemStoreID

		if @UpdateParent=1
		 EXEC UpdateParent @ItemStoreID,@ModifierID,1,1,0,1,1
		END
GO