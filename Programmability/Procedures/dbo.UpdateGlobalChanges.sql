SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateGlobalChanges]
(@AllStores bit =0,
 @SupplierID uniqueidentifier=NULL,
 @MainSupplier bit = NULL,
 @TagAlong1 uniqueidentifier=NULL,
 @TagAlong2 uniqueidentifier=NULL,
 @TagAlong3 uniqueidentifier=NULL,
 @Group uniqueidentifier=NULL,     
 @Department uniqueidentifier=NULL,
 @Manufacturer uniqueidentifier=NULL,
 @ItemType int=NULL,
 @Taxable bit=NULL,
 @Tax uniqueidentifier=NULL,
 @Discountable int=NULL,
 @FoodStamp int=NULL,
 @Active int=NULL,
 @AdjustQty decimal(19,3)=NULL,
 @AdjustType int=NULL,
 @AdjustAccount int=NULL,
 @AdjustReason nvarchar=NULL,
 @RemoveSale bit=NULL,
 @ModifierID uniqueidentifier)

as
DECLARE @OldQty decimal(19,3)
DECLARE @Cost decimal(19,3)
Declare @ItemStoreID uniqueidentifier
DECLARE @ID uniqueidentifier



	--Alex Abreu
	--Insert values before modify the table to rollback the globalchanges
	----------------------------------------------------------------------------------------------------------------------------------
	Insert into dbo.GlobalChange(GlobalChangeID,UserID, ChangeDescr, AllStores, DateCreated)
	values (NEWID(),@ModifierID,'',@AllStores,dbo.GetLocalDATE())

	declare @IDx uniqueidentifier
	Set @IDx = (SELECT TOP(1) GlobalChangeID from dbo.GlobalChange where UserID = @ModifierID Order By DateCreated Desc)
	-- Changed by oshe to avoid errors by older versions of SQL:
	--select @IDx = max(GlobalChangeID) from dbo.GlobalChange where UserID = @ModifierID

	insert into dbo.GlobalChangeEntry(GlobalChangeID, ItemStoreID, ItemNo, StoreNo, DepartmentID, Cost, ListPrice, Price, PriceA, PriceB, 
	PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, MainSupplierID, BinLocation, AVGCost, SaleType, SalePrice, SaleStartDate, 
	SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate)
	select @IDx as GlobalChangeID,ItemStoreID, ItemNo, StoreNo, DepartmentID, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, 
	ExtraCharge2, ExtraCharge3, MainSupplierID, BinLocation, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, 
	MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate
	from ItemStore where ItemStoreID in (SELECT ItemStoreID FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)
	----------------------------------------------------------------------------------------------------------------------------------

