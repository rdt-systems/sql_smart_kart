SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TransferOrderEntryInsert]

(@TransferOrderEntryID uniqueidentifier,
@TransferOrderID uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@UOMPrice Money, 
@Qty decimal,
@UOMQty decimal,
@UOMType int,
@LinkNo uniqueidentifier,
@Note nvarchar(4000), 
@SortOrder int,
@Status  smallint, 
@ModifierID uniqueidentifier)

AS

INSERT INTO dbo.TransferOrderEntry
           (TransferOrderEntryID, TransferOrderID, ItemStoreNo,   Qty,UOMPrice, UOMQty,UOMType, LinkNo,    Note,
	SortOrder, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@TransferOrderEntryID, @TransferOrderID, @ItemStoreNo,  @Qty,@UOMPrice, @UOMQty,@UOMType,@LinkNo,  @Note,
	@SortOrder, 1, dbo.GetLocalDATE(), @ModifierID,dbo.GetLocalDATE(), @ModifierID)
GO