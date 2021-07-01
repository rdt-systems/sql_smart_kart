SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateToReceiveEntryInsert]
(@ReceiveNo uniqueidentifier,
 @ItemStoreNo uniqueidentifier,
 @Qty decimal(19,3),
 @Cost decimal(19,3),
 @ModifierID uniqueidentifier)
as

DECLARE @Stock Decimal

------------------
Declare @DisountPercents  Money
set @DisountPercents=(Select Discount from ReceiveOrder where Status>0 and ReceiveID=@ReceiveNo)

if @DisountPercents is null
	set @DisountPercents=0
else
        set @DisountPercents=@DisountPercents*@Cost/100
-------------------

declare @CurrOnHand as decimal
set @CurrOnHand=(select OnHand from dbo.ItemStore where ItemStoreID = @ItemStoreNo)

declare @CurrAvgCost as decimal
set @CurrAvgCost=(select AvgCost from dbo.ItemStore where ItemStoreID = @ItemStoreNo)

exec UpdateOnOrderByOrder @ItemStoreNo,@ModifierID

if @CurrOnHand<0 set @CurrOnHand=0

if isnull(@CurrOnHand,0)+@Qty=0
set @Stock=@Qty
else
set @Stock=isnull(@CurrOnHand,0)+@Qty
 
	UPDATE dbo.ItemStore
	SET OnHand = isnull(OnHand,0) + @Qty , 
		AvgCost=((isnull(@CurrOnHand,0)*isnull(AvgCost,0))+(@Qty*@Cost)-(@Qty*@DisountPercents))/@Stock,
		DateModified = dbo.GetLocalDATE(), 
		UserModified = @ModifierID
	WHERE ItemStoreID = @ItemStoreNo
	
	EXEC UpdateParent @ItemStoreNo,@ModifierID,1,1,0

-- Update LastReceivedDate
UPDATE       ItemStore
SET                LastReceivedDate =
                             (SELECT        TOP (1) ReceiveOrder.ReceiveOrderDate
                               FROM            ReceiveEntry INNER JOIN
                                                         ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID
                               WHERE        (ReceiveEntry.ItemStoreNo = ItemStore.ItemStoreID) AND (ReceiveEntry.Status > 0) AND (ReceiveOrder.Status > 0)
                               ORDER BY ReceiveOrder.ReceiveOrderDate DESC)

-- Update LastReceivedQty
UPDATE       ItemStore
SET                LastReceivedQty = ISNULL(
                             (SELECT        TOP (1) ReceiveEntry.UOMQty
                               FROM            ReceiveEntry INNER JOIN
                                                         ReceiveOrder ON ReceiveEntry.ReceiveNo = ReceiveOrder.ReceiveID
                               WHERE        (ReceiveEntry.ItemStoreNo = ItemStore.ItemStoreID) AND (ReceiveEntry.Status > 0) AND (ReceiveOrder.Status > 0)
                               ORDER BY ReceiveOrder.ReceiveOrderDate DESC),0)
GO