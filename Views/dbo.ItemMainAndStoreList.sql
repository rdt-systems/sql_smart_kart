SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO





CREATE  VIEW [dbo].[ItemMainAndStoreList]
    
AS
SELECT        ItemMainView.ItemID, ItemMainView.Name, ItemMainView.ModalNumber, ItemMainView.PkgCode, ItemStoreView.PkgQty, ItemStoreView.PkgPrice, ItemMainView.LinkNo, ItemMainView.BarcodeNumber, ItemMainView.CustomInteger1, ItemStoreView.StoreNo, Store.StoreName, Store.StoreNumber, 
                         ItemStoreView.IsTaxable, ItemStoreView.IsDiscount, ItemStoreView.IsFoodStampable, ItemStoreView.IsWIC, ItemStoreView.Cost, ItemStoreView.Price, ItemMainView.CaseQty, ItemMainView.PriceByCase, ItemMainView.StyleNo, 
                         ItemMainView.CostByCase, ItemMainView.CaseBarcodeNumber, ItemStoreView.OnHand, CAST(CASE WHEN ISNULL(ItemMainView.CaseQty, 1) > 0 AND (ISNULL(ItemStoreView.OnHand, 1) <> 0) 
                         THEN ISNULL(ItemStoreView.OnHand, 1) / ISNULL(ItemMainView.CaseQty, 1) ELSE ItemStoreView.OnHand END AS decimal(20, 2)) AS CsOnHand, ItemStoreView.BinLocation, ItemStoreView.Status, 
                         ItemStoreView.DateCreated, ItemStoreView.DateModified AS ItemStoreDateModified, ItemMainView.DateModified AS MainDateModified, 
                         (CASE WHEN ItemMainView.CostByCase = 1 THEN ItemStoreView.Cost ELSE ItemStoreView.Cost * ItemMainView.CaseQty END) AS [Cs Cost], (CASE WHEN ItemMainView.CostByCase = 1 AND 
                         ItemMainView.CaseQty <> 0 THEN ItemStoreView.Cost / ItemMainView.CaseQty ELSE ItemStoreView.Cost END) AS [Pc Cost], ItemMainView.Status AS MainStatus, ItemStoreView.ItemStoreID, 
                         DepartmentStore.Name AS Department, ItemMainView.Matrix1, ItemMainView.Matrix2, ItemMainView.Matrix3, ItemMainView.Matrix4, ItemMainView.Matrix5, ItemMainView.Matrix6, SupplierView.Name AS SupplierName, 
                         ItemMainView.ManufacturerPartNo, ItemStoreView.ListPrice, (CASE WHEN (ItemStoreView.SaleType IN (1, 5, 12)) THEN CASE WHEN ISNULL(ItemStoreView.AssignDate, 0) 
                         > 0 THEN CASE WHEN (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) THEN '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) END ELSE '1 @ ' + CONVERT(nvarchar, 
                         ItemStoreView.SalePrice, 110) END WHEN (ItemStoreView.SaleType IN (2, 6, 13)) AND ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                         (ISNULL(ItemStoreView.AssignDate, 0) = 0)) THEN CONVERT(nvarchar, ItemStoreView.SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, ItemStoreView.SpecialPrice, 110) WHEN (ItemStoreView.SaleType IN (4, 11, 18)) AND 
                         ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                         (ISNULL(ItemStoreView.AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) + ' , ' + CONVERT(nvarchar, ItemStoreView.SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, ItemStoreView.SpecialPrice,
                          110) END) AS [SP Price], ItemHeadSupplierView.ItemCode AS [Supplier Item Code], NULL AS GroupDateModified, (CASE WHEN (ItemStoreView.SaleType > 0 AND ItemStoreView.SaleType <> 3) AND 
                         ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleStartDate END) AS [SP From], (CASE WHEN (ItemStoreView.SaleType > 0 AND ItemStoreView.SaleType <> 3) AND 
                         ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleEndDate END) AS [SP To], NULL AS [Future SP Price], NULL AS [Future SP From], NULL AS [Future SP To], 
                         ROUND(CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Cost <> 0 THEN ROUND(ItemStoreView.Price - ItemStoreView.Cost, 2) 
                         / ItemStoreView.Cost * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 AND ROUND(ItemStoreView.Cost / ItemMainView.CaseQty, 2) 
                         <> 0 THEN ROUND(ItemStoreView.Price - ROUND(ItemStoreView.Cost / ItemMainView.CaseQty, 2), 2) / ROUND(ItemStoreView.Cost / ItemMainView.CaseQty, 2) * 100 WHEN ItemMainView.CostByCase = 0 AND 
                         ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 THEN ROUND((ItemStoreView.Price / ItemMainView.CaseQty) - ItemStoreView.Cost, 2) / (ItemStoreView.Cost) * 100 END, 2) AS Markup, NULL AS Markdown, 
                         (CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Cost <> 0 AND ItemStoreView.ListPrice <> 0 THEN (ItemStoreView.ListPrice - ItemStoreView.Cost) 
                         / ItemStoreView.Cost * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 AND (ItemStoreView.Cost / ItemMainView.CaseQty) <> 0 AND 
                         ItemStoreView.ListPrice <> 0 THEN (ItemStoreView.ListPrice - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ItemStoreView.Cost / ItemMainView.CaseQty) * 100 WHEN ItemMainView.CostByCase = 0 AND 
                         ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 AND ItemStoreView.ListPrice <> 0 THEN ((ItemStoreView.ListPrice / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ItemStoreView.Cost) * 100 END) AS ListPriceMarkup, 
                         (CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Price <> 0 THEN (ItemStoreView.Price - ItemStoreView.Cost) / ItemStoreView.Price * 100 WHEN ItemMainView.CostByCase = 1 AND 
                         ItemStoreView.Price <> 0 AND ItemMainView.CaseQty <> 0 THEN (ItemStoreView.Price - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ItemStoreView.Price) * 100 WHEN ItemMainView.CostByCase = 0 AND 
                         ItemStoreView.Price <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ItemStoreView.Price / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ItemStoreView.Price / ItemMainView.CaseQty) * 100 END) AS Margin, 
                         ISNULL(ItemStoreView.MTDDollar, 0) AS MTD, ISNULL(ItemStoreView.MTDQty, 0) AS [MTD Pc Qty], (CASE WHEN ItemMainView.CaseQty <> 0 THEN ItemStoreView.MTDQty / ItemMainView.CaseQty END) 
                         AS [MTD Cs Qty], ISNULL(ItemStoreView.YTDDollar, 0) AS YTD, ISNULL(ItemStoreView.YTDQty, 0) AS [YTD Pc Qty], 
                         (CASE WHEN ItemMainView.CaseQty <> 0 THEN ItemStoreView.YTDQty / ItemMainView.CaseQty END) AS [YTD Cs Qty], ISNULL(ItemStoreView.PTDDollar, 0) AS PTD, ISNULL(ItemStoreView.PTDQty, 0) 
                         AS [PTD Pc Qty], ItemMainView.MatrixTableNo, (CASE WHEN ItemMainView.CaseQty <> 0 THEN ItemStoreView.PTDQty / ItemMainView.CaseQty END) AS [PTD Cs Qty], ItemStoreView.ItemNo, 
                         Manufacturers.ManufacturerName AS Brand, ItemMainView.ManufacturerID, (CASE WHEN ((ItemStoreView.OnHand + ItemStoreView.OnOrder - ItemStoreView.OnWorkOrder + ItemStoreView.OnTransferOrder) 
                         < ItemStoreView.ReorderPoint) AND (ItemMainView.ItemType <> 3) AND (ItemMainView.ItemType <> 5) THEN 1 ELSE 0 END) AS ToReorder, ItemMainView.Size, DepartmentStore.DateModified AS DepartmentDateModified, 
                         ItemMainView.ItemType, ItemStoreView.DepartmentID, SysItemTypeView.SystemValueName AS ItemTypeName, SysBarcodeTypeView.SystemValueName AS BarcodeType, ItemStoreView.OnOrder, ItemStoreView.AVGCost, 
                         (CASE WHEN ISNULL(ItemStoreView.RegCost, 0) > 0 THEN ItemStoreView.RegCost ELSE (CASE WHEN (ItemMainView.CostByCase = 1 OR
                         ItemMainView.CostByCase = 0 OR
                         ItemMainView.CostByCase IS NULL) THEN ItemStoreView.Cost ELSE ItemStoreView.Cost * ItemMainView.CaseQty END) END) AS RegCost, ItemStoreView.ReorderPoint, ItemHeadSupplierView.SupplierNo AS MainSupplierID, 
                         ItemStoreView.RestockLevel, ItemStoreView.CasePrice, ItemMainView.CustomerCode, ItemStoreView.OnTransferOrder, NULL AS Groups, NULL AS ItemAlias, (CASE WHEN IsNull(ParentInfo.[Supplier Item Code], '') 
                         = '' THEN ItemHeadSupplierView.ItemCode ELSE ParentInfo.[Supplier Item Code] END) AS ParentCode, ItemStoreView.SalePrice AS RegSPPrice, ItemStoreView.CaseSpecial AS CaseSPPrice, NULL AS RegPkgPrice, NULL 
                         AS [Reg SP Price Markup], NULL AS [Reg SP Price Margin], NULL AS [Pkg Price Markup], NULL AS [Pkg Price Margin],  ISNULL((CASE WHEN ItemStoreView.SaleType IN (1, 5, 4, 12) 
                         THEN (IsNull((CASE WHEN ISNULL(ItemStoreView.SalePrice, 0) = 0 OR
                         ISNULL(ItemStoreView.Cost, 0) = 0 THEN 0 WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ISNULL(ItemStoreView.Cost, 0) <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) - ISNULL(ItemStoreView.Cost, 0)) 
                         / ISNULL(ItemStoreView.Cost, 0) * 100 WHEN ItemMainView.CostByCase = 1 AND ISNULL(ItemStoreView.Cost, 0) <> 0 AND ISNULL(ItemMainView.CaseQty, 0) <> 0 AND ISNULL((ItemStoreView.Cost / ItemMainView.CaseQty), 0) 
                         <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) - (ISNULL(ItemStoreView.Cost, 0) / ISNULL(ItemMainView.CaseQty, 0))) / (ItemStoreView.Cost / ItemMainView.CaseQty) * 100 WHEN ItemMainView.CostByCase = 0 AND 
                         ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ISNULL(ItemStoreView.SalePrice, 0) / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ItemStoreView.Cost) * 100 END), 0)) WHEN ItemStoreView.SaleType IN (2, 6, 
                         13, 3, 11, 18) THEN (CASE WHEN (ISNULL(ItemStoreView.SpecialPrice, 0) = 0 OR
                         ISNULL(ItemStoreView.SpecialBuy, 0) = 0) THEN 0 WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ISNULL(ItemStoreView.Cost, 0) <> 0 THEN ((ISNULL(ItemStoreView.SpecialPrice, 0) 
                         / ISNULL(ItemStoreView.SpecialBuy, 0)) - ISNULL(ItemStoreView.Cost, 0)) / ISNULL(ItemStoreView.Cost, 0) * 100 WHEN ItemMainView.CostByCase = 1 AND ISNULL(ItemStoreView.Cost, 0) <> 0 AND 
                         ISNULL(ItemMainView.CaseQty, 0) <> 0 AND ISNULL((ItemStoreView.Cost / ItemMainView.CaseQty), 0) <> 0 THEN ((ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) 
                         - ISNULL((ItemStoreView.Cost / ItemMainView.CaseQty), 0)) / ISNULL((ItemStoreView.Cost / ItemMainView.CaseQty), 0) * 100 WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Cost <> 0 AND 
                         ItemMainView.CaseQty <> 0 THEN (((ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ItemStoreView.Cost) * 100 END) ELSE 0 END), 0) 
                         AS [SP Markup], (CASE WHEN ItemStoreView.SaleType IN (1, 5, 4, 12) THEN (IsNull((CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ISNULL(ItemStoreView.SalePrice, 0) 
                         <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) - ItemStoreView.Cost) / ItemStoreView.SalePrice * 100 WHEN ItemMainView.CostByCase = 1 AND ISNULL(ItemStoreView.SalePrice, 0) <> 0 AND 
                         ItemMainView.CaseQty <> 0 THEN (ISNULL(ItemStoreView.SalePrice, 0) - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ISNULL(ItemStoreView.SalePrice, 0)) * 100 WHEN ItemMainView.CostByCase = 0 AND 
                         ISNULL(ItemStoreView.SalePrice, 0) <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ISNULL(ItemStoreView.SalePrice, 0) / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ISNULL(ItemStoreView.SalePrice, 0) 
                         / ItemMainView.CaseQty) * 100 END), 0)) WHEN ItemStoreView.SaleType IN (2, 6, 13, 3, 11, 18) THEN ((CASE WHEN (ISNULL(ItemStoreView.SpecialPrice, 0) = 0 OR
                         ISNULL(ItemStoreView.SpecialBuy, 0) = 0) THEN 0 WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND (ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) 
                         <> 0 THEN ((ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) - ItemStoreView.Cost) / (ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) 
                         * 100 WHEN ItemMainView.CostByCase = 1 AND (ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ISNULL(ItemStoreView.SpecialPrice, 0) 
                         / ISNULL(ItemStoreView.SpecialBuy, 0)) - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) * 100 WHEN ItemMainView.CostByCase = 0 AND 
                         (ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) <> 0 AND ItemMainView.CaseQty <> 0 THEN (((ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) 
                         / ItemMainView.CaseQty) - ItemStoreView.Cost) / ((ISNULL(ItemStoreView.SpecialPrice, 0) / ISNULL(ItemStoreView.SpecialBuy, 0)) / ItemMainView.CaseQty) * 100 END)) ELSE 0 END) AS [SP Margin],
						 NULL AS SeasonName, NULL AS SeasonID, NULL 
                         AS MainDepartment, NULL AS SubDepartment, NULL AS SubSubDepartment, (CASE ItemStoreview.PrefOrderBy WHEN 0 THEN 'Pieces' WHEN 1 THEN 'Dozens' WHEN 2 THEN 'Cases' WHEN 3 THEN 'Lb' ELSE 'Pieces' END) 
                         AS PrefOrderBy, (CASE ItemStoreview.PrefSaleBy WHEN 0 THEN 'Pieces' WHEN 1 THEN 'Dozens' WHEN 2 THEN 'Cases' WHEN 3 THEN 'Lb' ELSE 'Pieces' END) AS PrefSaleBy, PrefOrderBy AS poBy, PrefSaleBy AS psBy, ItemStoreView.NetCost, 
                         ItemStoreView.SpecialCost, NULL AS extName, NULL AS CustomField1, NULL AS CustomField2, NULL AS CustomField3, NULL AS CustomField4, NULL AS CustomField5, NULL AS CustomField6, NULL AS CustomField7, NULL 
                         AS CustomField8, NULL AS CustomField9, NULL AS CustomField10, NULL AS CaseCode, ItemStoreView.LastReceivedDate, ItemStoreView.LastReceivedQty, ItemStoreView.WebPrice, ItemStoreView.WebCasePrice, 
                         ItemStoreView.SellOnWeb, ISNULL(ItemStoreView.YTDQty1, 0) AS YTDPcQty1, ISNULL(ItemStoreView.YTDQty2, 0) AS YTDPcQty2, ISNULL(ItemStoreView.YTDQty3, 0) AS YTDPcQty3, ItemStoreView.PriceA, ItemStoreView.PriceB, 
                         ItemStoreView.PriceC, ItemStoreView.PriceD, ItemStoreView.LastSoldUser, ItemStoreView.LastSoldQty, ItemStoreView.LastReceivedUser, ItemStoreView.TotalSold, ItemStoreView.TotalReceive, ItemStoreView.TotalProfit
