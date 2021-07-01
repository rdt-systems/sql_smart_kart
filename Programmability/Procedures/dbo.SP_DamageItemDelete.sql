SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_DamageItemDelete]
(@DamageItemID uniqueidentifier,
@ModifierID uniqueidentifier)

AS 


UPDATE dbo.DamageItem             
SET     status=-1, DateModified = dbo.GetLocalDATE(), UserModified =@ModifierID
WHERE DamageItemID=@DamageItemID

Declare @ItemStoreID Uniqueidentifier
set @ItemStoreID= (SELECT ItemStoreID from DamageItem WHERE DamageItemID=@DamageItemID)

if (SELECT DamageStatus from DamageItem WHERE DamageItemID=@DamageItemID) <>1

	UPDATE dbo.ItemStore
	SET OnHand = isnull(OnHand,0) + (SELECT Qty from DamageItem WHERE DamageItemID=@DamageItemID) , 
		DateModified = dbo.GetLocalDATE(), 
		UserModified = @ModifierID
	WHERE ItemStoreID = @ItemStoreID

EXEC UpdateParent @ItemStoreID,@ModifierID,1,0,0
GO