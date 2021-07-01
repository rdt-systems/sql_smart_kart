SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE  VIEW [dbo].[ItemMainAndStoreGrid]
AS
SELECT    distinct dbo.ItemMainView.ItemID, ItemMainView.Name,ItemMainView.Description, dbo.ItemMainView.ModalNumber, dbo.ItemMainView.LinkNo, dbo.ItemMainView.BarcodeNumber, ItemMainView.custominteger1,
                      dbo.ItemStoreView.StoreNo,store.StoreName,store.storeNumber, dbo.ItemStoreView.IsTaxable, dbo.ItemStoreView.IsDiscount, dbo.ItemStoreView.IsFoodStampable, dbo.ItemStoreView.IsWIC, 
                      dbo.ItemStoreView.Cost, dbo.ItemStoreView.Price, dbo.ItemMainView.CaseQty, dbo.ItemMainView.PriceByCase, dbo.ItemMainView.StyleNo, 
                      dbo.ItemMainView.CostByCase, dbo.ItemMainView.CaseBarcodeNumber, dbo.ItemStoreView.OnHand, CAST(CASE WHEN ISNULL(ItemMainView.CaseQty, 1) > 0 AND 
                      (ISNULL(dbo.ItemStoreView.OnHand, 1) <> 0) THEN ISNULL(dbo.ItemStoreView.OnHand, 1) / ISNULL(ItemMainView.CaseQty, 1) 
                      ELSE dbo.ItemStoreView.OnHand END AS decimal(20, 2)) AS CsOnHand, dbo.ItemStoreView.BinLocation, dbo.ItemStoreView.Status, ISNULL(dbo.ItemStoreView.DateCreated,dbo.GetLocalDate()) AS DateCreated, 
                      dbo.ItemStoreView.DateModified AS ItemStoreDateModified, dbo.ItemMainView.DateModified AS MainDateModified, 
                      (CASE WHEN ItemMainView.CostByCase = 1 THEN ItemStoreView.Cost ELSE ItemStoreView.Cost * ItemMainView.CaseQty END) AS [Cs Cost], 
                      (CASE WHEN ItemMainView.CostByCase = 1 AND ItemMainView.CaseQty <> 0 THEN ItemStoreView.Cost / ItemMainView.CaseQty ELSE ItemStoreView.Cost END) 
                      AS [Pc Cost], dbo.ItemMainView.Status AS MainStatus, dbo.ItemStoreView.ItemStoreID, dbo.DepartmentStore.Name AS Department, dbo.ItemMainView.Matrix1, 
                      dbo.ItemMainView.Matrix2, dbo.ItemMainView.Matrix3, dbo.ItemMainView.Matrix4, dbo.ItemMainView.Matrix5, dbo.ItemMainView.Matrix6, 
                      dbo.SupplierView.Name AS SupplierName, ItemMainView.ManufacturerPartNo, dbo.ItemStoreView.ListPrice,
					  --SP Price
					  (CASE WHEN (ItemStoreView.SaleType IN (1, 5, 12)) 
                      THEN CASE WHEN ISNULL(ItemStoreView.AssignDate, 0) > 0 THEN CASE WHEN (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) 
                      THEN '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) END ELSE '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) 
                      END WHEN (ItemStoreView.SaleType IN (2, 6, 13)) AND ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND (dbo.GetDay(ItemStoreView.SaleEndDate) 
                      >= dbo.GetDay(dbo.GetLocalDATE())) OR
                      (ISNULL(ItemStoreView.AssignDate, 0) = 0)) THEN CONVERT(nvarchar, ItemStoreView.SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, ItemStoreView.SpecialPrice, 110) 
                      WHEN ItemStoreView.SaleType = 3 THEN 'MIX ' + MixAndMatchView.Name + ' ' + CONVERT(nvarchar, MixAndMatchView.Qty, 110) + ' @ ' + CONVERT(nvarchar, 
                      MixAndMatchView.Amount, 110) WHEN (ItemStoreView.SaleType IN (4, 11, 18)) AND ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND 
                      (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                      (ISNULL(ItemStoreView.AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) + ' , ' + CONVERT(nvarchar, ItemStoreView.SpecialBuy, 
                      110) + ' @ ' + CONVERT(nvarchar, ItemStoreView.SpecialPrice, 110) END) AS [SP Price],
					   dbo.ItemHeadSupplierView.ItemCode AS [Supplier Item Code], 
                      Groups1.DateModified AS GroupDateModified, 
					  --SP From / SP To
					  (CASE WHEN (ItemStoreView.SaleType > 0 AND ItemStoreView.SaleType <> 3) AND 
                      ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleStartDate WHEN ItemStoreView.SaleType = 3 THEN MixAndMatchView.StartDate END) AS [SP From], 
                      (CASE WHEN (ItemStoreView.SaleType > 0 AND ItemStoreView.SaleType <> 3) AND 
                      ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleEndDate WHEN ItemStoreView.SaleType = 3 THEN MixAndMatchView.EndDate END) AS [SP To], 
					   --Future Sales
					  (CASE WHEN (ItemSpecialView.SaleType IN (1, 5, 12)) 
                      THEN CASE WHEN ISNULL(ItemSpecialView.AssignDate, 0) > 0 THEN CASE WHEN (dbo.GetDay(ItemSpecialView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) 
                      THEN '1 @ ' + CONVERT(nvarchar, ItemSpecialView.SalePrice, 110) END ELSE '1 @ ' + CONVERT(nvarchar, ItemSpecialView.SalePrice, 110) 
                      END WHEN (ItemSpecialView.SaleType IN (2, 6, 13)) AND ((ISNULL(ItemSpecialView.AssignDate, 0) > 0) AND (dbo.GetDay(ItemSpecialView.SaleEndDate) 
                      >= dbo.GetDay(dbo.GetLocalDATE())) OR
                      (ISNULL(ItemSpecialView.AssignDate, 0) = 0)) THEN CONVERT(nvarchar, ItemSpecialView.SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, ItemSpecialView.SpecialPrice, 110) 
                      WHEN (ItemSpecialView.SaleType IN (4, 11, 18)) AND ((ISNULL(ItemSpecialView.AssignDate, 0) > 0) AND 
                      (dbo.GetDay(ItemSpecialView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                      (ISNULL(ItemSpecialView.AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(nvarchar, ItemSpecialView.SalePrice, 110) + ' , ' + CONVERT(nvarchar, ItemSpecialView.SpecialBuy, 
                      110) + ' @ ' + CONVERT(nvarchar, ItemSpecialView.SpecialPrice, 110) END) AS [Future SP Price],
					  (CASE WHEN (ItemSpecialView.SaleType > 0 AND ItemSpecialView.SaleType <> 3) AND 
                      ItemSpecialView.AssignDate = 1 THEN ItemSpecialView.SaleStartDate END) AS [Future SP From], 
                      (CASE WHEN (ItemSpecialView.SaleType > 0 AND ItemSpecialView.SaleType <> 3) AND 
                      ItemSpecialView.AssignDate = 1 THEN ItemSpecialView.SaleEndDate  END) AS [Future SP To], 
                      --Markup
					  ROUND(CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Cost <> 0 THEN ROUND(ItemStoreView.Price - ItemStoreView.Cost,2) 
                      / ItemStoreView.Cost * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 AND 
                      ROUND(ItemStoreView.Cost / ItemMainView.CaseQty,2) <> 0 THEN ROUND(ItemStoreView.Price - ROUND(ItemStoreView.Cost / ItemMainView.CaseQty,2),2) 
                      / ROUND(ItemStoreView.Cost / ItemMainView.CaseQty,2) * 100 WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Cost <> 0 AND 
                      ItemMainView.CaseQty <> 0 THEN ROUND((ItemStoreView.Price / ItemMainView.CaseQty) - ItemStoreView.Cost,2) / (ItemStoreView.Cost) * 100 END,2) AS Markup, 
					  --List Price Markdown
					  (CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Cost <> 0 AND ItemStoreView.ListPrice <>0 THEN (1 - ItemStoreView.Price / ItemStoreView.ListPrice) 
                       * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 AND 
                      (ItemStoreView.Cost / ItemMainView.CaseQty) <> 0  AND ItemStoreView.ListPrice <>0  THEN (1 - ItemStoreView.Price / ItemStoreView.ListPrice) * 100 
					  WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0  AND ItemStoreView.ListPrice <>0  THEN 
					  (1 - ItemStoreView.Price / ItemStoreView.ListPrice) * 100  END) AS Markdown,
					  --List Price Markup
					  (CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Cost <> 0 AND ItemStoreView.ListPrice <>0 THEN (ItemStoreView.ListPrice - ItemStoreView.Cost) 
                      / ItemStoreView.Cost * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 AND 
                      (ItemStoreView.Cost / ItemMainView.CaseQty) <> 0  AND ItemStoreView.ListPrice <>0  THEN (ItemStoreView.ListPrice - (ItemStoreView.Cost / ItemMainView.CaseQty)) 
                      / (ItemStoreView.Cost / ItemMainView.CaseQty) * 100 WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Cost <> 0 AND 
                      ItemMainView.CaseQty <> 0  AND ItemStoreView.ListPrice <>0  THEN ((ItemStoreView.ListPrice / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ItemStoreView.Cost) * 100 END) AS ListPriceMarkup, 
                      --Margin
					  (CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Price <> 0 THEN (ItemStoreView.Price - ItemStoreView.Cost) 
                      / ItemStoreView.Price * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Price <> 0 AND 
                      ItemMainView.CaseQty <> 0 THEN (ItemStoreView.Price - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ItemStoreView.Price) 
                      * 100 WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Price <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ItemStoreView.Price / ItemMainView.CaseQty) 
                      - ItemStoreView.Cost) / (ItemStoreView.Price / ItemMainView.CaseQty) * 100 END) AS Margin,
					  
					   ISNULL(dbo.ItemStoreView.MTDDollar, 0) AS MTD, 
                      ISNULL(dbo.ItemStoreView.MTDQty, 0) AS [MTD Pc Qty], 
                      (CASE WHEN dbo.ItemMainView.CaseQty <> 0 THEN dbo.ItemStoreView.MTDQty / dbo.ItemMainView.CaseQty END) AS [MTD Cs Qty], 
                      ISNULL(dbo.ItemStoreView.YTDDollar, 0) AS YTD, ISNULL(dbo.ItemStoreView.YTDQty, 0) AS [YTD Pc Qty], 
                      (CASE WHEN dbo.ItemMainView.CaseQty <> 0 THEN dbo.ItemStoreView.YTDQty / dbo.ItemMainView.CaseQty END) AS [YTD Cs Qty], 
                      ISNULL(dbo.ItemStoreView.PTDDollar, 0) AS PTD, ISNULL(dbo.ItemStoreView.PTDQty, 0) AS [PTD Pc Qty], ItemMainView.MatrixTableNo, 
                      (CASE WHEN dbo.ItemMainView.CaseQty <> 0 THEN dbo.ItemStoreView.PTDQty / dbo.ItemMainView.CaseQty END) AS [PTD Cs Qty], dbo.ItemStoreView.ItemNo, 
                      dbo.Manufacturers.ManufacturerName AS Brand, 
					  dbo.ItemMainView.ManufacturerID,
                      (CASE WHEN ((ItemStoreView.OnHand + ItemStoreView.OnOrder - ItemStoreView.OnWorkOrder + ItemStoreView.OnTransferOrder) < ItemStoreView.ReorderPoint) AND 
                      (ItemMainView.ItemType <> 3) AND (ItemMainView.ItemType <> 5) THEN 1 ELSE 0 END) AS ToReorder, dbo.ItemMainView.Size, 
                      dbo.DepartmentStore.DateModified AS DepartmentDateModified, dbo.ItemMainView.ItemType, dbo.ItemStoreView.DepartmentID, 
                      dbo.SysItemTypeView.SystemValueName AS ItemTypeName, dbo.SysBarcodeTypeView.SystemValueName AS BarcodeType, dbo.ItemStoreView.OnOrder, 
                      dbo.ItemStoreView.AVGCost, (CASE WHEN ISNULL(ItemStoreView.RegCost, 0) > 0 THEN ItemStoreView.RegCost ELSE (CASE WHEN (ItemMainView.CostByCase = 1 OR
                      ItemMainView.CostByCase = 0 or ItemMainView.CostByCase is null) THEN ItemStoreView.Cost ELSE ItemStoreView.Cost * ItemMainView.CaseQty END) END) AS RegCost, dbo.ItemStoreView.ReorderPoint, 
                      dbo.ItemHeadSupplierView.SupplierNo AS MainSupplierID, dbo.ItemStoreView.RestockLevel, dbo.ItemStoreView.CasePrice, dbo.ItemMainView.CustomerCode, 
                      dbo.ItemStoreView.OnTransferOrder, dbo.ItemMainView.PkgCode,
					 (SELECT        STRING_AGG(ig.ItemGroupName, ',') AS Expr1
                               FROM            ItemToGroup AS itg INNER JOIN
                                                         ItemGroup AS ig ON itg.ItemGroupID = ig.ItemGroupID
                               WHERE        (itg.ItemStoreID = ItemStoreView.ItemStoreID) AND (itg.Status > 0)) AS Groups,
                             (SELECT        STRING_AGG(BarcodeNumber, ',') AS Expr1
                               FROM            ItemAlias AS ia
                               WHERE        (ItemNo = ItemStoreView.ItemNo) AND (Status > 0)) AS ItemAlias,
                      '' AS ParentCode, ItemStoreView.SalePrice AS RegSPPrice, ItemStoreView.CaseSpecial AS CaseSPPrice, 
					   (CONVERT(nvarchar, ItemStoreView.PkgQty, 110) + '@ ' + CONVERT(nvarchar, ISNULL(ItemStoreView.PkgPrice, 0), 110)) AS RegPkgPrice, 
					  --Reg SP Price Markup
					   IsNull((CASE WHEN ISNULL(ItemStoreView.SalePrice, 0) = 0 OR
                      ISNULL(ItemStoreView.Cost, 0) = 0 THEN 0 WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND 
                      ItemStoreView.Cost <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) - ItemStoreView.Cost) / ItemStoreView.Cost * 100 WHEN ItemMainView.CostByCase = 1 AND 
                      ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 AND (ItemStoreView.Cost / ItemMainView.CaseQty) <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) 
                      - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ItemStoreView.Cost / ItemMainView.CaseQty) * 100 WHEN ItemMainView.CostByCase = 0 AND 
                      ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ISNULL(ItemStoreView.SalePrice, 0) / ItemMainView.CaseQty) - ItemStoreView.Cost) 
                      / (ItemStoreView.Cost) * 100 END), 0) AS [Reg SP Price Markup],
					  --Reg SP Price Margin
					   IsNull((CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND 
                      ISNULL(ItemStoreView.SalePrice, 0) <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) - ItemStoreView.Cost) 
                      / ItemStoreView.SalePrice * 100 WHEN ItemMainView.CostByCase = 1 AND ISNULL(ItemStoreView.SalePrice, 0) <> 0 AND 
                      ItemMainView.CaseQty <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ISNULL(ItemStoreView.SalePrice, 0)) 
                      * 100 WHEN ItemMainView.CostByCase = 0 AND ISNULL(ItemStoreView.SalePrice, 0) <> 0 AND 
                      ItemMainView.CaseQty <> 0 THEN ((ISNULL(ItemStoreView.SalePrice, 0) / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ISNULL(ItemStoreView.SalePrice, 0) 
                      / ItemMainView.CaseQty) * 100 END), 0) AS [Reg SP Price Margin],
					  --Pkg Price Markup
					   (CASE WHEN (ISNULL(ItemStoreView.PkgPrice, 0) = 0 OR
                      ISNULL(ItemStoreView.PkgQty, 0) = 0) THEN 0 WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND 
                      ItemStoreView.Cost <> 0 THEN ((ISNULL(ItemStoreView.PkgPrice, 0) / ISNULL(ItemStoreView.PkgQty, 0)) - ItemStoreView.Cost) 
                      / ItemStoreView.Cost * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 AND 
                      (ItemStoreView.Cost / ItemMainView.CaseQty) <> 0 THEN ((ISNULL(ItemStoreView.PkgPrice, 0) / ISNULL(ItemStoreView.PkgQty, 0)) 
                      - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ItemStoreView.Cost / ItemMainView.CaseQty) * 100 WHEN ItemMainView.CostByCase = 0 AND 
                      ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 THEN (((ISNULL(ItemStoreView.PkgPrice, 0) / ISNULL(ItemStoreView.PkgQty, 0)) / ItemMainView.CaseQty) 
                      - ItemStoreView.Cost) / (ItemStoreView.Cost) * 100 END) AS [Pkg Price Markup],
					  --Pkg Price Margin
					   (CASE WHEN (ISNULL(ItemStoreView.PkgPrice, 0) = 0 OR
                      ISNULL(ItemStoreView.PkgQty, 0) = 0) THEN 0 WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND (ISNULL(ItemStoreView.PkgPrice, 0) 
                      / ISNULL(ItemStoreView.PkgQty, 0)) <> 0 THEN ((ISNULL(ItemStoreView.PkgPrice, 0) / ISNULL(ItemStoreView.PkgQty, 0)) - ItemStoreView.Cost) 
                      / (ISNULL(ItemStoreView.PkgPrice, 0) / ISNULL(ItemStoreView.PkgQty, 0)) * 100 WHEN ItemMainView.CostByCase = 1 AND (ISNULL(ItemStoreView.PkgPrice, 0) 
                      / ISNULL(ItemStoreView.PkgQty, 0)) <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ISNULL(ItemStoreView.PkgPrice, 0) / ISNULL(ItemStoreView.PkgQty, 0)) 
                      - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ISNULL(ItemStoreView.PkgPrice, 0) / ISNULL(ItemStoreView.PkgQty, 0)) 
                      * 100 WHEN ItemMainView.CostByCase = 0 AND (ISNULL(ItemStoreView.PkgPrice, 0) / ISNULL(ItemStoreView.PkgQty, 0)) <> 0 AND 
                      ItemMainView.CaseQty <> 0 THEN (((ISNULL(ItemStoreView.PkgPrice, 0) / ISNULL(ItemStoreView.PkgQty, 0)) / ItemMainView.CaseQty) - ItemStoreView.Cost) 
                      / ((ISNULL(ItemStoreView.PkgPrice, 0) / ISNULL(ItemStoreView.PkgQty, 0)) / ItemMainView.CaseQty) * 100 END) AS [Pkg Price Margin], 
					  --SP Markup
                      ISNULL((CASE WHEN ItemStoreView.SaleType IN (1, 5, 4, 12) THEN 
					  (IsNull((CASE WHEN ISNULL(ItemStoreView.SalePrice, 0) = 0 OR ISNULL(ItemStoreView.Cost, 0) = 0 
					  THEN 0 WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ISNULL(ItemStoreView.Cost, 0) 
                      <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) - ISNULL(ItemStoreView.Cost, 0)) / ISNULL(ItemStoreView.Cost, 0) * 100 WHEN ItemMainView.CostByCase = 1 AND 
                      ISNULL(ItemStoreView.Cost, 0) <> 0 AND ISNULL(ItemMainView.CaseQty, 0) <> 0 AND ISNULL((ItemStoreView.Cost / ItemMainView.CaseQty), 0) 
                      <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) - (ISNULL(ItemStoreView.Cost, 0) / ISNULL(ItemMainView.CaseQty, 0))) / (ItemStoreView.Cost / ItemMainView.CaseQty) 
                      * 100 WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ISNULL(ItemStoreView.SalePrice, 0) 
                      / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ItemStoreView.Cost) * 100 END), 0)) 
					  WHEN ItemStoreView.SaleType IN (2, 6, 13, 3, 11, 18) THEN (CASE WHEN (ISNULL(ItemStoreView.SpecialPrice, 0) = 0 OR
                      ISNULL(ItemStoreView.SpecialBuy, 0) = 0) THEN 0 WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ISNULL(ItemStoreView.Cost, 0) 
                      <> 0 THEN ((ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) - ISNULL(ItemStoreView.Cost, 0)) / ISNULL(ItemStoreView.Cost, 0) 
                      * 100 WHEN ItemMainView.CostByCase = 1 AND ISNULL(ItemStoreView.Cost, 0) <> 0 AND ISNULL(ItemMainView.CaseQty, 0) <> 0 AND 
                      ISNULL((ItemStoreView.Cost / ItemMainView.CaseQty), 0) <> 0 THEN ((ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) 
                      - ISNULL((ItemStoreView.Cost / ItemMainView.CaseQty), 0)) / ISNULL((ItemStoreView.Cost / ItemMainView.CaseQty), 0) * 100 WHEN ItemMainView.CostByCase = 0 AND 
                      ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 THEN (((ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) 
                      / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ItemStoreView.Cost) * 100 END) ELSE 0 END), 0) AS [SP Markup], 
					  --SP Margin
					  (CASE WHEN ItemStoreView.SaleType IN (1, 5, 4, 12) 
                      THEN (IsNull((CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ISNULL(ItemStoreView.SalePrice, 0) 
                      <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) - ItemStoreView.Cost) / ItemStoreView.SalePrice * 100 WHEN ItemMainView.CostByCase = 1 AND 
                      ISNULL(ItemStoreView.SalePrice, 0) <> 0 AND ItemMainView.CaseQty <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) - (ItemStoreView.Cost / ItemMainView.CaseQty)) 
                      / (ISNULL(ItemStoreView.SalePrice, 0)) * 100 WHEN ItemMainView.CostByCase = 0 AND ISNULL(ItemStoreView.SalePrice, 0) <> 0 AND 
                      ItemMainView.CaseQty <> 0 THEN ((ISNULL(ItemStoreView.SalePrice, 0) / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ISNULL(ItemStoreView.SalePrice, 0) 
                      / ItemMainView.CaseQty) * 100 END), 0)) WHEN ItemStoreView.SaleType IN (2, 6, 13, 3, 11, 18) THEN ((CASE WHEN (ISNULL(ItemStoreView.SpecialPrice, 0) = 0 OR
                      ISNULL(ItemStoreView.SpecialBuy, 0) = 0) THEN 0 WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND (ISNULL(ItemStoreView.SpecialPrice, 0) 
                      / ISNULL(ItemStoreView.SpecialBuy, 0)) <> 0 THEN ((ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) - ItemStoreView.Cost) 
                      / (ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) * 100 WHEN ItemMainView.CostByCase = 1 AND 
                      (ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ISNULL(ItemStoreView.SpecialPrice, 0) 
                      / ISNULL(ItemStoreView.SpecialBuy, 0)) - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 
                      0)) * 100 WHEN ItemMainView.CostByCase = 0 AND (ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) <> 0 AND 
                      ItemMainView.CaseQty <> 0 THEN (((ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) / ItemMainView.CaseQty) - ItemStoreView.Cost) 
                      / ((ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) / ItemMainView.CaseQty) * 100 END)) ELSE 0 END) AS [SP Margin], 

					  dbo.Season.Name AS SeasonName,
					  dbo.ItemMainView.SeasonID,
					

                      '' AS MainDepartment, '' AS SubDepartment, '' AS SubSubDepartment,
					  (case ItemStoreview.PrefOrderBy when 0 then 'Pieces' when 1 then 'Dozens' when 2 then 'Cases' when 3 then 'Lb' else 'Pieces' end) as PrefOrderBy, (case ItemStoreview.PrefSaleBy when 0 then 'Pieces' when 1 then 'Dozens' when 2 then 'Cases' when 3 then 'Lb' else 'Pieces' end) as PrefSaleBy,
