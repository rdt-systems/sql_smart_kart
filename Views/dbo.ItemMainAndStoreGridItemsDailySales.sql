﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemMainAndStoreGridItemsDailySales]
AS 

	SELECT  
		dbo.ItemMainView.ItemID,
		dbo.ItemMainView.LinkNo,
		dbo.ItemStoreView.StoreNo, 
		dbo.ItemStoreView.ItemStoreID, 
		dbo.ItemMainView.MatrixTableNo, 
		dbo.ItemMainView.CaseQty,
		dbo.ItemMainView.ModalNumber,
		dbo.ItemMainView.BarcodeNumber,
		DepartmentID, 
		dbo.DepartmentStore.[Status], 
		dbo.ItemMainView.Name,
		dbo.DepartmentStore.Name AS Department
		--, (CASE WHEN ((isnull(ItemStoreView.OnHand,0) + isnull(ItemStoreView.OnOrder,0) - isnull(ItemStoreView.OnWorkOrder,0) + isnull(ItemStoreView.OnTransferOrder,0)) < isnull(ItemStoreView.ReorderPoint,0)) AND ((ItemMainView.ItemType <> 3) AND (ItemMainView.ItemType <> 5)) THEN 1 ELSE 0 END) AS ToReorder, dbo.ItemMainView.ItemType, ItemStoreview.PrefOrderBy, dbo.ItemStoreView.Cost
		--, dbo.ItemStoreView.Price
		--, (CASE WHEN ItemMainView.CostByCase = 1 THEN ItemStoreView.Cost ELSE ItemStoreView.Cost * ItemMainView.CaseQty END) AS [Cs Cost], (CASE WHEN ItemMainView.CostByCase = 1 AND ItemMainView.CaseQty <> 0 THEN ItemStoreView.Cost / ItemMainView.CaseQty ELSE ItemStoreView.Cost END) AS [Pc Cost], (CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Cost <> 0 THEN (ItemStoreView.Price - ItemStoreView.Cost) 
		--                      / ItemStoreView.Cost * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 AND 
		--                      (ItemStoreView.Cost / ItemMainView.CaseQty) <> 0 THEN (ItemStoreView.Price - (ItemStoreView.Cost / ItemMainView.CaseQty)) 
		--                      / (ItemStoreView.Cost / ItemMainView.CaseQty) * 100 WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Cost <> 0 AND 
		--                      ItemMainView.CaseQty <> 0 THEN ((ItemStoreView.Price / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ItemStoreView.Cost) * 100 END) AS Markup, (CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Price <> 0 THEN (ItemStoreView.Price - ItemStoreView.Cost) 
		--                      / ItemStoreView.Price * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Price <> 0 AND 
		--                      ItemMainView.CaseQty <> 0 THEN (ItemStoreView.Price - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ItemStoreView.Price) 
		--                      * 100 WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Price <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ItemStoreView.Price / ItemMainView.CaseQty) 
		--                      - ItemStoreView.Cost) / (ItemStoreView.Price / ItemMainView.CaseQty) * 100 END) AS Margin, Cast(0.0 as money) as [SP Markup], Cast(0.0 as money) as [SP Margin], Cast(0.0 as money) as RegSPPrice, Cast(0.0 as money) as CaseSPPrice, Cast(0.0 as money) as [Reg SP Price Markup], Cast(0.0 as money) as [Reg SP Price Margin], Cast(0.0 as money) as [Pkg Price Markup], Cast(0.0 as money) as [Pkg Price Margin], Cast(0.0 as money) as MTD, Cast(0.0 as money) as YTD, Cast(0.0 as money) as PTD, Cast(0.0 as money) as AVGCost, Cast(0.0 as money) as RegCost, Cast(0.0 as money) as CasePrice, dbo.ItemStoreView.DateCreated, dbo.ItemStoreView.DateModified AS ItemStoreDateModified, dbo.ItemMainView.DateModified AS MainDateModified, Cast(dbo.GetLocalDATE() as datetime) as GroupDateModified, (CASE WHEN (ItemStoreView.SaleType > 0 AND ItemStoreView.SaleType <> 3) AND ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleStartDate WHEN ItemStoreView.SaleType = 3 THEN MixAndMatchView.StartDate END) AS [SP From],
		-- (CASE WHEN (ItemStoreView.SaleType > 0 AND ItemStoreView.SaleType <> 3) AND ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleEndDate WHEN ItemStoreView.SaleType
		-- = 3 THEN MixAndMatchView.EndDate END) AS [SP To], Cast(dbo.GetLocalDATE() as datetime) as [Future SP From], Cast(dbo.GetLocalDATE() as datetime) as [Future SP To],
		-- Cast(dbo.GetLocalDATE() as datetime) as DepartmentDateModified, Cast(0 as bit) as IsTaxable, Cast(0 as bit) as IsDiscount, Cast(0 as bit) as IsFoodStampable, Cast(0 as bit) as IsWIC, Cast(0 as bit) as PriceByCase, Cast(0 as bit) as CostByCase, ISNULL(dbo.ItemStoreView.OnHand
		--, 0) AS OnHand, Cast(0.0 as decimal(20,2)) as CsOnHand, ISNULL(dbo.ItemStoreView.MTDQty, 0) AS [MTD Pc Qty], Cast(0.0 as decimal(29,11)) as [MTD Cs Qty], Cast(0.0 as decimal(18,0)) as [YTD Pc Qty], Cast(0.0 as decimal(29,11)) as [YTD Cs Qty], Cast(0.0 as decimal(18,0)) as [PTD Pc Qty], Cast(0.0 as decimal(29,11)) as [PTD Cs Qty], ISNULL(dbo.ItemStoreView.OnOrder, 0) AS OnOrder, dbo.ItemStoreView.ReorderPoint, dbo.ItemStoreView.RestockLevel, Cast(0.0 as decimal(19,3)) as OnTransferOrder, 					  STUFF ((SELECT DISTINCT ',' + ig.ItemGroupName
		--                              FROM         dbo.ItemToGroup AS itg INNER JOIN
		--                                                    dbo.ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
		--                              WHERE     itg.ItemStoreID = ItemStoreView.ItemStoreID AND itg.Status > 0 FOR XML PATH(''), TYPE ).value('.', 'varchar(max)'), 1, 1, '') AS Groups, Cast('' as varchar(max)) as ItemAlias, ItemMainView.Name
		--, Cast('' as nvarchar(50)) as StyleNo, Cast('' as nvarchar(50)) as CaseBarcodeNumber, Cast('' as nvarchar(50)) as BinLocation, Cast('' as nvarchar(62)) as RegPkgPrice, Cast('' as nvarchar(50)) as MainDepartment, Cast('' as nvarchar(50)) as SubDepartment, Cast('' as nvarchar(50)) as SubSubDepartment,

		---- dbo.Manufacturers.ManufacturerName AS Brand, Cast('' as nvarchar(50)) as Size, Cast('' as nvarchar(50)) as ItemTypeName, Cast('' as nvarchar(50)) as BarcodeType, dbo.ItemMainView.CustomerCode, Cast('' as nvarchar(50)) as ParentCode, Cast('' as nvarchar(50)) as Matrix6, dbo.SupplierView.Name AS SupplierName
		--, Cast('' as nvarchar(50)) as ManufacturerPartNo

		--(CASE WHEN (ItemStoreView.SaleType IN (1, 5, 12)) 
							  --THEN CASE WHEN ISNULL(ItemStoreView.AssignDate, 0) > 0 THEN CASE WHEN (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) 
							 -- THEN CASE WHEN ISNULL(ItemStoreView.AssignDate, 0) > 0 THEN CASE WHEN ((ItemStoreView.SaleEndDate) >= (dbo.GetLocalDATE())) 
			   --               THEN '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) END ELSE '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) 
			   --               --END WHEN (ItemStoreView.SaleType IN (2, 6, 13)) AND ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND (dbo.GetDay(ItemStoreView.SaleEndDate)
							  --END WHEN (ItemStoreView.SaleType IN (2, 6, 13)) AND ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND ((ItemStoreView.SaleEndDate)  
			   --               -->= dbo.GetDay(dbo.GetLocalDATE())) OR
							  -->= (dbo.GetLocalDATE())) OR
			   --               (ISNULL(ItemStoreView.AssignDate, 0) = 0)) THEN CONVERT(nvarchar, ItemStoreView.SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, ItemStoreView.SpecialPrice, 110) 
			   --               WHEN ItemStoreView.SaleType = 3 THEN 'MIX ' + MixAndMatchView.Name + ' ' + CONVERT(nvarchar, MixAndMatchView.Qty, 110) + ' @ ' + CONVERT(nvarchar, 
			   --               MixAndMatchView.Amount, 110) WHEN (ItemStoreView.SaleType IN (4, 11, 18)) AND ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND 
			   --               (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
			   --               (ISNULL(ItemStoreView.AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) + ' , ' + CONVERT(nvarchar, ItemStoreView.SpecialBuy, 
			   --               110) + ' @ ' + CONVERT(nvarchar, ItemStoreView.SpecialPrice, 110) END) AS [SP Price], 
					  
							  --dbo.ItemHeadSupplierView.ItemCode AS [Supplier Item Code], Cast('' as nvarchar(100)) as [Future SP Price], dbo.DepartmentStore.Name AS Department, dbo.ItemMainView.Matrix1, dbo.ItemMainView.Matrix2, Cast('' as nvarchar(50)) as Matrix3, Cast('' as nvarchar(50)) as Matrix4, Cast('' as nvarchar(50)) as Matrix5 
					  

	FROM 
		dbo.DepartmentStore 
		RIGHT OUTER JOIN dbo.ItemStoreView
			ON dbo.DepartmentStore.DepartmentStoreID = dbo.ItemStoreView.DepartmentID AND dbo.DepartmentStore.Status >0 
		INNER JOIN dbo.ItemMainView 
			ON dbo.ItemStoreView.ItemNo = dbo.ItemMainView.ItemID 
		 --left OUTER JOIN dbo.ItemHeadSupplierView ON dbo.ItemHeadSupplierView.ItemSupplyID = dbo.ItemStoreView.MainSupplierID
		 --LEFT OUTER JOIN dbo.MixAndMatchView ON dbo.MixAndMatchView.MixAndMatchID = dbo.ItemStoreView.MixAndMatchID
		 --LEFT OUTER JOIN dbo.Manufacturers ON dbo.ItemMainView.ManufacturerID = dbo.Manufacturers.ManufacturerID
		 --LEFT OUTER JOIN dbo.SupplierView ON dbo.SupplierView.SupplierID = dbo.ItemHeadSupplierView.SupplierNo
GO