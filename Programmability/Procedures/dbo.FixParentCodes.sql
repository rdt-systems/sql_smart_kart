SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[FixParentCodes]

AS
	BEGIN

	DELETE FROM ItemSupply
	WHERE ItemSupplyID IS NULL AND ISNULL(itemCode, '')=''
	DELETE FROM ItemSupply
	WHERE SupplierNo IS NULL

	DELETE f
	FROM (SELECT ROW_NUMBER() OVER (PARTITION BY SupplierNo, ItemStoreNo ORDER BY SupplierNo, ItemStoreNo) AS DupeCount
		FROM ItemSupply
		WHERE Status>0) AS f
	WHERE DupeCount > 1

	-- Insert Into ItemSupplier Table for all matrix item And All Stores
	INSERT INTO ItemSupply(ItemSupplyID, ItemStoreNo, SupplierNo, ItemCode, IsMainSupplier, SortOrder, Status, DateCreated)
	SELECT NEWID() AS ItemSupplyID, ItemMainAndStoreView.ItemStoreID, SupplyCode.SupplierNo, SupplyCode.ItemCode, 1 AS IsMainSupplier, 1 AS SortOrder, 7 AS Status, dbo.GetLocalDate() AS datecreated
	FROM ItemMainAndStoreView
		 LEFT OUTER JOIN (SELECT ItemSupply_2.SupplierNo, ItemMainAndStoreView_1.ItemID, ItemSupply_2.ItemCode
			 FROM ItemSupply AS ItemSupply_2
			 INNER JOIN ItemMainAndStoreView AS ItemMainAndStoreView_1 ON ItemSupply_2.ItemStoreNo = ItemMainAndStoreView_1.ItemStoreID
			 WHERE (ItemSupply_2.SupplierNo IS NOT NULL)) AS SupplyCode ON ItemMainAndStoreView.ItemID = SupplyCode.ItemID
	WHERE (ItemMainAndStoreView.ItemStoreID NOT IN (SELECT ItemStoreNo
		FROM ItemSupply AS ItemSupply_1
		WHERE (Status > 0))) AND (ItemMainAndStoreView.ItemType = 2) AND (SupplyCode.SupplierNo IS NOT NULL)

	--make it IsmainSupplier =1
	UPDATE ItemSupply
	SET IsMainSupplier=1, DateModified =dbo.GetLocalDate()
	WHERE ItemStoreNo NOT IN (SELECT ItemStoreNo
		FROM (SELECT ROW_NUMBER() OVER (PARTITION BY ItemStoreNo ORDER BY SupplierNo) AS DupeCount, ItemSupplyID, ItemStoreNo
			FROM ItemSupply
			WHERE Status>0) AS f
		WHERE DupeCount>1) AND ISNULL(IsMainSupplier, 0)<>1 AND Status  >0

	INSERT INTO itemstoreLog(ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost, datecreatedlog, step, MainSupplierIDValue)
	SELECT ItemStoreID, ItemNo, StoreNo, DepartmentID, IsDiscount, IsTaxable, TaxID, IsFoodStampable, IsWIC, Cost, ListPrice, Price, PriceA, PriceB, PriceC, PriceD, ExtraCharge1, ExtraCharge2, ExtraCharge3, CogsAccount, IncomeAccount, ProfitCalculation, CommissionQty, CommissionType, PrefSaleBy, PrefOrderBy, MainSupplierID, OnOrder, OnTransferOrder, OnHand, ReorderPoint, RestockLevel, BinLocation, OnWorkOrder, DaysForReturn, AVGCost, SaleType, SalePrice, SaleStartDate, SaleEndDate, SaleMin, SaleMax, MinForSale, SpecialBuy, SpecialPrice, SpecialBuyFromDate, SpecialBuyToDate, MixAndMatchID, AssignDate, Status, MTDQty, MTDDollar, PTDQty, PTDDollar, YTDQty, YTDDollar, MTDReturnQty, PTDReturnQty, YTDReturnQty, DateCreated, UserCreated, DateModified, UserModified, TDDate, TDReturnDate, NewPrice, NewPriceDate, SpecialsMemberOnly, CasePrice, CaseSpecial, PkgPrice, PkgQty, IsCaseDiscount, IsPkgDiscount, Tare, RegCost, LoyaltyGroupID, LoyaltyGroupFromDate, LoyaltyGroupToDate, VoidReason, LastCount, CountDate, CountOnHand, RegSalePrice, LastSoldDate, LastReceivedDate, LastReceivedQty, SpecialCost, NetCost, EstimatedCost, dbo.GetLocalDate(), 35, ItemSupply.ItemSupplyID
	FROM ItemStore
		 INNER JOIN (SELECT * 
			 FROM (SELECT ROW_NUMBER() OVER (PARTITION BY SupplierNo, ItemStoreNo ORDER BY SupplierNo, ItemStoreNo) AS DupeCount, ItemSupplyID, ItemStoreNo
				 FROM ItemSupply
				 WHERE Status>0) AS f
			 WHERE DupeCount = 1) AS ItemSupply ON ItemStore.ItemStoreID = ItemSupply.ItemStoreNo
	WHERE (ItemStore.ItemNo IN (SELECT ItemID
		FROM ItemMain
		WHERE (ItemType = 2)))


	-- Update Main SupplierID
	UPDATE ItemStore
	SET MainSupplierID = ItemSupply.ItemSupplyID
	FROM ItemStore
		INNER JOIN (SELECT * 
			FROM (SELECT ROW_NUMBER() OVER (PARTITION BY SupplierNo, ItemStoreNo ORDER BY SupplierNo, ItemStoreNo) AS DupeCount, ItemSupplyID, ItemStoreNo
				FROM ItemSupply
				WHERE Status>0) AS f
			WHERE DupeCount = 1) AS ItemSupply ON ItemStore.ItemStoreID = ItemSupply.ItemStoreNo
	WHERE (ItemStore.ItemNo IN (SELECT ItemID
		FROM ItemMain
		WHERE (ItemType = 2)))

	-- Update ItemCode where HAve Supplier and no code
	UPDATE ItemSupply
	SET ItemCode = WithCode.ItemCode, DateModified = dbo.GetLocalDate()
	FROM (SELECT ItemMainAndStoreView.ItemID, ItemSupplyCode.ItemCode, ItemMainAndStoreView.ItemStoreID
		FROM ItemMainAndStoreView
		INNER JOIN ItemSupply AS ItemSupplyCode ON ItemMainAndStoreView.ItemStoreID = ItemSupplyCode.ItemStoreNo
		WHERE (ISNULL(ItemSupplyCode.ItemCode, N'') <> '')) AS WithCode
		INNER JOIN (SELECT ItemMainAndStoreView_1.ItemID, ItemSupplyCode.ItemCode, ItemMainAndStoreView_1.ItemStoreID, ItemSupplyCode.ItemSupplyID
			FROM ItemMainAndStoreView AS ItemMainAndStoreView_1
			INNER JOIN ItemSupply AS ItemSupplyCode ON ItemMainAndStoreView_1.ItemStoreID = ItemSupplyCode.ItemStoreNo
			WHERE (ISNULL(ItemSupplyCode.ItemCode, N'') = '')) AS NoCode ON WithCode.ItemID = NoCode.ItemID
		INNER JOIN ItemSupply ON NoCode.ItemSupplyID = ItemSupply.ItemSupplyID
	END


-- update IsMainSupplier =0
UPDATE ItemSupply
SET IsMainSupplier =0

-- Update ItemSupply iaMainSupplier =1 where is link to itemStore
UPDATE ItemSupply
SET IsMainSupplier = 1
FROM ItemStore
	INNER JOIN ItemSupply ON ItemStore.MainSupplierID = ItemSupply.ItemSupplyID
GO