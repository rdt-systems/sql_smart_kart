SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_AdjustInventoryUpdate]
(@AdjustInventoryId uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@Qty decimal,
@OldQty decimal,
@AdjustType int,
@AdjustReason nvarchar(4000),
@AccountNo int,
@Cost money,
@Status smallint,
@DateModified datetime,
@ModifierID uniqueidentifier)

AS


DECLARE @OldQtyAdjust decimal
 SET @OldQtyAdjust = (SELECT Qty FROM dbo.AdjustInventory WHERE  AdjustInventoryId = @AdjustInventoryId )
BEGIN


Declare @UpdateTime datetime
set  @UpdateTime =dbo.GetLocalDATE()

UPDATE dbo.AdjustInventory

SET     ItemStoreNo =  @ItemStoreNo, Qty = @Qty, OldQty = @OldQty, AdjustType = @AdjustType, AdjustReason = @AdjustReason, AccountNo = 
@AccountNo, Cost=@Cost,
          Status = @Status, DateModified= @UpdateTime,  UserModified = @ModifierID
WHERE  (AdjustInventoryId = @AdjustInventoryId) AND 
      (DateModified = @DateModified OR DateModified IS NULL)

IF @@ROWCOUNT=0  return

IF (@Qty <> @OldQtyAdjust)

 UPDATE dbo.ItemStore
 SET OnHand =   (OnHand + (@Qty - @OldQtyAdjust)),   DateModified=  dbo.GetLocalDATE(),  UserModified = @ModifierID
WHERE ItemStoreId= @ItemStoreNo

DECLARE @ID uniqueidentifier
SET @ID=(SELECT LinkNo  FROM dbo.ItemMainAndStoreView WHERE ItemStoreID = @ItemStoreNo)

IF   (@ID is not null)
BEGIN
    UPDATE  dbo.ItemStore
     SET  OnHand =  (OnHand + (@Qty - @OldQtyAdjust)), DateModified = dbo.GetLocalDATE(),  UserModified = @ModifierID
    WHERE  ItemStoreID = (SELECT ItemStoreID  FROM dbo.ItemStore WHERE StoreNo=(Select StoreNo from  dbo.ItemStore where 
ItemStoreID=@ItemStoreNo)  AND  (ItemNo = @ID))
END
END

select @UpdateTime as DateModified
GO