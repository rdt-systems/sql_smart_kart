SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[UpdateGlobalSalePrice]
(@AllStores bit,
 @ModifierID UniqueIdentifier,
 @SaleType int,
 @SalePrice money,
 @BreakDownQty int,
 @BreakDownPrice money,
 @MinTotalSale money,
 @MinQty Int = NULL,
 @MaxQty Int = NULL,
 @AssigenDate bit,
 @SaleStartDate datetime,
 @SaleEndDate datetime,
 @DiscountFromRegular int = 0,
 @FutureSale bit = 0)
as

IF @FutureSale = 1 
BEGIN
--first add all items that doen't have a row.
Insert INTO ItemSpecial (ItemStoreID, Status, DateCreated, UserCreated) SELECT ItemStoreID, 1, dbo.GetLocalDATE(), @ModifierID from ItemStoreIDs  
WHERE ItemStoreID not in(select ItemStoreID from ItemSpecial WHERE Status > -1)
--now will update the sale info.
IF @DiscountFromRegular = 0
	BEGIN
	UPDATE ItemSpecial SET SalePrice =@SalePrice,SpecialBuy=@BreakDownQty,SpecialPrice=@BreakDownPrice,MinForSale =@MinTotalSale, SaleMin = @MinQty , SaleMax = @MaxQty,
	                     AssignDate=@AssigenDate,SaleStartDate =@SaleStartDate,SaleEndDate =@SaleEndDate,SaleType =@SaleType,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
		WHERE ItemStoreID  in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
	END
     ELSE IF @DiscountFromRegular = 1
	 BEGIN -- Dollar amount
	                 	UPDATE ItemSpecial SET SalePrice = (Price - @SalePrice),SpecialBuy=@BreakDownQty,SpecialPrice=@BreakDownPrice,MinForSale =@MinTotalSale, SaleMin = @MinQty , SaleMax = @MaxQty,
	                     AssignDate=@AssigenDate,SaleStartDate =@SaleStartDate,SaleEndDate =@SaleEndDate
	                     ,SaleType =@SaleType,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
					 From ItemSpecial ite inner join itemstore its on ite.ItemStoreID = its.ItemStoreID
			WHERE ite.ItemStoreID  in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
	END
		ELSE IF @DiscountFromRegular = 2
		BEGIN -- Percent amount
		UPDATE ItemSpecial SET SalePrice = Price - (Price * @SalePrice)   ,SpecialBuy=@BreakDownQty,SpecialPrice=@BreakDownPrice,MinForSale =@MinTotalSale, SaleMin = @MinQty , SaleMax = @MaxQty,
	                     AssignDate=@AssigenDate,SaleStartDate =@SaleStartDate,SaleEndDate =@SaleEndDate,SaleType =@SaleType,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
					 From ItemSpecial ite inner join itemstore its on ite.ItemStoreID = its.ItemStoreID
	    WHERE ite.ItemStoreID  in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
END
END
ELSE
 
BEGIN

