SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE procedure [dbo].[UpdateMultiParent]
(@ItemID  uniqueidentifier,
@ModifierID Uniqueidentifier,
@FromStoreID Uniqueidentifier,
@ToStoreID Uniqueidentifier,

@TransferOrder bit,
@Transfer bit, 

@Qty decimal(19,3))

as

Declare @LinkNoFrom Uniqueidentifier
Set @LinkNoFrom=(Select ItemStoreID 
				 FROM ItemMain inner Join 
				 ItemStore On ItemNo=ItemID and StoreNo = @FromStoreID
				 Where  ItemID=(Select LinkNo
								From ItemMain 
								where ItemID=@ItemID))

Declare @LinkNoTo Uniqueidentifier
Set @LinkNoTo=(Select ItemStoreID 
				 FROM ItemMain inner Join 
                      ItemStore On ItemNo=ItemID and StoreNo = @ToStoreID
                 Where  ItemID=(Select LinkNo
								From ItemMain 
								where ItemID=@ItemID))



if @Transfer=1
	BEGIN 

			UPDATE dbo.ItemStore
			SET OnHand = isnull(OnHand,0) - @Qty , 
				DateModified = dbo.GetLocalDATE(), 
				UserModified = @ModifierID
			WHERE ItemStoreID = @LinkNoFrom

            UPDATE dbo.ItemStore
			SET OnHand = isnull(OnHand,0) + @Qty , 
				DateModified = dbo.GetLocalDATE(), 
				UserModified = @ModifierID
			WHERE ItemStoreID = @LinkNoTo

	END 

ELSE

if @TransferOrder=1
    BEGIN 

			UPDATE dbo.ItemStore
			SET OnTransferOrder = isnull(OnTransferOrder,0) + @Qty , 
				DateModified = dbo.GetLocalDATE(), 
				UserModified = @ModifierID
			WHERE ItemStoreID = @LinkNoFrom

            UPDATE dbo.ItemStore
			SET OnOrder = isnull(OnOrder,0) +  @Qty , 
				DateModified = dbo.GetLocalDATE(), 
				UserModified = @ModifierID
			WHERE ItemStoreID = @LinkNoTo

	END
GO