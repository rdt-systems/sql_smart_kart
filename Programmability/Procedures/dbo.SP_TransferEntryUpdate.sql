SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferEntryUpdate]

(@TransferEntryID uniqueidentifier,
@TransferID uniqueidentifier,
@ItemStoreNo uniqueidentifier ,
@FromStoreID uniqueidentifier = null,
@ToStoreID uniqueidentifier= null,
@ItemID uniqueidentifier = null,
@UOMPrice Money, 
@Qty decimal,
@UOMQty decimal,
@UOMType int,
@LinkNo uniqueidentifier,
@Note nvarchar(4000), 
@SortOrder int,
@Status  smallint, 
@DateModified Datetime,
@ModifierID uniqueidentifier,
@Cost decimal = 0,
@RequestTransferEntryID  uniqueidentifier = NULL)

AS

IF (@Cost = 0) OR (@Cost is null)
begin
	select @Cost = cost from ItemStore where ItemStoreID =@ItemStoreNo
end

Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()
declare @OldQty decimal
set @OldQty = (select Qty from TransferEntry where (TransferEntryID = @TransferEntryID))

UPDATE  dbo.TransferEntry              
SET    	TransferID = @TransferID, 
		ItemStoreNo =@ItemStoreNo,  
		UOMPrice = @UOMPrice, 
		Qty = @Qty,  
		UOMQty = @UOMQty, 
		UOMType= @UOMType, 
		Note = @Note, 
		SortOrder=@SortOrder,
		Status = @Status,  
		DateModified = @UpdateTime,        
		UserModified = @ModifierID,
		Cost = @Cost,
		RequestTransferEntryID=@RequestTransferEntryID
WHERE  (TransferEntryID = @TransferEntryID) --and
--     (  (DateModified = @DateModified) OR (DateModified is NULL)  Or
--         (@DateModified is null)
--      )

IF @ItemID is not null and @ToStoreID is not null
BEGIN
  update ItemStore set OnTransferOrder  =IsNull(OnTransferOrder,0)+(@Qty-@OldQty),DateModified =dbo.GetLocalDATE() where ItemNo  =@ItemID and StoreNo =@ToStoreID 
  print 'update ItemStore set OnTransferOrder  =IsNull(OnTransferOrder,0)+'+CONVERT(char(10),(@Qty-@OldQty))+
         ' WHERE  ItemNo ='''+CONVERT(char(40),@ItemID)+''' AND StoreNo='+ CONVERT(char(40),@ToStoreID)+CONVERT(char(10),@OldQty) +':' +CONVERT(char(10),@Qty)
END

IF @ItemID is not null and @FromStoreID is not null
BEGIN
 update ItemStore set OnTransferOrder  =IsNull(OnTransferOrder,0)+(@Qty-@OldQty), OnHand=IsNull(OnHand,0)-(@Qty+@OldQty) ,DateModified =dbo.GetLocalDATE() where ItemNo  =@ItemID and StoreNo =@FromStoreID  
END

--update ItemStore set OnTransferOrder  =IsNull(OnTransferOrder,0)+(@Qty-@OldQty),OnHand=IsNull(OnHand,0)-(@Qty-@OldQty) ,DateModified =dbo.GetLocalDATE() where ItemStoreID  =@ItemStoreNo

Exec SP_UpdateOnHandOneItem @ItemStoreID = @ItemStoreNo
Exec SP_OnTransferUpdateOneItem @ItemStoreNo
select @UpdateTime as DateModified

--UPDATE       ItemStore
--SET                OnTransferOrder = SumTransfer.Qty
--FROM            ItemStore INNER JOIN
--                             (SELECT        ItemID, SUM(Qty-ReceiveQty) AS Qty, ToStoreID
--                               FROM            TransferEntryView
--                               GROUP BY ItemID, ToStoreID) AS SumTransfer ON ItemStore.StoreNo = SumTransfer.ToStoreID AND ItemStore.ItemNo = SumTransfer.ItemID
GO