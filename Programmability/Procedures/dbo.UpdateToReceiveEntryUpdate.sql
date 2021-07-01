SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateToReceiveEntryUpdate]
(@ReceiveNo uniqueidentifier,
 @Cost Decimal(19,3),
 @OldCost Decimal(19,3),
 @OldDiscount Decimal(19,3),
 @ItemStoreNo uniqueidentifier,
 @OldItem uniqueidentifier,
 @OldQty Decimal(19,3),
 @Qty Decimal(19,3),
 @CurrOnHand Decimal(19,3),
 @CurrAvgCost Decimal(19,3),
@Status  smallint, 
@ModifierID uniqueidentifier)
as

Declare @DisountPercents  Money
set @DisountPercents=(Select Discount from ReceiveOrder where ReceiveID=@ReceiveNo)

Declare @OldDisountPercents  Money

if @DisountPercents is null
	set @DisountPercents=0
else
        set @DisountPercents=@DisountPercents*@Cost/100

if @OldDiscount is null
	set @OldDisountPercents=0
else
        set @OldDisountPercents=@OldDiscount*@Cost/100

-------------------

if @@ROWCOUNT=0 return 

DECLARE @OldItemOnOrder Decimal
SET @OldItemOnOrder= (select SUM(OrderDeficit) from PurchaseOrderEntryView where (ItemNo=@OldItem) and (Status>-1))

Declare @QtyForOnHand Decimal(19,3) ,@Stock Decimal(19,3), @InventoryValuation money 

if @ItemStoreNo=@OldItem 
	begin
	    set @QtyForOnHand=-@OldQty + @Qty
		if @CurrOnHand<0
			begin 
				set @CurrOnHand=0
				set @InventoryValuation=0
			end
        else
			set @InventoryValuation=(ISNULL(@CurrAvgCost,0)*@CurrOnHand)-(@OldQty*@OldCost)+(@OldQty*@OldDisountPercents)
		if isnull(@CurrOnHand-@OldQty,0)+@Qty=0
			Set @Stock=@Qty
		else
			set @Stock= isnull(@CurrOnHand,0)-@OldQty+@Qty
	end
else 
	Begin
	        set @QtyForOnHand=@Qty 
			if @CurrOnHand<0
				begin 
					set @CurrOnHand=0
					set @InventoryValuation=0
				end
			else
				set @InventoryValuation=ISNULL(@CurrAvgCost,0)*ISNULL(@CurrOnHand,0)
			if isnull(@CurrOnHand,0)+@Qty=0
				Set @Stock=@Qty
			else
				set @Stock= isnull(@CurrOnHand,0)+@Qty
	end

if @Status=0
begin
	if @ItemStoreNo=@OldItem
	set @QtyForOnHand=-@OldQty 
	else
	set @QtyForOnHand=0
end

if @Status<>0
begin
	exec UpdateOnOrderByOrder @ItemStoreNo,@ModifierID

	UPDATE dbo.ItemStore
    SET    OnHand = (ISNULL(OnHand,0) + @QtyForOnHand), 
		   AvgCost=(@InventoryValuation +(@Qty*@Cost)-(@Qty*@DisountPercents))/@Stock,
		   DateModified = dbo.GetLocalDATE(), 
		   UserModified = @ModifierID
   	WHERE ItemStoreID = @ItemStoreNo

	EXEC UpdateParent @ItemStoreNo,@ModifierID,1,1,0
end

if @ItemStoreNo<>@OldItem Or @Status=0
begin
	exec UpdateOnOrderByOrder @OldItem,@ModifierID

	declare @OldOnHand as decimal
	set @OldOnHand=(select OnHand from dbo.ItemStore where ItemStoreID = @OldItem)
	declare @OldAvgCost as money
	set @OldAvgCost=(select AvgCost from dbo.ItemStore where ItemStoreID = @OldItem)

	UPDATE dbo.ItemStore
	SET OnHand =(isnull(OnHand,0) - @OldQty), 
		OnOrder= ISNULL(@OldItemOnOrder,0), 
        AvgCost=((ISNULL(@OldAvgCost,0)*@OldOnHand)-(@OldQty*@OldCost)+(@OldQty*@OldDisountPercents))/Case when (@OldOnHand-@OldQty)=0 then 1 else (@OldOnHand-@OldQty) end,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemStoreID= @OldItem

	EXEC UpdateParent @OldItem,@ModifierID,1,1,0

end


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