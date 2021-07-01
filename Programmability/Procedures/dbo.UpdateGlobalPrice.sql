SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateGlobalPrice]
(@AllStores bit,
 @ModifierID UniqueIdentifier,
 @Price  money = 0,
 @FutureDate DateTime =null)
as
 IF @FutureDate is not null BEGIN  
 -- future price change
   IF @AllStores = 1 BEGIN
		UPDATE ItemStore SET NewPrice = @Price,NewPriceDate=@FutureDate,UserModified =@ModifierID,DateModified =dbo.GetLocalDATE()
		WHERE Itemno in(select ItemID from ItemStoreIDs where UserID = @ModifierID)
   END
   ELSE BEGIN
		UPDATE ItemStore SET NewPrice = @Price,NewPriceDate=@FutureDate,UserModified =@ModifierID,DateModified =dbo.GetLocalDATE() 
		WHERE ItemStoreID  in(select ItemStoreID from ItemStoreIDs where UserID = @ModifierID)	
   END
     
 END
 ELSE IF @Price  <> 0 BEGIN
   IF @AllStores = 1 BEGIN
    	INSERT INTO PriceChangeHistory(PriceChangeHistoryID,PriceLevel,ItemStoreID,OldPrice, NewPrice, UserID, [Date],DateCreated, status)
		(SELECT    NEWID(),'Price',ItemStore.ItemStoreID, ItemStore.Price,@Price,@ModifierID,dbo.GetLocalDATE(),dbo.GetLocalDATE(),1
		FROM ItemStoreIDs LEFT OUTER JOIN  ItemStore ON ItemStoreIDs.ItemID = ItemStore.ItemNo WHERE UserID =@ModifierID) 

		UPDATE ItemStore SET Price = @Price,UserModified =@ModifierID,DateModified =dbo.GetLocalDATE()
		WHERE Itemno in(select ItemID from ItemStoreIDs where UserID = @ModifierID)
   END
   ELSE BEGIN
   		INSERT INTO PriceChangeHistory(PriceChangeHistoryID,PriceLevel,ItemStoreID,OldPrice, NewPrice, UserID, [Date],DateCreated, status)
		(SELECT    NEWID(),'Price',ItemStore.ItemStoreID, ItemStore.Price,@Price,@ModifierID,dbo.GetLocalDATE(),dbo.GetLocalDATE(),1
		FROM ItemStoreIDs LEFT OUTER JOIN  ItemStore ON ItemStoreIDs.ItemStoreID  = ItemStore.ItemStoreID WHERE UserID =@ModifierID ) 

		UPDATE ItemStore SET Price = @Price,UserModified =@ModifierID,DateModified =dbo.GetLocalDATE() 
		WHERE ItemStoreID  in(select ItemStoreID from ItemStoreIDs where UserID = @ModifierID  )	
   END
 END
GO