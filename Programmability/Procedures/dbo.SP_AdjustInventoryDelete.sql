SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_AdjustInventoryDelete]
(@AdjustInventoryId uniqueidentifier,
@ModifierID uniqueidentifier)
AS

DECLARE @OldQty decimal
 DECLARE @ItemStoreNo uniqueidentifier

SET @OldQty = (SELECT Qty FROM dbo.AdjustInventory WHERE  AdjustInventoryId = @AdjustInventoryId )
 SET @ItemStoreNo = (SELECT ItemStoreNo FROM dbo.AdjustInventory WHERE  AdjustInventoryId = @AdjustInventoryId )

BEGIN

UPDATE dbo.AdjustInventory
     SET    Status = - 1,
     DateModified=  dbo.GetLocalDATE(),  UserModified = @ModifierID
WHERE  AdjustInventoryId = @AdjustInventoryId


UPDATE dbo.ItemStore
SET OnHand =  (OnHand - @OldQty),  DateModified=  dbo.GetLocalDATE(),  UserModified = @ModifierID
WHERE ItemStoreID =@ItemStoreNo  /* (SELECT ItemNo FROM dbo.AdjustInventory WHERE  AdjustInventoryId = @AdjustInventoryId)   */                       

DECLARE @ID uniqueidentifier
SET @ID=(SELECT LinkNo  FROM dbo.ItemMainAndStoreView WHERE ItemStoreID = @ItemStoreNo)

IF   (@ID is not null)
BEGIN
    UPDATE  dbo.ItemStore
     SET  OnHand =   (OnHand - @OldQty), DateModified = dbo.GetLocalDATE(),  UserModified = @ModifierID
    WHERE  ItemStoreID = (SELECT ItemStoreID  FROM dbo.ItemStore WHERE StoreNo=(Select StoreNo from  dbo.ItemStore where ItemStoreID=@ItemStoreNo)  AND  (ItemNo = @ID))
END

                              
END
GO