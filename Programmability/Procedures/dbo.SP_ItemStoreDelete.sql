SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ItemStoreDelete]
(@ItemStoreID uniqueidentifier,
 @ModifierID uniqueidentifier)
AS

      UPDATE  dbo.ItemStore
       SET     Status = - 1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
      WHERE   (ItemStoreID = @ItemStoreID)
 
       UPDATE dbo.ItemSupply 
        SET Status = -1 
      WHERE ItemStoreNo  = @ItemStoreID

     UPDATE dbo.ItemToGroup
        SET Status = -1 
      WHERE ItemStoreID = @ItemStoreID

     UPDATE dbo.ItemSeason
        SET Status = -1 
      WHERE ItemStoreNo  = @ItemStoreID

     UPDATE dbo.PrintLabels
        SET Status = -1 
      WHERE ItemStoreID  = @ItemStoreID

     UPDATE dbo.ItemNotes
        SET Status = -1 
      WHERE ItemStoreNo  = @ItemStoreID

    UPDATE dbo.Attachments
        SET Status = -1 
      WHERE ItemStoreID  = @ItemStoreID

    UPDATE dbo.ExtraCharge
        SET Status = -1 
      WHERE ItemStoreNo  = @ItemStoreID
	
    UPDATE dbo.ItemStore
        SET ExtraCharge1 = null
      WHERE ExtraCharge1  = @ItemStoreID

 UPDATE dbo.ItemStore
        SET ExtraCharge2 = null
      WHERE ExtraCharge2  = @ItemStoreID

 UPDATE dbo.ItemStore
        SET ExtraCharge3 = null
      WHERE ExtraCharge3  = @ItemStoreID

Declare @ItemNo uniqueidentifier
set @ItemNo = (SELECT ItemNo FROM dbo.ItemStore WHERE (ItemStoreID = @ItemStoreID))

UPDATE dbo.SubstitueItems 
       SET     Status = - 1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE (SubstitueNo=@ItemNo or ItemNo=@ItemNo )

UPDATE dbo.ItemAlias 
       SET     Status = - 1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE (ItemNo=@ItemNo)

--Update Matrix Parent

DECLARE @ID uniqueidentifier
SET @ID=(SELECT LinkNo  FROM dbo.ItemMainAndStoreView WHERE ItemStoreID = @ItemStoreID)

DECLARE @OnHand Decimal(19,3)
SET @OnHand=(SELECT OnHand  FROM dbo.ItemMainAndStoreView WHERE ItemStoreID = @ItemStoreID)


IF   (@ID is not null)
BEGIN
    UPDATE  dbo.ItemStore
     SET  OnHand =(OnHand - ISNULL(@OnHand,0)), 
		  DateModified = dbo.GetLocalDATE(),  
		  UserModified = @ModifierID
    WHERE  ItemStoreID = (SELECT ItemStoreID  FROM dbo.ItemStore WHERE StoreNo=(Select StoreNo from  dbo.ItemStore where ItemStoreID=@ItemStoreID)  AND  (ItemNo = @ID))
END

UPDATE dbo.ItemMain 
       SET     Status = - 1, DateModified = dbo.GetLocalDATE(), UserModified = @ModifierID
WHERE ((SELECT count(*) FROM dbo.ItemStore WHERE ItemNo=(@ItemNo)AND Status>=0)=0) and ItemID=@ItemNo
GO