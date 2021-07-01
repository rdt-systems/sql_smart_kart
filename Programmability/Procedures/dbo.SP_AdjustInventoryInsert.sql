SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_AdjustInventoryInsert]
(@AdjustInventoryId uniqueidentifier,
@ItemStoreNo uniqueidentifier,
@Qty decimal,
@OldQty decimal,
@AdjustType int,
@AdjustReason nvarchar(4000),
@AccountNo int,
@Cost money,
@Status smallint,
@AdjustDate datetime = null,
@ModifierID uniqueidentifier)
AS 
Declare @D datetime 
if @AdjustDate is null
  set @D = dbo.GetLocalDATE()
 else
   Set @D = @AdjustDate
INSERT INTO dbo.AdjustInventory
                      (AdjustInventoryId, ItemStoreNo, Qty, OldQty, AdjustType, AdjustReason, AccountNo,Cost, Status, DateCreated, UserCreated, DateModified, UserModified)
VALUES     (@AdjustInventoryId, @ItemStoreNo, @Qty, @OldQty, @AdjustType, @AdjustReason, @AccountNo,@Cost, 1, @D, @ModifierID, dbo.GetLocalDATE(), @ModifierID)

--Added to refresh and update itemStore Onhand and datemodified
Exec SP_UpdateOnHandOneItem @ItemStoreID = @ItemStoreNo

--UPDATE dbo.ItemStore
-- SET OnHand =   (ISNULL(OnHand,0) + @Qty),  DateModified=  dbo.GetLocalDATE(),  UserModified = @ModifierID
--WHERE ItemStoreId = @ItemStoreNo

--DECLARE @ID uniqueidentifier
--SET @ID=(SELECT LinkNo  FROM dbo.ItemMainAndStoreView WHERE ItemStoreID = @ItemStoreNo)

--IF   (@ID is not null)
--BEGIN
--    UPDATE  dbo.ItemStore
--     SET  OnHand =   (OnHand + @Qty), DateModified = dbo.GetLocalDATE(),  UserModified = @ModifierID
--    WHERE  ItemStoreID = (SELECT ItemStoreID  FROM dbo.ItemStore WHERE StoreNo=(Select StoreNo from  dbo.ItemStore where ItemStoreID=@ItemStoreNo)  AND  (ItemNo = @ID))
--END



--UPDATE       ItemStore
--SET                OnHand = 0, DateModified = dbo.GetLocalDATE()
--FROM            ItemStore INNER JOIN
--                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID
--WHERE        (ItemMain.ItemType = 2) AND (ItemStore.OnHand <> 0)
GO