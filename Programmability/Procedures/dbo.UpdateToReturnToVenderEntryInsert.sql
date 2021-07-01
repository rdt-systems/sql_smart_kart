SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateToReturnToVenderEntryInsert]
 (@ItemStoreNo uniqueidentifier,
 @Qty decimal(19,3),
 @ModifierID uniqueidentifier)
as

UPDATE  dbo.ItemStore 
SET OnHand = isnull(OnHand,0) - @Qty,
             DateModified = dbo.GetLocalDATE(), 
             UserModified = @ModifierID
WHERE  ItemStoreID = @ItemStoreNo 

Set @Qty = -1* @Qty

EXEC UpdateAPParent @ItemStoreNo,@ModifierID,0,1,0,@Qty
GO