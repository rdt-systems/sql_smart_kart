SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Sync_TransactionEntryInsert]
(
@TransactionEntryID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@TransactionID uniqueidentifier,
@Qty decimal(19,3),
@PC int,
@Price decimal(19,3),
@Sort Decimal(19,3),
@ModifierID uniqueidentifier)

as
if ((select Count(*) from [transactionEntry] where TransactionEntryID=@TransactionEntryID and Status>-1)> 0) 
begin
	 RAISERROR  ('Transaction ID Alredy Exists.',20,1) -- WITH LOG
end

Declare @TransactionType int
Declare @tQty decimal(19,3)
set @TransactionType=(SELECT TransactionType
					  From [Transaction]
					  Where TransactionID=@TransactionID)

Declare @Cost Decimal(19,3)
set @Cost=(SELECT [Pc Cost]
		   From ItemMainAndStoreView
		   Where ItemStoreID=@ItemStoreID)

Declare @AVGCost Decimal(19,3)
set @AVGCost=@Cost
--set @AVGCost=(SELECT AVGCost
--			  From ItemStore
--		      Where ItemStoreID=@ItemStoreID)

--IF @AVGCost=0 Set @AVGCost=@Cost

Declare @CaseQty Decimal
set @CaseQty=(SELECT CaseQty
			  From ItemMainAndStoreView
		      Where ItemStoreID=@ItemStoreID)

IF @TransactionType is not null
BEGIN

if (SELECT COUNT(*)
	FROM dbo.TransactionEntry
	WHERE TransactionEntryID=@TransactionEntryID)>0 RETURN

INSERT INTO TransactionEntry
(TransactionEntryID,
 TransactionID,
 TransactionEntryType,
 Sort,
 ItemStoreID,
 Cost,
 AVGCost,
 UOMQty,
 UOMPrice,
 UOMType,
 Qty,
 Total,
 Status,
 DateCreated, 
 UserCreated, 
 DateModified, 
 UserModified)

VALUES

(@TransactionEntryID,
 @TransactionID,
 (CASE WHEN @Sort=-999 THEN 4 WHEN @TransactionType=3 THEN 2 ELSE 0 END),
 @Sort,
 @ItemStoreID,
 @Cost,
 ISNULL(@AvgCost,@Cost),
 @Qty,
 @Price,
 @PC,
(CASE WHEN @PC=0 THEN @Qty ELSE @Qty*@CaseQty END),
 @Price*ISNULL(@Qty,0),
 1, 
 dbo.GetLocalDATE(), 
 @ModifierID,  
 dbo.GetLocalDATE(), 
 @ModifierID)

Declare @Total Decimal
set @Total= @Price*ISNULL(@Qty,0)

Declare @TransactionEntryType Decimal
set @TransactionEntryType= (CASE WHEN @Sort=-999 THEN 4 WHEN @TransactionType=3 THEN 2 ELSE 0 END)

Set @tQty =(CASE WHEN @PC=0 THEN @Qty ELSE @Qty*@CaseQty END)
exec UpdateToTransactionEntry  @Total,@tQty,@ItemStoreID,@TransactionEntryType,@ModifierID

exec UpdateDiscountOnTotal @TransactionID

exec [Sync_ApplySaleOrderEntry] @TransactionEntryID,@ModifierID


END

ELSE --SaleOrderEntry
BEGIN

if (SELECT COUNT(*)
	FROM dbo.WorkOrderEntry
	WHERE WorkOrderEntryID=@TransactionEntryID)>0 RETURN


Declare @PcQty decimal(19,3)
Set @PcQty=(CASE WHEN @PC=0 THEN @Qty ELSE @Qty*@CaseQty END)

INSERT INTO WorkOrderEntry
(WorkOrderEntryID,
 WorkOrderID,
 Sort,
 ItemStoreID,
 UOMQty,
 Qty,
 Price,
 UOMType,
 Status,
 DateCreated, 
 UserCreated, 
 DateModified, 
 UserModified)

VALUES

(@TransactionEntryID,
 @TransactionID,
 @Sort,
 @ItemStoreID,
 @Qty,
 @PcQty,
 (CASE WHEN @PC=0 THEN @Price WHEN @PC<>0 AND @CaseQty<>0 THEN @Price/@CaseQty END),
 @PC,
 1, 
 dbo.GetLocalDATE(), 
 @ModifierID,  
 dbo.GetLocalDATE(), 
 @ModifierID)

UPDATE ItemStore
SET OnWorkOrder=IsNULL(OnWorkOrder,0)+@PcQty,
	DateModified=dbo.GetLocalDATE(), 
	UserModified=@ModifierID
WHERE ItemStoreID=@ItemStoreID

END


if @TransactionEntryType <> 2
Begin
UPDATE       ItemStore
SET                LastSoldDate =
                             (SELECT dbo.getday(StartSaleTime) From [Transaction] Where TransactionID = @TransactionID)
							   Where ItemStoreID = @ItemStoreID
End
GO