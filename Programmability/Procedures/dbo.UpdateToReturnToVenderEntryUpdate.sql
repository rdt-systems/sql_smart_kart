SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateToReturnToVenderEntryUpdate]
(@ItemStoreNo uniqueidentifier,
 @OldItem uniqueidentifier,
 @OldQty decimal(19,3),
 @Qty decimal(19,3),
 @Status  smallint, 
 @ModifierID uniqueidentifier)

as
Declare @QtyForOnHand Decimal(19,3)

if @ItemStoreNo=@OldItem
	set @QtyForOnHand=@OldQty - @Qty 
else 
	set @QtyForOnHand=-@OldQty 

if @Status=0
begin
set @QtyForOnHand=@OldQty 
set @Qty=0
end
 
	UPDATE dbo.ItemStore
    SET    OnHand = (ISNULL(OnHand,0) + @QtyForOnHand), 
		   DateModified = dbo.GetLocalDATE(), 
		   UserModified = @ModifierID
   	WHERE  ItemStoreID = @ItemStoreNo

	EXEC UpdateAPParent @ItemStoreNo,@ModifierID,0,1,0,@QtyForOnHand

if @ItemStoreNo <> @OldItem

	UPDATE dbo.ItemStore
	SET    OnHand =(isnull(OnHand,0) + @Qty), 
		   DateModified=dbo.GetLocalDATE(),
		   UserModified=@ModifierID
	WHERE ItemStoreID= @OldItem

	EXEC UpdateAPParent @OldItem,@ModifierID,0,1,0,@Qty
GO