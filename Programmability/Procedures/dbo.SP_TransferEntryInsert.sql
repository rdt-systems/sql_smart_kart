SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_TransferEntryInsert]

(@TransferEntryID uniqueidentifier,
@TransferID uniqueidentifier,
@ItemID uniqueidentifier = null,
@FromStoreID uniqueidentifier= null,
@ToStoreID uniqueidentifier= null,
@ItemStoreNo uniqueidentifier,
@UOMPrice Money, 
@Qty decimal,
@UOMQty decimal,
@UOMType int,
@LinkNo uniqueidentifier,
@Note nvarchar(4000), 
@SortOrder int,
@RequestTransferEntryID uniqueidentifier = NULL, 
@Status  smallint, 
@ModifierID uniqueidentifier,
@Cost decimal = 0
)

AS

IF (@Cost = 0) OR (@Cost is null)
begin
  if @UOMType =0
	select @Cost = [Pc Cost] from dbo.ItemMainAndStoreList WITH (NOLOCK)   where ItemStoreID =@ItemStoreNo
  else 
    select @Cost = [Cs Cost] from dbo.ItemMainAndStoreList WITH (NOLOCK)  where ItemStoreID =@ItemStoreNo
end

INSERT INTO dbo.TransferEntry
           (TransferEntryID, TransferID, ItemStoreNo,   Qty,UOMPrice, UOMQty,UOMType, LinkNo,    Note,
	SortOrder, Status, DateCreated, UserCreated, DateModified, UserModified,Cost,RequestTransferEntryID)
VALUES     (@TransferEntryID, @TransferID, @ItemStoreNo,  @Qty,@UOMPrice, @UOMQty,@UOMType,@LinkNo,  @Note,
	@SortOrder, 1, dbo.GetLocalDATE(), @ModifierID,dbo.GetLocalDATE(), @ModifierID,@Cost,@RequestTransferEntryID)


--update ItemStore set OnHand =IsNull(OnHand,0) -@Qty,DateModified =dbo.GetLocalDATE() where ItemStoreID =@ItemStoreNo

IF @ItemID is not null and @ToStoreID is not null
BEGIN
  update ItemStore set OnTransferOrder  =IsNull(OnTransferOrder,0)+@Qty,DateModified =dbo.GetLocalDATE() where ItemNo  =@ItemID and StoreNo =@ToStoreID
END

IF @RequestTransferEntryID is null
BEGIN
  UPDATE ItemStore Set OnHand = ISNULL(OnHand,0)-@Qty,DateModified =dbo.GetLocalDATE() WHERE ItemNo  =@ItemID and StoreNo =@FromStoreID
END
ELSE 
BEGIN
  UPDATE ItemStore Set Reserved = ISNULL(Reserved,0)-@Qty,DateModified =dbo.GetLocalDATE() WHERE ItemNo  =@ItemID and StoreNo =@FromStoreID
  UPDATE ItemStore Set OnRequest = OnRequest-@Qty,DateModified =dbo.GetLocalDATE() WHERE ItemNo  =@ItemID and StoreNo =@ToStoreID
END


UPDATE ItemStore Set DateModified = dbo.GetLocalDate()  WHERE ItemNo  =@ItemID

--Exec SP_UpdateOnHandOneItem @ItemStoreID = @ItemStoreNo

--IF @ItemID is not null and @FromStoreID is not null
--BEGIN
-- update ItemStore set OnHand=IsNull(OnHand,0)-@Qty ,OnTransferOrder=(OnTransferOrder+@Qty),  DateModified =dbo.GetLocalDATE() where ItemNo  =@ItemID and StoreNo =@FromStoreID
--END

--UPDATE ItemStore
--SET                OnTransferOrder = SumTransfer.Qty
--FROM            ItemStore INNER JOIN
--                             (SELECT        ItemID, SUM(Qty-ReceiveQty) AS Qty, ToStoreID
--                               FROM            TransferEntryView
--                               GROUP BY ItemID, ToStoreID) AS SumTransfer ON ItemStore.StoreNo = SumTransfer.ToStoreID AND ItemStore.ItemNo = SumTransfer.ItemID
GO