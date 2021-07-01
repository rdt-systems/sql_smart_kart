SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateGlobalSaleDate]
(@AllStores bit,
 @ModifierID UniqueIdentifier,
 @AssigenDate bit,
 @SaleStartDate datetime =null,
 @SaleEndDate datetime)
as

IF @AllStores = 1 BEGIN
	--INSERT INTO PriceChangeHistory(PriceChangeHistoryID,PriceLevel,ItemStoreID,OldPrice, NewPrice, UserID, [Date], status)
	--(SELECT    NEWID(),'Price',ItemStore.ItemStoreID, ItemStore.Price,@Price,@ModifierID,dbo.GetLocalDATE(),1
	--FROM ItemStoreIDs LEFT OUTER JOIN  ItemStore ON ItemStoreIDs.ItemID = ItemStore.ItemNo WHERE UserID =@ModifierID) 

	UPDATE ItemStore SET  AssignDate=@AssigenDate,SaleStartDate =ISNull(@SaleStartDate,SaleStartDate),SaleEndDate =@SaleEndDate,
	SpecialBuyFromDate=@SaleStartDate, SpecialBuyToDate=@SaleEndDate,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
	WHERE Itemno in(select ItemID from ItemStoreIDs WHERE UserID =@ModifierID)
END
ELSE BEGIN
--	INSERT INTO PriceChangeHistory(PriceChangeHistoryID,PriceLevel,ItemStoreID,OldPrice, NewPrice, UserID, [Date], status)
--	(SELECT    NEWID(),'Price',ItemStore.ItemStoreID, ItemStore.Price,@Price,@ModifierID,dbo.GetLocalDATE(),1
--	FROM ItemStoreIDs LEFT OUTER JOIN  ItemStore ON ItemStoreIDs.ItemStoreID  = ItemStore.ItemStoreID WHERE UserID =@ModifierID ) 

	UPDATE ItemStore SET  AssignDate=@AssigenDate,SaleStartDate =ISNull(@SaleStartDate,SaleStartDate),SaleEndDate =@SaleEndDate,
	SpecialBuyFromDate=@SaleStartDate, SpecialBuyToDate=@SaleEndDate,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
	WHERE ItemStoreID  in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)	
END
GO