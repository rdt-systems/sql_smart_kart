SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[DeleteItem]
(@ItemID uniqueidentifier,
 @StoreID uniqueidentifier=null,
 @ModifierID uniqueidentifier)
AS

DECLARE @ItemStoreID uniqueidentifier
	
	DECLARE AA CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT ItemStoreID
	FROM dbo.ItemStore WHERE (ItemNo=@ItemID Or (SELECT LinkNo 
												 FROM ItemMain 
												 WHERE ItemMain.ItemID=ItemNo)=@ItemID) 
						      And (StoreNo=@StoreID Or @StoreID is null)
	
	OPEN AA
	
	FETCH NEXT FROM AA 
	INTO @ItemStoreID   
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			exec SP_ItemStoreDelete @ItemStoreID ,@ModifierID
		FETCH NEXT FROM AA    
			INTO @ItemStoreID
		END
	
	CLOSE AA
	DEALLOCATE AA
GO