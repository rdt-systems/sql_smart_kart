SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_RequestTransferEntryInsert]
(
@RequestTransferEntryID uniqueidentifier,
@RequestTransferID uniqueidentifier,
@ItemStoreID uniqueidentifier,
@Qty decimal,
@UOMQty decimal,
@UOMType int,
@Note nvarchar(4000),
@Cost decimal,
@SortOrder int,
@CustomerId uniqueidentifier = null,
@Status int,
@ModifierID uniqueidentifier=null,
@ItemID uniqueidentifier=null,
@DateCreated datetime=null,
@DateModified datetime =null,
@UserCreated UniqueIdentifier = NULL,
@UserModified UniqueIdentifier = NULL,
@TransactionEntryID UniqueIdentifier = NULL,
@FromStoreID UniqueIdentifier = NULL


)
AS
-- Check if itemID is null
Declare @MyItemID uniqueidentifier
if @ItemID is null
  SET @MyItemID =(Select top(1)ItemNo from ItemStore where ItemStoreID =@ItemStoreID)
else
  Set @MyItemID = @ItemID 

Declare @MyItemStoreID uniqueidentifier
if @FromStoreID is null
  SET @MyItemStoreID =@ItemStoreID 
ELSE 
  SET @MyItemStoreID= (SELECT ItemStoreID FROM ItemStore WHERE ItemNo =@MyItemID and StoreNo =@FromStoreID)


INSERT INTO dbo.RequestTransferEntry
                      (RequestTransferEntryID, RequestTransferID, ItemStoreID, Qty, UOMQty, UOMType,Note, DateCreated, DateModified, UserCreated, UserModified,SortOrder,Status, Cost,CustomerId,ItemID,TransactionEntryID)
VALUES                (@RequestTransferEntryID,@RequestTransferID,@MyItemStoreID,@Qty,@UOMQty,@UOMType,@Note,dbo.GetLocalDATE(),dbo.GetLocalDATE(),@ModifierID,@ModifierID,@SortOrder,1,@Cost,@CustomerId,@MyItemID,@TransactionEntryID)


UPDATE ItemStore Set Reserved =(IsNull(Reserved,0) +@Qty),OnHand =(IsNull(OnHand,0)-@Qty),DateModified=dbo.GetLocalDate() WHERE ItemStoreID =@MyItemStoreID

UPDATE ItemStore Set OnRequest =(IsNull(OnRequest,0) +@Qty),DateModified=dbo.GetLocalDate() WHERE ItemStoreID =@ItemStoreID



UPDATE ItemStore Set DateModified = dbo.GetLocalDate()  WHERE ItemNo  =@MyItemID
GO