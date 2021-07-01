SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Nathan Ehrenthal>
-- Create date: <12/19/2012>
-- Description:	<Adjust inventory for a specific date>
-- =============================================
CREATE PROCEDURE [dbo].[AdjustInventorySpecialDate]
		@ItemStoreID uniqueidentifier,
		@NewQty float,
		@UpToDate datetime
AS
BEGIN
  DECLARE @TotalQty float
  SELECT       @TotalQty =
	isnull(
	(select sum(qty)
	from ReceiveEntry 
	inner join ReceiveOrderview on ReceiveEntry.ReceiveNo=ReceiveOrderview.ReceiveID
	where ItemStoreNo=@ItemStoreID and ReceiveEntry.Status>0 and ReceiveOrderview.ReceiveOrderDate<@UpToDate and ReceiveOrderview.Status>0) 
	,0)
	-
	isnull(
	(select sum(qty)
	from TransactionEntry 
	inner join [Transaction] on TransactionEntry.TransactionID=[Transaction].TransactionID
	where ItemStoreID=@ItemStoreID and TransactionEntry.Status>0 and [Transaction].StartSaleTime<@UpToDate and [Transaction].Status>0) 
	,0)
	+
	isnull(
	(select sum(Qty)
	from AdjustInventory
	where ItemStoreNo=@ItemStoreID AND DateCreated<@UpToDate)
	,0)
	-
	isnull(
	(select sum(isnull(Qty,0))
	from ReturntovenderEntry
	inner join ReturnToVender on ReturntovenderEntry.ReturnToVenderID=ReturnToVender.ReturnToVenderID
	where ItemStoreNo=@ItemStoreID and ReturntovenderEntry.Status>0 and ReturnToVender.ReturnToVenderDate<@UpToDate and ReturnToVender.Status>0) 
	,0)
	+
	isnull(
	(select sum(isnull(Qty,0))
	 from TransferEntry inner join
		  TransferItems on TransferItems.TransferID=TransferEntry.TransferID
	where (SELECT ItemStoreID
		   FROM ItemMainAndStoreView
		   WHERE  ItemID = TransferEntry.ItemStoreNo And StoreNo= (SELECT ToStoreID 
																  FROM   TransferItems
																  WHERE  TransferID=TransferEntry.TransferID)) = @ItemStoreID and TransferEntry.Status>0 and TransferItems.TransferDate < @UpToDate and TransferItems.Status>0) 
	,0)
	-
	isnull(
	(select sum(isnull(Qty,0))
	 from TransferEntry inner join
		  TransferItems on TransferItems.TransferID=TransferEntry.TransferID
	 where (SELECT ItemStoreID
			FROM ItemMainAndStoreView
			WHERE TransferEntry.ItemStoreNo = ItemID And StoreNo= (SELECT FromStoreID 
																   FROM   TransferItems
																   WHERE  TransferID=TransferEntry.TransferID)) = @ItemStoreID and TransferEntry.Status>0 and TransferItems.TransferDate < @UpToDate and TransferItems.Status>0) 
	,0) 
	
declare @ID uniqueidentifier
declare @TempQty float
SET @ID =NEWID()
SET @TempQty = (@NewQty-@TotalQty)

	if @ItemStoreID is not null 
	BEGIN
		EXEC	 [dbo].[SP_AdjustInventoryInsert]
				@AdjustInventoryId =@ID ,
				@ItemStoreNo = @ItemStoreID,
				@Qty = @TempQty ,
				@OldQty = @TotalQty,
				@AdjustType = 5,
				@AdjustReason = Null,
				@AccountNo = Null,
				@Cost = 0,
				@Status = 1,
				@ModifierID = null,
				@AdjustDate=@UpToDate
	END
select @ItemStoreID 
END
GO