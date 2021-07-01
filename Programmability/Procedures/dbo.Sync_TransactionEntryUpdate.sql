SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Sync_TransactionEntryUpdate]
(
@TransactionEntryID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@TransactionID uniqueidentifier,
@Qty decimal(19,3),
@PC int,
@Price decimal(19,3),
@Sort Decimal(19,3),
@DateModified datetime=null,
@ModifierID uniqueidentifier)

as
Declare @TransactionType int
set @TransactionType=(SELECT TransactionType
					  From [Transaction]
					  Where TransactionID=@TransactionID)


Declare @Cost Decimal(19,3)
set @Cost=(SELECT [Pc Cost]
		   From ItemMainAndStoreView
		   Where ItemStoreID=@ItemStoreID)

Declare @AVGCost Decimal(19,3)
set @AVGCost=(SELECT AVGCost
			  From ItemStore
		      Where ItemStoreID=@ItemStoreID)
IF @AVGCost=0 Set @AVGCost=@Cost

Declare @CaseQty Decimal
set @CaseQty=(SELECT CaseQty
			  From ItemMainAndStoreView
		      Where ItemStoreID=@ItemStoreID)

DECLARE @OldQty decimal(19,3)

IF @TransactionType IS NOT NULL
BEGIN

SET @OldQty = (SELECT Qty 
	           FROM dbo.TransactionEntry 
			   WHERE TransactionEntryID=@TransactionEntryID)

Update TransactionEntry
Set
TransactionID=@TransactionID,
TransactionEntryType=(CASE WHEN @Sort=-999 THEN 4 WHEN @TransactionType=3 THEN 2 ELSE 0 END),
Sort=@Sort,
ItemStoreID=@ItemStoreID,
Cost=@Cost,
AVGCost=ISNULL(@AvgCost,@Cost),
UOMQty=@Qty,
UOMPrice=@Price,
UOMType=@PC,
Qty=(CASE WHEN @PC=0 THEN @Qty ELSE @Qty*@CaseQty END),
Total=@Price*ISNULL(@Qty,0),
DateModified=dbo.GetLocalDATE(), 
UserModified=@ModifierID
Where TransactionEntryID=@TransactionEntryID


Declare @Total Decimal
set @Total= @Price*ISNULL(@Qty,0)

Declare @TransactionEntryType Decimal
set @TransactionEntryType= (CASE WHEN @Sort=-999 THEN 4 WHEN @TransactionType=3 THEN 2 ELSE 0 END)

set @OldQty=((CASE WHEN @PC=0 THEN @Qty ELSE @Qty*@CaseQty END)-@OldQty)
exec UpdateToTransactionEntry @Total,@OldQty,@ItemStoreID,@TransactionEntryType,@ModifierID

exec UpdateDiscountOnTotal @TransactionID

END
ELSE

BEGIN

Declare @PcQty decimal(19,3)
Set @PcQty=(CASE WHEN @PC=0 THEN @Qty ELSE @Qty*@CaseQty END)

UPDATE ItemStore  --Chang OnWorkOrder
SET OnWorkOrder=IsNULL(OnWorkOrder,0) + @PcQty - (SELECT Qty 
												 FROM WorkOrderEntry 
												 WHERE WorkOrderEntryID = @TransactionEntryID),
	DateModified=dbo.GetLocalDATE(),
	UserModified=@ModifierID
WHERE ItemStoreID= @ItemStoreID


Update WorkOrderEntry
Set
WorkOrderID=@TransactionID,
Sort=@Sort,
ItemStoreID=@ItemStoreID,
UOMQty=@Qty,
Qty=(CASE WHEN @PC=0 THEN @Qty ELSE @Qty*@CaseQty END),
Price=(CASE WHEN @PC=0 THEN @Price WHEN @PC<>0 AND @CaseQty<>0 THEN @Price/@CaseQty END),
UOMType=@PC,
DateModified=dbo.GetLocalDATE(), 
UserModified=@ModifierID

Where WorkOrderEntryID=@TransactionEntryID


END
GO