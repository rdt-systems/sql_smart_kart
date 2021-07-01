SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ItemViewBasic]
AS
SELECT        dbo.ItemMainView.ItemID, (CASE WHEN ISNULL(ItemMainView.itemtype, 0) = 1 THEN '  ' + ItemMainView.Name ELSE ItemMainView.Name END) AS Name, dbo.ItemMainView.ModalNumber, 
                         dbo.ItemMainView.BarcodeNumber, dbo.ItemStoreView.StoreNo, dbo.ItemStoreView.IsTaxable, dbo.ItemStoreView.IsDiscount, dbo.ItemStoreView.IsFoodStampable, dbo.ItemStoreView.Cost, 
                         dbo.ItemStoreView.Price, dbo.ItemMainView.CaseQty, dbo.ItemMainView.PriceByCase, dbo.ItemMainView.CostByCase, dbo.ItemMainView.CaseBarcodeNumber, dbo.ItemStoreView.OnHand, 
                         dbo.ItemStoreView.Status, dbo.ItemStoreView.DateCreated, dbo.ItemStoreView.DateModified AS ItemStoreDateModified, 
                         (CASE WHEN ItemMainView.CostByCase = 1 THEN ItemStoreView.Cost ELSE ItemStoreView.Cost * ItemMainView.CaseQty END) AS [Cs Cost], (CASE WHEN ItemMainView.CostByCase = 1 AND 
                         ItemMainView.CaseQty <> 0 THEN ItemStoreView.Cost / ItemMainView.CaseQty ELSE ItemStoreView.Cost END) AS [Pc Cost], dbo.ItemStoreView.ItemStoreID, dbo.DepartmentStore.Name AS Department, 
                         dbo.ItemMainView.Matrix1, dbo.ItemMainView.Matrix2, dbo.SupplierView.Name AS SupplierName, (CASE WHEN ItemStoreView.SaleType = 1 THEN CASE WHEN ISNULL(ItemStoreView.AssignDate, 0) 
                         > 0 THEN CASE WHEN (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) THEN '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) END ELSE '1 @ ' + CONVERT(nvarchar, 
                         ItemStoreView.SalePrice, 110) END WHEN ItemStoreView.SaleType = 2 AND ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                         (ISNULL(ItemStoreView.AssignDate, 0) = 0)) THEN CONVERT(nvarchar, ItemStoreView.SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, ItemStoreView.SpecialPrice, 110) WHEN ItemStoreView.SaleType = 4 AND 
                         ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                         (ISNULL(ItemStoreView.AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) + ' , ' + CONVERT(nvarchar, ItemStoreView.SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, 
                         ItemStoreView.SpecialPrice, 110) END) AS [SP Price], (CASE WHEN (ItemStoreView.SaleType = 1 OR
                         ItemStoreView.SaleType = 4) AND ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleStartDate WHEN ItemStoreView.SaleType = 2 AND ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleStartDate END)
                          AS [SP From], (CASE WHEN (ItemStoreView.SaleType = 1 OR
                         ItemStoreView.SaleType = 4) AND ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleEndDate WHEN ItemStoreView.SaleType = 2 AND ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleEndDate END) 
                         AS [SP To], (CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Cost <> 0 THEN (ItemStoreView.Price - ItemStoreView.Cost) 
                         / ItemStoreView.Cost * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 AND (ItemStoreView.Cost / ItemMainView.CaseQty) 
                         <> 0 THEN (ItemStoreView.Price - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ItemStoreView.Cost / ItemMainView.CaseQty) * 100 WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Cost <> 0 AND 
                         ItemMainView.CaseQty <> 0 THEN ((ItemStoreView.Price / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ItemStoreView.Cost) * 100 END) AS Markup, 
                         (CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Price <> 0 THEN (ItemStoreView.Price - ItemStoreView.Cost) 
                         / ItemStoreView.Price * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Price <> 0 AND ItemMainView.CaseQty <> 0 THEN (ItemStoreView.Price - (ItemStoreView.Cost / ItemMainView.CaseQty)) 
                         / (ItemStoreView.Price) * 100 WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Price <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ItemStoreView.Price / ItemMainView.CaseQty) - ItemStoreView.Cost) 
                         / (ItemStoreView.Price / ItemMainView.CaseQty) * 100 END) AS Margin, dbo.Manufacturers.ManufacturerName AS Brand, dbo.ItemMainView.Size, dbo.DepartmentStore.DateModified AS DepartmentDateModified, 
                         dbo.ItemStoreView.DepartmentID, dbo.SysItemTypeView.SystemValueName AS ItemTypeName, dbo.SysBarcodeTypeView.SystemValueName AS BarcodeType,  STUFF
                             ((SELECT DISTINCT ',' + ig.ItemGroupName
                                 FROM            ItemToGroup AS itg INNER JOIN
                                                          ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
                                 WHERE        itg.ItemStoreID = ItemStoreView.ItemStoreID AND itg.Status > 0 FOR XML PATH(''), TYPE ).value('.', 'varchar(max)'), 1, 1, '') AS Groups
FROM            dbo.DepartmentStore RIGHT OUTER JOIN
                         dbo.SupplierView INNER JOIN
                         dbo.ItemHeadSupplierView ON dbo.SupplierView.SupplierID = dbo.ItemHeadSupplierView.SupplierNo RIGHT OUTER JOIN
                         dbo.ItemStoreView INNER JOIN
                         dbo.ItemMainView ON dbo.ItemStoreView.ItemNo = dbo.ItemMainView.ItemID LEFT OUTER JOIN
                         dbo.Manufacturers ON dbo.ItemMainView.ManufacturerID = dbo.Manufacturers.ManufacturerID ON dbo.ItemHeadSupplierView.ItemSupplyID = dbo.ItemStoreView.MainSupplierID ON 
                         dbo.DepartmentStore.DepartmentStoreID = dbo.ItemStoreView.DepartmentID LEFT OUTER JOIN
                         dbo.MatrixTableView ON dbo.ItemMainView.MatrixTableNo = dbo.MatrixTableView.MatrixTableID LEFT OUTER JOIN
                         dbo.UOM ON dbo.ItemMainView.Unit = dbo.UOM.UOMID LEFT OUTER JOIN
                         dbo.SysItemTypeView ON dbo.ItemMainView.ItemType = dbo.SysItemTypeView.SystemValueNo LEFT OUTER JOIN
                         dbo.SysBarcodeTypeView ON dbo.ItemMainView.BarcodeType = dbo.SysBarcodeTypeView.SystemValueNo
GO