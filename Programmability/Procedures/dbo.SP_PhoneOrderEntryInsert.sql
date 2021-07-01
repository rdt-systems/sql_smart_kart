SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_PhoneOrderEntryInsert]

(
@PhoneOrderEntryID uniqueidentifier,
@PhoneOrderID uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@UOMPrice Money, 
@Qty decimal (19,3),
@ExtPrice Money, 
@UOMQty decimal,
@UOMType int,
@LinkNo uniqueidentifier,
@Note nvarchar(4000), 
@SortOrder int,
@OnHand decimal(19, 3) = null,
@Status  smallint, 
@ModifierID uniqueidentifier,
@Name nvarchar (50),
@BarCode nvarchar( 50),
@ModalNo nvarchar (50)
)

AS

INSERT INTO dbo.PhoneOrderEntry
           (PhoneOrderEntryID, PhoneOrderID, ItemStoreNo,   Qty,UOMPrice,ExtPrice, UOMQty,UOMType, LinkNo,    Note,
	SortOrder ,OnHand, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@PhoneOrderEntryID, @PhoneOrderID, @ItemStoreNo,  @Qty,@UOMPrice,@ExtPrice, @UOMQty,@UOMType,@LinkNo,  @Note,
	@SortOrder,@OnHand , 1, dbo.GetLocalDATE(), @ModifierID,dbo.GetLocalDATE(), @ModifierID)
GO