ItemStoreView.netcost ,
ItemStoreView.specialcost,
 '' AS CustomField1, '' AS CustomField2, '' AS CustomField3, '' AS CustomField4, '' AS CustomField5, '' AS CustomField6, '' AS CustomField7, 
                         '' AS CustomField8, '' AS CustomField9, '' AS CustomField10, '' AS extName,
case when ISNULL(ItemMainView.PriceByCase,0) = 1 Then ItemMainView.BarcodeNumber ELSE ItemMainView.CaseBarcodeNumber END AS CaseCode,
ItemStoreView.LastReceivedDate,
ItemStoreView.LastReceivedQty,
 ItemStoreView.WebPrice,ItemStoreView.WebCasePrice,ItemStoreView.SellOnWeb,
 ISNULL(dbo.ItemStoreView.YTDQty1, 0) AS [YTDPcQty1],
 ISNULL(dbo.ItemStoreView.YTDQty2, 0) AS [YTDPcQty2],
 ISNULL(dbo.ItemStoreView.YTDQty3, 0) AS [YTDPcQty3],
 ItemStoreView.PriceA,
 ItemStoreView.PriceB,
 ItemStoreView.PriceC,
 ItemStoreView.PriceD,
 ItemStoreView.LastSoldUser,ItemStoreView.LastSoldQty,ItemStoreView.LastReceivedUser,ItemStoreView.TotalSold,ItemStoreView.TotalReceive,ItemStoreView.TotalProfit, ISNULL(ItemStoreView.OnRequest,0) AS OnRequest, ISNULL(ItemStoreView.Reserved,0) AS Reserved