FROM            dbo.DepartmentStore WITH (NOLOCK) RIGHT OUTER JOIN
                         dbo.Supplier AS SupplierView WITH (NOLOCK)  INNER JOIN
                         dbo.ItemSupply AS ItemHeadSupplierView WITH (NOLOCK)  ON SupplierView.SupplierID = ItemHeadSupplierView.SupplierNo RIGHT OUTER JOIN
                         dbo.ItemStore AS ItemStoreView WITH (NOLOCK)  INNER JOIN
                         dbo.Store WITH (NOLOCK)  ON Store.StoreID = ItemStoreView.StoreNo AND Store.Status > 0 INNER JOIN
                         dbo.ItemMain AS ItemMainView WITH (NOLOCK)  ON ItemStoreView.ItemNo = ItemMainView.ItemID LEFT OUTER JOIN
                         dbo.Manufacturers  WITH (NOLOCK) ON ItemMainView.ManufacturerID = Manufacturers.ManufacturerID ON ItemHeadSupplierView.ItemSupplyID = ItemStoreView.MainSupplierID AND ItemHeadSupplierView.ItemStoreNo = ItemStoreView.ItemStoreID
						 AND ItemHeadSupplierView.IsMainSupplier = 1 AND ItemHeadSupplierView.Status> 0 ON 
                         dbo.DepartmentStore.DepartmentStoreID = ItemStoreView.DepartmentID AND DepartmentStore.Status > 0  LEFT OUTER JOIN
                         dbo.SysItemTypeView ON ItemMainView.ItemType = SysItemTypeView.SystemValueNo LEFT OUTER JOIN
                         dbo.SysBarcodeTypeView ON ItemMainView.BarcodeType = SysBarcodeTypeView.SystemValueNo LEFT OUTER JOIN
                             (SELECT DISTINCT ItemStore.ItemNo AS ItemID, Supplier.Name AS SupplierName, ItemStore.StoreNo, ItemSupply.ItemCode AS [Supplier Item Code]
                               FROM            ItemStore  WITH (NOLOCK) INNER JOIN
                                                         ItemSupply WITH (NOLOCK)  ON ItemStore.ItemStoreID = ItemSupply.ItemStoreNo AND ItemStore.MainSupplierID = ItemSupply.ItemSupplyID INNER JOIN
                                                         Supplier WITH (NOLOCK)  ON ItemSupply.SupplierNo = Supplier.SupplierID
                               WHERE        (ItemSupply.Status > 0)) AS ParentInfo ON ItemStoreView.StoreNo = ParentInfo.StoreNo AND ItemMainView.LinkNo = ParentInfo.ItemID

GO