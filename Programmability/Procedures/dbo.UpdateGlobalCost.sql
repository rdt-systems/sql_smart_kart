SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateGlobalCost]
(@AllStores bit,
 @ModifierID UniqueIdentifier,
 @Cost  money = 0)
AS
	IF @AllStores = 1 BEGIN
		UPDATE ItemStore SET Cost = @Cost,UserModified =@ModifierID,DateModified =dbo.GetLocalDATE()
		WHERE Itemno in(select ItemID from ItemStoreIDs where UserID = @ModifierID)
	END
	ELSE BEGIN
		UPDATE ItemStore SET Cost = @Cost,UserModified =@ModifierID,DateModified =dbo.GetLocalDATE() 
		WHERE ItemStoreID  in(select ItemStoreID from ItemStoreIDs where UserID = @ModifierID  )	
	END
GO