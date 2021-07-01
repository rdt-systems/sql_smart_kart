SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_RequestTransferEntryUpdate]
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
@DateModified datetime=null, 
@ModifierID uniqueidentifier=null,
@ItemID uniqueidentifier=null,
@TransactionEntryID UniqueIdentifier = NULL,
@FromStoreID UniqueIdentifier = NULL
)

AS

UPDATE  dbo.RequestTransferEntry              
SET    RequestTransferID = @RequestTransferID,
		 ItemStoreID = @ItemStoreID,
		 Qty = @Qty,
		 UOMQty = @UOMQty,
		 UOMType = @UOMType,
		 Note = @Note,
		 DateModified = dbo.GetLocalDATE(),
		 UserModified = @ModifierID,
		SortOrder = @SortOrder,
		Status = @Status,
		 Cost = @Cost,
		CustomerId = @CustomerId,
		ItemID = @ItemID,
		TransactionEntryID = @TransactionEntryID

WHERE  (RequestTransferEntryID = @RequestTransferEntryID)
GO