IF @AllStores = 0 BEGIN
	---TagAlong1
	IF @TagAlong1 IS NOT NULL
	BEGIN

	UPDATE dbo.ItemStore
	SET ExtraCharge1=@TagAlong1,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
		from itemmain 
	WHERE ItemStoreID IN (SELECT ItemStoreID
						  FROM dbo.ItemStoreIDs
						  WHERE ItemStoreID<>@TagAlong1 AND UserID =@ModifierID )
						  and dbo.ItemStore.ItemNo = Itemmain.ItemID and itemmain.itemType <> 2

		   
	END
	---TagAlong2
	IF @TagAlong2 IS NOT NULL
	UPDATE dbo.ItemStore
	SET ExtraCharge2=@TagAlong2,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemStoreID IN (SELECT ItemStoreID
						  FROM dbo.ItemStoreIDs
						  WHERE ItemStoreID<>@TagAlong2 AND UserID =@ModifierID)

	---TagAlong3
	IF @TagAlong3 IS NOT NULL
	UPDATE dbo.ItemStore
	SET ExtraCharge3=@TagAlong3,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemStoreID IN (SELECT ItemStoreID
						  FROM dbo.ItemStoreIDs
						  WHERE ItemStoreID<>@TagAlong3 AND UserID =@ModifierID)

	---Department
	IF @Department IS NOT NULL
	UPDATE dbo.ItemStore
	SET DepartmentID=@Department,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemStoreID IN (SELECT ItemStoreID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)

	---Manufacturer

	IF @Manufacturer IS NOT NULL
	UPDATE dbo.ItemMain
	SET ManufacturerID=@Manufacturer,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemID IN (SELECT ItemID
					 FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)

	---ItemType

	IF @ItemType IS NOT NULL
	UPDATE dbo.ItemMain
	SET ItemType=@ItemType,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemID IN (SELECT ItemID
					 FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)


	--Taxable

	IF @Taxable IS NOT NULL
	UPDATE dbo.ItemStore
	SET IsTaxable=@Taxable,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemStoreID IN (SELECT ItemStoreID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)

	IF @Tax IS NOT NULL
	UPDATE dbo.ItemStore
	SET TaxID=@Tax,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemStoreID IN (SELECT ItemStoreID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)

						  
	--Discountable
	print @Discountable
	IF @Discountable IS NOT NULL
	BEGIN
	UPDATE dbo.ItemStore
	SET IsDiscount=@Discountable,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemStoreID IN (SELECT ItemStoreID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)
	END
	--print @Discountable
	--Discountable
	IF @FoodStamp IS NOT NULL
	BEGIN
	UPDATE dbo.ItemStore
	SET IsFoodStampable=@FoodStamp,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemStoreID IN (SELECT ItemStoreID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)
	END

	--Active

	IF @Active IS NOT NULL 
	BEGIN
	UPDATE dbo.ItemStore
	SET Status=@Active,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemStoreID IN (SELECT ItemStoreID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)
    UPDATE dbo.ItemMain 
	SET Status=@Active,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemID IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)
						  
	END


	-- Remove Sale
	IF ISNULL(@RemoveSale,0) > 0 BEGIN
	UPDATE dbo.ItemStore
	SET SaleType=0,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemStoreID IN (SELECT ItemStoreID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)
	END



	--Supplier

	IF @SupplierID IS NOT NULL
	BEGIN
	DECLARE i CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
		SELECT ItemStoreID
		FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID
	
	OPEN i

	FETCH NEXT FROM i 
	INTO @ItemStoreID


	WHILE @@FETCH_STATUS = 0
		BEGIN
			 exec [UpdateSupplierItem] @ItemStoreID,@SupplierID,@MainSupplier,@ModifierID
		FETCH NEXT FROM i    --insert the next values to the instance
			INTO @ItemStoreID
		END

	CLOSE i
	DEALLOCATE i
	END
	

	--Group
	IF @Group IS NOT NULL
	BEGIN
	DECLARE j CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT ItemStoreID
	FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID

	OPEN j

	FETCH NEXT FROM j 
	INTO @ItemStoreID


	WHILE @@FETCH_STATUS = 0
		BEGIN
		   If 
			(Select count(*)
			 From ItemToGroup
			 Where ItemStoreID=@ItemStoreID AND ItemGroupID=@Group And Status>0)=0

			 INSERT INTO dbo.ItemToGroup
			  (ItemToGroupID ,ItemGroupID ,ItemStoreID ,Status,DateModified)
			 VALUES 
			 (NEWID() , @Group , @ItemStoreID , 1,dbo.GetLocalDATE())

		FETCH NEXT FROM j    --insert the next values to the instance
			INTO @ItemStoreID
		END

	CLOSE j
	DEALLOCATE j
	END

	--Adjust Inventory

	IF @AdjustQty IS NOT NULL AND @AdjustType IS NOT NULL AND @AdjustAccount IS NOT NULL AND @AdjustReason IS NOT NULL
	BEGIN
	DECLARE k CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT     ItemStoreIDs.ItemStoreID
	FROM         ItemStoreIDs INNER JOIN
						  ItemMainAndStoreView ON ItemMainAndStoreView.ItemStoreID = ItemStoreIDs.ItemStoreID
	WHERE     (ItemMainAndStoreView.ItemType <> 2) AND (ItemStoreIDs.UserID = @ModifierID)

	OPEN k

	FETCH NEXT FROM k 
	INTO @ItemStoreID


	WHILE @@FETCH_STATUS = 0
		BEGIN
		    exec SP_UpdateOnHandOneItem @ItemStoreID =@ItemStoreID 
			SET @OldQty=(Select OnHand From ItemStore Where ItemStoreID=@ItemStoreID) 
			SET @Cost=(Select Cost From ItemStore Where ItemStoreID=@ItemStoreID)
		   INSERT INTO dbo.AdjustInventory
						(AdjustInventoryId, ItemStoreNo, Qty, OldQty, AdjustType, AdjustReason, AccountNo,Cost, Status, DateCreated, UserCreated, DateModified, UserModified)
			VALUES     (NEWID(), @ItemStoreID, @AdjustQty-@OldQty, @OldQty, @AdjustType, @AdjustReason, @AdjustAccount,@Cost, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)

			UPDATE dbo.ItemStore
			 SET OnHand =@AdjustQty,  
				 DateModified=dbo.GetLocalDATE(),  
				 UserModified = @ModifierID
			WHERE ItemStoreId = @ItemStoreID

			--SET @ID=(SELECT LinkNo  FROM dbo.ItemMainAndStoreView WHERE ItemStoreID = @ItemStoreID)

			--IF   (@ID is not null)
			--BEGIN
			--	UPDATE  dbo.ItemStore
			--	 SET  OnHand =(OnHand + @AdjustQty-@OldQty), 
			--		  DateModified = dbo.GetLocalDATE(),  
			--		  UserModified = @ModifierID
			--	WHERE  ItemStoreID IN (SELECT ItemStoreID  FROM dbo.ItemStore WHERE StoreNo=(Select StoreNo from  dbo.ItemStore 
			--						   where ItemStoreID=@ItemStoreID)  AND  (ItemNo = @ID))
			--END

		FETCH NEXT FROM k    --insert the next values to the instance
			INTO @ItemStoreID
		END

	CLOSE k
	DEALLOCATE k
			
	END

	UPDATE ITEMSTORE SET DATEMODIFIED =dbo.GetLocalDATE() WHERE ItemStoreID IN(SELECT ItemStoreID FROM dbo.ItemStoreIDs)
	UPDATE ITEMMAIN SET DATEMODIFIED =dbo.GetLocalDATE() WHERE ItemID IN(SELECT ItemID FROM dbo.ItemStoreIDs)

