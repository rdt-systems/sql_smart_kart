SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[ItemsForMobil]
AS
SELECT        dbo.ItemMain.ItemID, dbo.ItemMain.BarcodeNumber AS UPC, dbo.ItemStore.ItemStoreID, dbo.ItemMain.Name AS Description, dbo.ItemMain.ItemType, dbo.ItemStore.OnHand, dbo.ItemStore.Price, 
                         dbo.ItemStore.Cost, dbo.ItemStore.IsFoodStampable AS FS, dbo.ItemStore.IsTaxable AS TX, dbo.ItemStore.IsDiscount AS DIS, dbo.ItemMain.Meaasure AS Measure, dbo.ItemMain.Units, dbo.ItemStore.SaleType, 
                         dbo.ItemStore.SalePrice, dbo.ItemStore.SpecialPrice, dbo.ItemStore.SpecialBuy AS spQty, dbo.ItemMain.CaseQty, dbo.ItemStore.SaleMax, dbo.ItemStore.SaleMin, dbo.ItemStore.MinForSale AS MinTSale, 
                         dbo.ItemStore.AssignDate, dbo.ItemStore.StoreNo AS StoreID, dbo.ItemMain.ModalNumber AS ItemCode, dbo.ItemMain.DateModified AS MainDateModified, dbo.ItemStore.DateModified AS ItemStoreDateModified, 
                         dbo.ItemAlias.BarcodeNumber AS AliesUPC, dbo.ItemMain.Size, dbo.Manufacturers.ManufacturerName AS Brand, (CASE WHEN CostByCase = PriceByCase AND Cost <> 0 THEN (Price - Cost) 
                         / Cost * 100 WHEN CostByCase = 1 AND Cost <> 0 AND ItemMain.CaseQty <> 0 AND (Cost / ItemMain.CaseQty) <> 0 THEN (Price - (Cost / ItemMain.CaseQty)) / (Cost / ItemMain.CaseQty) 
                         * 100 WHEN CostByCase = 0 AND Cost <> 0 AND ItemMain.CaseQty <> 0 THEN ((Price / ItemMain.CaseQty) - Cost) / (Cost) * 100 END) AS Markup, (CASE WHEN CostByCase = PriceByCase AND 
                         Price <> 0 THEN (Price - Cost) / Price * 100 WHEN CostByCase = 1 AND Price <> 0 AND ItemMain.CaseQty <> 0 THEN (Price - (Cost / ItemMain.CaseQty)) / (Price) * 100 WHEN CostByCase = 0 AND Price <> 0 AND 
                         ItemMain.CaseQty <> 0 THEN ((Price / ItemMain.CaseQty) - Cost) / (Price / ItemMain.CaseQty) * 100 END) AS Margin, dbo.Supplier.Name AS SupplierName, dbo.DepartmentStore.Name AS Department, 
                         dbo.ItemSupply.ItemCode AS VenderCode, (CASE WHEN (IsNull(Price, 0) > 0 AND IsNull(Units, 0) > 0) AND (IsNull(Meaasure, 0) > 0) THEN [dbo].[ConvertMessures](Meaasure, Units, Price) ELSE '' END) 
                         AS ConvertUnitPrice, (CASE WHEN ItemMain.CostByCase = 1 THEN Cost ELSE Cost * ItemMain.CaseQty END) AS CsCost, (CASE WHEN ItemMain.CostByCase = 1 AND 
                         ItemMain.CaseQty <> 0 THEN Cost / ItemMain.CaseQty ELSE Cost END) AS PcCost, (CASE WHEN (SaleType > 0 AND SaleType <> 3) AND 
                         ItemStore.AssignDate = 1 THEN SaleStartDate WHEN SaleType = 3 THEN StartDate END) AS SaleStartDate, (CASE WHEN (SaleType > 0 AND SaleType <> 3) AND 
                         ItemStore.AssignDate = 1 THEN SaleEndDate WHEN SaleType = 3 THEN EndDate END) AS SaleEndDate, NULL AS LastDelivary, (CASE WHEN (ItemStore.SaleType IN (1, 5, 12)) 
                         THEN CASE WHEN ISNULL(ItemStore.AssignDate, 0) > 0 THEN CASE WHEN (dbo.GetDay(ItemStore.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) THEN '1 @ ' + CONVERT(nvarchar, itemstore.SalePrice, 110) 
                         END ELSE '1 @ ' + CONVERT(nvarchar, Itemstore.SalePrice, 110) END WHEN (ItemStore.SaleType IN (2, 6, 13)) AND ((ISNULL(Itemstore.AssignDate, 0) > 0) AND (dbo.GetDay(SaleEndDate) 
                         >= dbo.GetDay(dbo.GetLocalDATE())) OR
                         (ISNULL(ItemStore.AssignDate, 0) = 0)) THEN CONVERT(nvarchar, SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, SpecialPrice, 110) 
                         WHEN SaleType = 3 THEN 'MIX ' + MixAndMatch.Name + ' ' + CONVERT(nvarchar, MixAndMatch.Qty, 110) + ' @ ' + CONVERT(nvarchar, MixAndMatch.Amount, 110) WHEN (SaleType IN (4, 11, 18)) AND 
                         ((ISNULL(ItemStore.AssignDate, 0) > 0) AND (dbo.GetDay(SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                         (ISNULL(ItemStore.AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(nvarchar, Itemstore.SalePrice, 110) + ' , ' + CONVERT(nvarchar, SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, SpecialPrice, 110) END) AS SPPrice, 
                         dbo.ItemStore.BinLocation
FROM            dbo.MixAndMatch RIGHT OUTER JOIN
                         dbo.ItemStore INNER JOIN
                         dbo.ItemMain ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID ON dbo.MixAndMatch.MixAndMatchID = dbo.ItemStore.MixAndMatchID LEFT OUTER JOIN
                         dbo.DepartmentStore ON dbo.ItemStore.DepartmentID = dbo.DepartmentStore.DepartmentStoreID LEFT OUTER JOIN
                         dbo.Supplier INNER JOIN
                         dbo.ItemSupply ON dbo.Supplier.SupplierID = dbo.ItemSupply.SupplierNo ON dbo.ItemStore.MainSupplierID = dbo.ItemSupply.ItemSupplyID LEFT OUTER JOIN
                         dbo.ItemAlias ON dbo.ItemMain.ItemID = dbo.ItemAlias.ItemNo LEFT OUTER JOIN
                         dbo.Manufacturers ON dbo.ItemMain.ManufacturerID = dbo.Manufacturers.ManufacturerID
WHERE        (dbo.ItemMain.Status > 0) AND (dbo.ItemStore.Status > 0)
GO