IF @AllStores = 1 BEGIN
	--INSERT INTO PriceChangeHistory(PriceChangeHistoryID,PriceLevel,ItemStoreID,OldPrice, NewPrice, UserID, [Date], status)
	--(SELECT    NEWID(),'Price',ItemStore.ItemStoreID, ItemStore.Price,@Price,@ModifierID,dbo.GetLocalDATE(),1
	--FROM ItemStoreIDs LEFT OUTER JOIN  ItemStore ON ItemStoreIDs.ItemID = ItemStore.ItemNo WHERE UserID =@ModifierID) 
	IF @DiscountFromRegular = 0
	BEGIN
	UPDATE ItemStore SET SalePrice =@SalePrice,SpecialBuy=@BreakDownQty,SpecialPrice=@BreakDownPrice,MinForSale =@MinTotalSale, SaleMin = @MinQty , SaleMax = @MaxQty,
	                     AssignDate=@AssigenDate,SaleStartDate =@SaleStartDate,SaleEndDate =@SaleEndDate,SpecialBuyFromDate=@SaleStartDate,
	                     SpecialBuyToDate=@SaleEndDate,SaleType =@SaleType,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
	WHERE Itemno in(select ItemID from ItemStoreIDs WHERE UserID =@ModifierID)
	END
	 ELSE IF @DiscountFromRegular = 1
	 BEGIN -- Dollar amount
	                 	UPDATE ItemStore SET SalePrice = (Price - @SalePrice),SpecialBuy=@BreakDownQty,SpecialPrice=@BreakDownPrice,MinForSale =@MinTotalSale, SaleMin = @MinQty , SaleMax = @MaxQty,
	                     AssignDate=@AssigenDate,SaleStartDate =@SaleStartDate,SaleEndDate =@SaleEndDate,SpecialBuyFromDate=@SaleStartDate,
	                     SpecialBuyToDate=@SaleEndDate,SaleType =@SaleType,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
	WHERE Itemno in(select ItemID from ItemStoreIDs WHERE UserID =@ModifierID)
		END
		ELSE IF @DiscountFromRegular = 2
		BEGIN -- Percent amount
		UPDATE ItemStore SET SalePrice = Price - (Price * @SalePrice) , SpecialBuy=@BreakDownQty,SpecialPrice=@BreakDownPrice,MinForSale =@MinTotalSale, SaleMin = @MinQty , SaleMax = @MaxQty,
	                     AssignDate=@AssigenDate,SaleStartDate =@SaleStartDate,SaleEndDate =@SaleEndDate,SpecialBuyFromDate=@SaleStartDate,
	                     SpecialBuyToDate=@SaleEndDate,SaleType =@SaleType,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
	WHERE Itemno in(select ItemID from ItemStoreIDs WHERE UserID =@ModifierID)
		END

	INSERT INTO PriceChangeHistory
                      (PriceChangeHistoryID, ItemStoreID, OldPrice, UserID,Date, SaleType, SP_Price, SaleDate,status, DateCreated)
		SELECT     NEWID(), ItemStore.ItemStoreID, ItemStore.Price, @ModifierID,dbo.GetLocalDATE(), 
		/*SaleType */		 (CASE WHEN @SaleType =1 Then 'Reg Sale' WHEN SaleType =2 then 'Break Down'WHEN @SaleType =4 then 'Combined' ELSE 'None' END),
		/*SalePrice */		 (CASE WHEN @SaleType = 1 THEN CASE WHEN ISNULL(AssignDate, 0) 
							  > 0 THEN CASE WHEN (dbo.GetDay(@SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) THEN '1 @ ' + CONVERT(nvarchar, @SalePrice, 110) 
							  END ELSE '1 @ ' + CONVERT(nvarchar, @SalePrice, 110) END WHEN SaleType = 2 AND ((ISNULL(AssignDate, 0) > 0) AND 
							  (dbo.GetDay(@SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
							  (ISNULL(AssignDate, 0) = 0)) THEN CONVERT(nvarchar, SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, SpecialPrice, 110) 
							   WHEN @SaleType = 4 AND ((ISNULL(AssignDate, 0) > 0) AND (dbo.GetDay(SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
							  (ISNULL(AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(nvarchar, @SalePrice, 110) + ' , ' + CONVERT(nvarchar, SpecialBuy, 
							  110) + ' @ ' + CONVERT(nvarchar, SpecialPrice, 110) END) , 
		/*SaleDate */		  (CASE WHEN AssignDate =1 Then CONVERT(nvarchar, SaleStartDate, 110)+' - '+ CONVERT(nvarchar, @SaleEndDate, 110) ELSE '' END),
		1, dbo.GetLocalDATE()
		FROM         ItemStoreIDs INNER JOIN
							  ItemStore ON ItemStoreIDs.ItemID = ItemStore.ItemNo WHERE ItemStoreIDs.UserID =@ModifierID	
END
ELSE BEGIN
--	INSERT INTO PriceChangeHistory(PriceChangeHistoryID,PriceLevel,ItemStoreID,OldPrice, NewPrice, UserID, [Date], status)
--	(SELECT    NEWID(),'Price',ItemStore.ItemStoreID, ItemStore.Price,@Price,@ModifierID,dbo.GetLocalDATE(),1
--	FROM ItemStoreIDs LEFT OUTER JOIN  ItemStore ON ItemStoreIDs.ItemStoreID  = ItemStore.ItemStoreID WHERE UserID =@ModifierID ) 

	IF @DiscountFromRegular = 0
	BEGIN
	UPDATE ItemStore SET SalePrice =@SalePrice,SpecialBuy=@BreakDownQty,SpecialPrice=@BreakDownPrice,MinForSale =@MinTotalSale, SaleMin = @MinQty , SaleMax = @MaxQty,
	                     AssignDate=@AssigenDate,SaleStartDate =@SaleStartDate,SaleEndDate =@SaleEndDate,SpecialBuyFromDate=@SaleStartDate,
	                     SpecialBuyToDate=@SaleEndDate,SaleType =@SaleType,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
		WHERE ItemStoreID  in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
	END
	 ELSE IF @DiscountFromRegular = 1
	 BEGIN -- Dollar amount
	                 	UPDATE ItemStore SET SalePrice = (Price - @SalePrice),SpecialBuy=@BreakDownQty,SpecialPrice=@BreakDownPrice,MinForSale =@MinTotalSale, SaleMin = @MinQty , SaleMax = @MaxQty,
	                     AssignDate=@AssigenDate,SaleStartDate =@SaleStartDate,SaleEndDate =@SaleEndDate,SpecialBuyFromDate=@SaleStartDate,
	                     SpecialBuyToDate=@SaleEndDate,SaleType =@SaleType,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
			WHERE ItemStoreID  in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
		END
		ELSE IF @DiscountFromRegular = 2
		BEGIN -- Percent amount
		UPDATE ItemStore SET SalePrice = Price - (Price * @SalePrice)   ,SpecialBuy=@BreakDownQty,SpecialPrice=@BreakDownPrice,MinForSale =@MinTotalSale, SaleMin = @MinQty , SaleMax = @MaxQty,
	                     AssignDate=@AssigenDate,SaleStartDate =@SaleStartDate,SaleEndDate =@SaleEndDate,SpecialBuyFromDate=@SaleStartDate,
	                     SpecialBuyToDate=@SaleEndDate,SaleType =@SaleType,UserModified =@ModifierID ,DateModified =dbo.GetLocalDATE()
	WHERE ItemStoreID  in(select ItemStoreID from ItemStoreIDs WHERE UserID =@ModifierID)
		END
END

		INSERT INTO PriceChangeHistory
                      (PriceChangeHistoryID, ItemStoreID, OldPrice, UserID,Date, SaleType, SP_Price, SaleDate,status, DateCreated)
		SELECT     NEWID(), ItemStore.ItemStoreID, ItemStore.Price, @ModifierID,dbo.GetLocalDATE(),  
		/*SaleType */		 (CASE WHEN @SaleType =1 Then 'Reg Sale' WHEN SaleType =2 then 'Break Down'WHEN @SaleType =4 then 'Combined' ELSE 'None' END),
		/*SalePrice */		 (CASE WHEN @SaleType = 1 THEN CASE WHEN ISNULL(AssignDate, 0) 
							  > 0 THEN CASE WHEN (dbo.GetDay(@SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) THEN '1 @ ' + CONVERT(nvarchar, @SalePrice, 110) 
							  END ELSE '1 @ ' + CONVERT(nvarchar, @SalePrice, 110) END WHEN SaleType = 2 AND ((ISNULL(AssignDate, 0) > 0) AND 
							  (dbo.GetDay(@SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
							  (ISNULL(AssignDate, 0) = 0)) THEN CONVERT(nvarchar, SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, SpecialPrice, 110) 
							   WHEN @SaleType = 4 AND ((ISNULL(AssignDate, 0) > 0) AND (dbo.GetDay(SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
							  (ISNULL(AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(nvarchar, @SalePrice, 110) + ' , ' + CONVERT(nvarchar, SpecialBuy, 
							  110) + ' @ ' + CONVERT(nvarchar, SpecialPrice, 110) END) , 
		/*SaleDate */		  (CASE WHEN AssignDate =1 Then CONVERT(nvarchar, SaleStartDate, 110)+' - '+ CONVERT(nvarchar, @SaleEndDate, 110) ELSE '' END),
		1, dbo.GetLocalDATE()
		FROM         ItemStoreIDs INNER JOIN
							  ItemStore ON ItemStoreIDs.ItemStoreID = ItemStore.ItemStoreID WHERE ItemStoreIDs.UserID =@ModifierID	
	
END
GO