END
ELSE
	---TagAlong1
	IF @TagAlong1 IS NOT NULL
	BEGIN

	UPDATE dbo.ItemStore
	SET ExtraCharge1=@TagAlong1,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemNo IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs
						  WHERE ItemStoreID<>@TagAlong1 AND UserID =@ModifierID )

		   
	END
	---TagAlong2
	IF @TagAlong2 IS NOT NULL
	UPDATE dbo.ItemStore
	SET ExtraCharge2=@TagAlong2,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemNo IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs
						  WHERE ItemStoreID<>@TagAlong2 AND UserID =@ModifierID)

	---TagAlong3
	IF @TagAlong3 IS NOT NULL
	UPDATE dbo.ItemStore
	SET ExtraCharge3=@TagAlong3,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemNo IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs
						  WHERE ItemStoreID<>@TagAlong3 AND UserID =@ModifierID)

	---Department
	IF @Department IS NOT NULL
	UPDATE dbo.ItemStore
	SET DepartmentID=@Department,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemNo IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)

	---Manufacturer

	IF @Manufacturer IS NOT NULL
	UPDATE dbo.ItemMain
	SET ManufacturerID=@Manufacturer,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemID IN (SELECT ItemID
					 FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)

	---ItemType

	IF @ItemType IS NOT NULL
	UPDATE dbo.ItemMain
	SET ItemType=@ItemType,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemID IN (SELECT ItemID
					 FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)


	--Taxable

	IF @Taxable IS NOT NULL
	UPDATE dbo.ItemStore
	SET IsTaxable=@Taxable,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemNo IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)

	IF @Tax IS NOT NULL
	UPDATE dbo.ItemStore
	SET TaxID=@Tax,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemNo IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)

						  
	--Discountable
	print @Discountable
	IF @Discountable IS NOT NULL
	BEGIN
	UPDATE dbo.ItemStore
	SET IsDiscount=@Discountable,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemNo IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)
	END
	--print @Discountable
	--Discountable
	IF @FoodStamp IS NOT NULL
	BEGIN
	UPDATE dbo.ItemStore
	SET IsFoodStampable=@FoodStamp,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemNo IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)
	END

	--Active

	IF @Active IS NOT NULL 
	BEGIN
	UPDATE dbo.ItemStore
	SET Status=@Active,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemNo IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)
    UPDATE dbo.ItemMain 
	SET Status=@Active,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemID IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)

	END


	-- Remove Sale
	IF ISNULL(@RemoveSale,0) > 0 BEGIN
	UPDATE dbo.ItemStore
	SET SaleType=0,
		DateModified=dbo.GetLocalDATE(),
		UserModified=@ModifierID
	WHERE ItemNo IN (SELECT ItemID
						  FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)
	END



	--Supplier

	IF @SupplierID IS NOT NULL
	BEGIN
	print 'Past Supplier'
	DECLARE i CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT ItemStoreID From ItemStore Where ItemNo IN (SELECT ItemID
	FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID)

	OPEN i

	FETCH NEXT FROM i 
	INTO @ItemStoreID


	WHILE @@FETCH_STATUS = 0
		BEGIN
			 exec [UpdateSupplierItem] @ItemStoreID,@SupplierID,@MainSupplier,@ModifierID
		FETCH NEXT FROM i    --insert the next values to the instance
			INTO @ItemStoreID
		END

	CLOSE i
	DEALLOCATE i
	END

	--Group
	IF @Group IS NOT NULL
	BEGIN
	DECLARE j CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
	SELECT ItemStoreID
	FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID

	OPEN j

	FETCH NEXT FROM j 
	INTO @ItemStoreID


	WHILE @@FETCH_STATUS = 0
		BEGIN
		   If 
			(Select count(*)
			 From ItemToGroup
			 Where ItemStoreID=@ItemStoreID AND ItemGroupID=@Group And Status>0)=0

			 INSERT INTO dbo.ItemToGroup
			  (ItemToGroupID ,ItemGroupID ,ItemStoreID ,Status,DateModified)
			 VALUES 
			 (NEWID() , @Group , @ItemStoreID , 1,dbo.GetLocalDATE())

		FETCH NEXT FROM j    --insert the next values to the instance
			INTO @ItemStoreID
		END

	CLOSE j
	DEALLOCATE j
	END

	--Adjust Inventory

	IF @AdjustQty IS NOT NULL AND @AdjustType IS NOT NULL AND @AdjustAccount IS NOT NULL AND @AdjustReason IS NOT NULL
	begin
		DECLARE k CURSOR FORWARD_ONLY STATIC OPTIMISTIC FOR
		SELECT     ItemStoreIDs.ItemStoreID
		FROM         ItemStoreIDs INNER JOIN
							  ItemMainAndStoreView ON ItemMainAndStoreView.ItemStoreID = ItemStoreIDs.ItemStoreID
		WHERE     (ItemMainAndStoreView.ItemType <> 2) AND (ItemStoreIDs.UserID = @ModifierID)

		OPEN k

		FETCH NEXT FROM k 
		INTO @ItemStoreID


		WHILE @@FETCH_STATUS = 0 BEGIN
			    exec SP_UpdateOnHandOneItem @ItemStoreID =@ItemStoreID 
				SET @OldQty=(Select OnHand From ItemStore Where ItemStoreID=@ItemStoreID)
				SET @Cost=(Select Cost From ItemStore Where ItemStoreID=@ItemStoreID)
			   INSERT INTO dbo.AdjustInventory
							(AdjustInventoryId, ItemStoreNo, Qty, OldQty, AdjustType, AdjustReason, AccountNo,Cost, Status, DateCreated, UserCreated, DateModified, UserModified)
				VALUES     (NEWID(), @ItemStoreID, @AdjustQty-@OldQty, @OldQty, @AdjustType, @AdjustReason, @AdjustAccount,@Cost, 1, dbo.GetLocalDATE(), @ModifierID, dbo.GetLocalDATE(), @ModifierID)

				UPDATE dbo.ItemStore
				 SET OnHand =@AdjustQty,  
					 DateModified=dbo.GetLocalDATE(),  
					 UserModified = @ModifierID
				WHERE ItemStoreId = @ItemStoreID

				SET @ID=(SELECT LinkNo  FROM dbo.ItemMainAndStoreView WHERE ItemStoreID = @ItemStoreID)

				IF   (@ID is not null)
				BEGIN
					UPDATE  dbo.ItemStore
					 SET  OnHand =(OnHand + @AdjustQty-@OldQty), 
						  DateModified = dbo.GetLocalDATE(),  
						  UserModified = @ModifierID
					WHERE  ItemStoreID IN (SELECT ItemStoreID  FROM dbo.ItemStore WHERE StoreNo=(Select StoreNo from  dbo.ItemStore 
										   where ItemStoreID=@ItemStoreID)  AND  (ItemNo = @ID))
				END

			FETCH NEXT FROM k    --insert the next values to the instance
				INTO @ItemStoreID
			END

		CLOSE k
		DEALLOCATE k
				
	END

	UPDATE ITEMSTORE SET DATEMODIFIED =dbo.GetLocalDATE() WHERE ItemStoreID IN(SELECT ItemStoreID FROM dbo.ItemStoreIDs)
	UPDATE ITEMMAIN SET DATEMODIFIED =dbo.GetLocalDATE() WHERE ItemID IN(SELECT ItemID FROM dbo.ItemStoreIDs)

--Alex Abreu
--12/16/2015
--Put it on comment because was deleting the records before other process end.
--DELETE FROM dbo.ItemStoreIDs WHERE UserID =@ModifierID
GO