FROM            dbo.DepartmentStore RIGHT OUTER JOIN
                          dbo.ItemStoreView INNER JOIN
                          dbo.ItemMainView ON ItemStoreView.ItemNo = ItemMainView.ItemID LEFT OUTER JOIN
                          dbo.ItemHeadSupplierView ON ItemHeadSupplierView.ItemSupplyID = ItemStoreView.MainSupplierID LEFT OUTER JOIN
                          dbo.MixAndMatchView ON MixAndMatchView.MixAndMatchID = ItemStoreView.MixAndMatchID LEFT OUTER JOIN
                          dbo.SupplierView ON SupplierView.SupplierID = ItemHeadSupplierView.SupplierNo LEFT OUTER JOIN
                             (SELECT        ItemStoreID, MAX(DateModified) AS DateModified
                               FROM             dbo.ItemToGroup
                               GROUP BY ItemStoreID) AS Groups1 ON Groups1.ItemStoreID = ItemStoreView.ItemStoreID LEFT OUTER JOIN
                          dbo.ItemSpecialView ON ItemStoreView.ItemStoreID = ItemSpecialView.ItemStoreID LEFT OUTER JOIN
                          dbo.Manufacturers ON ItemMainView.ManufacturerID = Manufacturers.ManufacturerID LEFT OUTER JOIN
                          dbo.SysItemTypeView ON ItemMainView.ItemType = SysItemTypeView.SystemValueNo LEFT OUTER JOIN
                          dbo.SysBarcodeTypeView ON ItemMainView.BarcodeType = SysBarcodeTypeView.SystemValueNo LEFT OUTER JOIN
                          dbo.Season ON ItemMainView.SeasonID = Season.SeasonId INNER JOIN
                          dbo.Store ON Store.StoreID = ItemStoreView.StoreNo AND Store.Status > 0 ON DepartmentStore.DepartmentStoreID = ItemStoreView.DepartmentID AND DepartmentStore.Status > 0
GO