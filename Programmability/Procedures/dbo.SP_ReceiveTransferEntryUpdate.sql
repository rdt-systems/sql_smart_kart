SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_ReceiveTransferEntryUpdate]
           (@ReceiveTranferEntryID uniqueidentifier,
           @ReceiveTransferID uniqueidentifier,
           @ItemStoreID uniqueidentifier,
           @TransferEntryID uniqueidentifier,
           @Qty decimal(18,0),
           @UOMQty decimal(18,0),
           @UOMType int =0,
		   @ModifierID uniqueidentifier=NULL,
           @Status int, @Cost decimal = 0)

AS

IF (@Cost = 0) OR (@Cost is null)
begin
	select @Cost = cost from ItemStore where ItemStoreID =@ItemStoreID
end

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @OldQty decimal(18,0) 
set @OldQty= (Select Top(1) Qty FROM ReceiveTransferEntry where [ReceiveTranferEntryID] = @ReceiveTranferEntryID)

UPDATE [dbo].[ReceiveTransferEntry]
   SET [ReceiveTransferID] = @ReceiveTransferID
      ,[ItemStoreID] = @ItemStoreID
      ,[TransferEntryID] = @TransferEntryID
      ,[Qty] = @Qty
      ,[UOMQty] = @UOMQty
      ,[UOMType] = @UOMType
      ,[DateModified] = @UpdateTime
      ,[UserModified] = @ModifierID
      ,[Status] = @Status, [Cost] = @Cost 
 WHERE[ReceiveTranferEntryID] = @ReceiveTranferEntryID


 IF (SELECT        ISNULL(ItemMain.ItemType, 0) AS ItemType
FROM            ItemStore INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
WHERE        (ItemStore.ItemStoreID = @ItemStoreID)) NOT IN (3,5,7,9)
 update ItemStore set OnHand = OnHand + @Qty-@OldQty ,DateModified =dbo.GetLocalDATE(),UserModified =@ModifierID  where ItemStoreID =@ItemStoreID 


Exec SP_OnTransferUpdateOneItem @ItemStoreID
GO