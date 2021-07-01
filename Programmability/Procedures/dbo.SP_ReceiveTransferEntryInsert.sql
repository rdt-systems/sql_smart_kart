SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ReceiveTransferEntryInsert]
           (@ReceiveTranferEntryID uniqueidentifier,
           @ReceiveTransferID uniqueidentifier,
           @ItemStoreID uniqueidentifier,
           @TransferEntryID uniqueidentifier,
           @Qty decimal(18,0),
           @UOMQty decimal(18,0),
           @UOMType int,
		   @ModifierID uniqueidentifier,
           @Status int, @Cost Decimal = 0)

AS

IF (@Cost = 0) OR (@Cost is null)
begin
	select @Cost = cost from ItemStore where ItemStoreID =@ItemStoreID
end

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

Declare @vStatus int

IF (SELECT (ReceiveQty + @Qty) - Qty FROM  TransferEntryView WHERE (Status > 0) And (TransferEntryID=@TransferEntryID))<=0
  set @vStatus = @Status 
ELSE
  set @vStatus = -2

	INSERT INTO [dbo].[ReceiveTransferEntry]
			   ([ReceiveTranferEntryID]
			   ,[ReceiveTransferID]
			   ,[ItemStoreID]
			   ,[TransferEntryID]
			   ,[Qty]
			   ,[UOMQty]
			   ,[UOMType]
			   ,[DateCreate]
			   ,[DateModified]
			   ,[UserCreate]
			   ,[UserModified]
			   ,[Status], [Cost])
		 VALUES
			   (@ReceiveTranferEntryID, 
			   @ReceiveTransferID,
			   @ItemStoreID, 
			   @TransferEntryID, 
			   @Qty, 
			   @UOMQty,
			   @UOMType, 
			   @UpdateTime,
			   @UpdateTime, 
			   @ModifierID, 
			   @ModifierID, 
			   @vStatus, @Cost)
    if @vStatus >0
	--   update ItemStore set OnHand = OnHand + @Qty,OnTransferOrder=OnTransferOrder-@Qty ,DateModified =dbo.GetLocalDATE(),UserModified =@ModifierID  where ItemStoreID =@ItemStoreID 

	IF(@TransferEntryID IS NOT NULL) AND (Select COUNT(*)
	    From
			TransferEntry Inner Join
			RequestTransferEntry On TransferEntry.RequestTransferEntryID = RequestTransferEntry.RequestTransferEntryID
			Inner Join
			TransactionEntry On RequestTransferEntry.TransactionEntryID = TransactionEntry.TransactionEntryID Inner Join
			[Transaction] On TransactionEntry.TransactionID = [Transaction].TransactionID
		Where
			TransactionEntry.Status > 0 And
			[Transaction].Status > 0
			AND TransferEntry.TransferEntryID=@TransferEntryID)>0
    BEGIN
	  UPDATE ItemStore Set OnTransferOrder=(Isnull(OnTransferOrder,0)-@Qty),Reserved=(IsNull(Reserved,0)+@Qty) WHERE ItemStoreID=@ItemStoreID 
	END
	ELSE BEGIN
		Exec SP_UpdateOnHandOneItem @ItemStoreID
		Exec SP_OnTransferUpdateOneItem @ItemStoreID
	END
GO