SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Sync_ReceiveEntryUpdate]
(
@ReceiveEntryID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@ReceiveID uniqueidentifier,
@Qty decimal(19,3),
@PC int,
@Cost decimal(19,3),
@Sort int,
@DateModified datetime=null,
@ModifierID uniqueidentifier)


as
Declare @CaseQty Decimal
set @CaseQty=(SELECT CaseQty
			  From ItemMainAndStoreView
		      Where ItemStoreID=@ItemStoreID)

Declare @SupplierID uniqueidentifier
declare @ReceiveType int

if (Select SupplierNo
	From ReceiveOrder
	where ReceiveID=@ReceiveID)is not null
	begin
	set @ReceiveType=4
	set @SupplierID=(Select SupplierNo
					 From ReceiveOrder
					 where ReceiveID=@ReceiveID)
    end

if (Select SupplierID
	From ReturnToVender
	where ReturnToVenderID=@ReceiveID)is not null
	begin
	set @ReceiveType=5
	Set @SupplierID=(Select SupplierID
					From ReturnToVender
					where ReturnToVenderID=@ReceiveID)
	end

	Declare @PcQty decimal(19,3)
	set @PcQty=(CASE WHEN @PC=2 THEN @Qty*@CaseQty ELSE @Qty END)

	Declare @PcCost decimal(19,3)
	set @PcCost=(CASE WHEN @PC=2 And @CaseQty<>0 THEN @Cost/@CaseQty ELSE @Cost END)

    DECLARE @OldQty decimal(19,3)
	SET @OldQty = (SELECT Qty FROM dbo.ReceiveEntry WHERE  ReceiveEntryID = @ReceiveEntryID)



if @ReceiveType=4
	BEGIN 

    	UPDATE ReceiveEntry
		SET
			ReceiveNo = @ReceiveID,
			ItemStoreNo = @ItemStoreID,
			SortOrder = @Sort,
			UOMQty = @Qty,
			UOMType = @PC,
			Qty = @PcQty,
			Cost = @PcCost,
			ExtPrice=@Qty*@Cost,
			DateModified = dbo.GetLocalDATE(),
			UserModified = @ModifierID
		WHERE
			ReceiveEntryID = @ReceiveEntryID

	END

else

if @ReceiveType = 5--return

UPDATE dbo.ReturnToVenderEntry
SET
	ReturnToVenderID = @ReceiveID,
	ItemStoreNo = @ItemStoreID,
	UOMQty = Abs(@Qty),
	UOMType = @PC,
	Qty = @PcQty,
	Cost = @PcCost,
	ExtPrice = @Qty*@Cost,
	SortOrder = @Sort,
	DateModified = dbo.GetLocalDATE(),
	UserModified = @ModifierID
WHERE ReturnToVenderEntryID = @ReceiveEntryID

Exec UpdateToReturnToVenderEntryUpdate @ItemStoreID, @ItemStoreID ,@OldQty ,@PcQty ,1 , @ModifierID 

Exec Sync_UpdateItemSupply @ItemStoreID, @SupplierID, @ModifierID
GO