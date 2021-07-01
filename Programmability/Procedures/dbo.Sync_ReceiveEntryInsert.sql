SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Sync_ReceiveEntryInsert]
(
@ReceiveEntryID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@ReceiveID uniqueidentifier,
@Qty decimal(19,3),
@PC int,
@Cost decimal(19,3),
@Sort int,
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
set @PcCost=(CASE WHEN @PC=2 And @CaseQty<>0 THEN @Cost/@CaseQty ELSE @Qty END)


if @ReceiveType=4
begin

		if (SELECT COUNT(*)
		FROM dbo.ReceiveEntry
		WHERE ReceiveEntryID=@ReceiveEntryID)>0 RETURN


		
		INSERT INTO  ReceiveEntry
		(ReceiveEntryID,
		ReceiveNo,
		ItemStoreNo,
		SortOrder,
		UOMQty,
		UOMType,
		Qty,
		Cost,
		ExtPrice,
		Taxable,
		Status,
		DateCreated,
		UserCreated,
		DateModified,
		UserModified)


		VALUES
		( 
		@ReceiveEntryID,
		@ReceiveID,
		@ItemStoreID,
		@Sort,
		@Qty,
		@PC, 
		@PcQty,
		@PcCost,
		@Qty*@Cost,
		0,
		1,
		dbo.GetLocalDATE(),
		@ModifierID,
		dbo.GetLocalDATE(),
		@ModifierID
		)
	

end
else if @ReceiveType = 5--return
begin

		if (SELECT COUNT(*)
		FROM dbo.ReturnToVenderEntry
		WHERE ReturnToVenderEntryID=@ReceiveEntryID)>0 RETURN

INSERT INTO dbo.ReturnToVenderEntry
		(
		ReturnToVenderEntryID,
		ReturnToVenderID,
		ItemStoreNo,
		UOMQty,
		UOMType,
		Qty,
		Cost,
		ExtPrice,
		SortOrder,
		Status,
		DateCreated,
		UserCreated,
		DateModified,
		UserModified)



		VALUES
		(@ReceiveEntryID,
		@ReceiveID,
		@ItemStoreID,
		Abs(@Qty), 
		@PC,
		@PcQty,
		@PcCost,
		@Qty*@Cost,
		@Sort,
		1,
		dbo.GetLocalDATE(),
		@ModifierID,
		dbo.GetLocalDATE(),
		@ModifierID
		)
                
exec UpdateToReturnToVenderEntryInsert @ItemStoreID ,@PcQty ,@ModifierID 
end

Exec Sync_UpdateItemSupply @ItemStoreID, @SupplierID, @ModifierID


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