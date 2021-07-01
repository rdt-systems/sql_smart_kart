SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[GroupView2] 
--with schemabinding 
as

Select
dbo.itemstore.itemstoreid,
 dbo.ItemMain.ItemID
--, ItemMainView.Name
--, dbo.ItemMainView.ModalNumber
--, dbo.ItemMainView.LinkNo
--, dbo.ItemMainView.BarcodeNumber
, dbo.ItemStore.StoreNo
--, dbo.ItemStoreView.IsTaxable
--, dbo.ItemStoreView.IsDiscount
--, dbo.ItemStoreView.IsFoodStampable
--, Cast(0 as bit) as IsWIC, Cast(0.0 as money) as Cost, dbo.ItemStoreView.Price
--, Cast(0 as int) as CaseQty, Cast(0 as bit) as PriceByCase, dbo.ItemMainView.StyleNo
--, Cast(0 as bit) as CostByCase, Cast('' as nvarchar(50)) as CaseBarcodeNumber, ISNULL(dbo.ItemStoreView.OnHand
--, 0) AS OnHand, Cast(0.0 as decimal(20,2)) as CsOnHand, Cast('' as nvarchar(50)) as BinLocation,


, dbo.ItemStore.Status, ITEMGROUPNAME AS groups

--dbo.ItemStoreView.DateCreated, dbo.ItemStoreView.DateModified AS ItemStoreDateModified, dbo.ItemMainView.DateModified AS MainDateModified, Cast(0.0 as money) as [Cs Cost], (CASE WHEN ItemMainView.CostByCase = 1 AND ItemMainView.CaseQty <> 0 THEN ItemStoreView.Cost / ItemMainView.CaseQty ELSE ItemStoreView.Cost END) AS [Pc Cost], dbo.ItemMainView.Status AS MainStatus, dbo.ItemStoreView.ItemStoreID, dbo.DepartmentStore.Name AS Department, Cast('' as nvarchar(50)) as Matrix1, Cast('' as nvarchar(50)) as Matrix2, Cast('' as nvarchar(50)) as Matrix3, Cast('' as nvarchar(50)) as Matrix4, Cast('' as nvarchar(50)) as Matrix5, Cast('' as nvarchar(50)) as Matrix6, Cast('' as nvarchar(50)) as [Supplier Item Code], ItemMainView.ManufacturerPartNo, (CASE WHEN (ItemStoreView.SaleType IN (1, 5, 12)) 
--                      THEN CASE WHEN ISNULL(ItemStoreView.AssignDate, 0) > 0 THEN CASE WHEN (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) 
--                      THEN '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) END ELSE '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) 
--                      END WHEN (ItemStoreView.SaleType IN (2, 6, 13)) AND ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND (dbo.GetDay(ItemStoreView.SaleEndDate) 
--                      >= dbo.GetDay(dbo.GetLocalDATE())) OR
--                      (ISNULL(ItemStoreView.AssignDate, 0) = 0)) THEN CONVERT(nvarchar, ItemStoreView.SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, ItemStoreView.SpecialPrice, 110) 
--                      WHEN ItemStoreView.SaleType = 3 THEN 'MIX ' + MixAndMatchView.Name + ' ' + CONVERT(nvarchar, MixAndMatchView.Qty, 110) + ' @ ' + CONVERT(nvarchar, 
--                      MixAndMatchView.Amount, 110) WHEN (ItemStoreView.SaleType IN (4, 11, 18)) AND ((ISNULL(ItemStoreView.AssignDate, 0) > 0) AND 
--                      (dbo.GetDay(ItemStoreView.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
--                      (ISNULL(ItemStoreView.AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(nvarchar, ItemStoreView.SalePrice, 110) + ' , ' + CONVERT(nvarchar, ItemStoreView.SpecialBuy, 
--                      110) + ' @ ' + CONVERT(nvarchar, ItemStoreView.SpecialPrice, 110) END) AS [SP Price], Cast(dbo.GetLocalDATE() as datetime) as GroupDateModified, (CASE WHEN (ItemStoreView.SaleType > 0 AND ItemStoreView.SaleType <> 3) AND ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleStartDate WHEN ItemStoreView.SaleType = 3 THEN MixAndMatchView.StartDate END) AS [SP From], (CASE WHEN (ItemStoreView.SaleType > 0 AND ItemStoreView.SaleType <> 3) AND ItemStoreView.AssignDate = 1 THEN ItemStoreView.SaleEndDate WHEN ItemStoreView.SaleType = 3 THEN MixAndMatchView.EndDate END) AS [SP To], Cast('' as nvarchar(100)) as [Future SP Price], Cast(dbo.GetLocalDATE() as datetime) as [Future SP From], Cast(dbo.GetLocalDATE() as datetime) as [Future SP To], (CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Cost <> 0 THEN (ItemStoreView.Price - ItemStoreView.Cost) 
--                      / ItemStoreView.Cost * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Cost <> 0 AND ItemMainView.CaseQty <> 0 AND 
--                      (ItemStoreView.Cost / ItemMainView.CaseQty) <> 0 THEN (ItemStoreView.Price - (ItemStoreView.Cost / ItemMainView.CaseQty)) 
--                      / (ItemStoreView.Cost / ItemMainView.CaseQty) * 100 WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Cost <> 0 AND 
--                      ItemMainView.CaseQty <> 0 THEN ((ItemStoreView.Price / ItemMainView.CaseQty) - ItemStoreView.Cost) / (ItemStoreView.Cost) * 100 END) AS Markup, (CASE WHEN ItemMainView.CostByCase = ItemMainView.PriceByCase AND ItemStoreView.Price <> 0 THEN (ItemStoreView.Price - ItemStoreView.Cost) 
--                      / ItemStoreView.Price * 100 WHEN ItemMainView.CostByCase = 1 AND ItemStoreView.Price <> 0 AND 
--                      ItemMainView.CaseQty <> 0 THEN (ItemStoreView.Price - (ItemStoreView.Cost / ItemMainView.CaseQty)) / (ItemStoreView.Price) 
--                      * 100 WHEN ItemMainView.CostByCase = 0 AND ItemStoreView.Price <> 0 AND ItemMainView.CaseQty <> 0 THEN ((ItemStoreView.Price / ItemMainView.CaseQty) 
                     -- ItemStoreView.Cost) / (ItemStoreView.Price / ItemMainView.CaseQty) * 100 END) AS Margin, Cast(0.0 as money) as MTD, ISNULL(dbo.ItemStoreView.MTDQty, 0) AS [MTD Pc Qty], Cast(0.0 as decimal(29,11)) as [MTD Cs Qty], Cast(0.0 as money) as YTD, ISNULL(dbo.ItemStoreView.YTDQty, 0) AS [YTD Pc Qty], Cast(0.0 as decimal(29,11)) as [YTD Cs Qty], Cast(0.0 as money) as PTD, ISNULL(dbo.ItemStoreView.PTDQty, 0) AS [PTD Pc Qty], ItemMainView.MatrixTableNo, Cast(0.0 as decimal(29,11)) as [PTD Cs Qty], dbo.ItemStoreView.ItemNo, dbo.Manufacturers.ManufacturerName AS Brand, Cast(0 as int) as ToReorder, dbo.ItemMainView.Size, Cast(dbo.GetLocalDATE() as datetime) as DepartmentDateModified, dbo.ItemMainView.ItemType, dbo.ItemStoreView.DepartmentID, Cast('' as nvarchar(50)) as ItemTypeName, Cast('' as nvarchar(50)) as BarcodeType, Cast(0.0 as decimal(19,3)) as OnOrder, Cast(0.0 as money) as AVGCost, Cast(0.0 as money) as RegCost, Cast(0.0 as decimal(19,3)) as ReorderPoint, dbo.ItemHeadSupplierView.SupplierNo AS MainSupplierID, Cast(0.0 as decimal(19,3)) as RestockLevel, Cast(0.0 as money) as CasePrice, dbo.ItemMainView.CustomerCode, Cast(0.0 as decimal(19,3)) as OnTransferOrder, 	
					  
					  
					  				  --STUFF ((SELECT DISTINCT ',' + ig.ItemGroupName
             --                 FROM         dbo.ItemToGroup AS itg INNER JOIN
             --                                      dbo.ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
             --                 WHERE     itg.ItemStoreID = ItemStore.ItemStoreID AND itg.Status > 0 FOR XML PATH(''), TYPE ).value('.', 'varchar(max)'), 1, 1, '') AS Groups--, 
							  
							  
							  --Cast('' as varchar(max)) as ItemAlias, Cast('' as nvarchar(50)) as ParentCode, Cast(0.0 as money) as RegSPPrice, Cast(0.0 as money) as CaseSPPrice, Cast('' as nvarchar(62)) as RegPkgPrice, Cast(0.0 as money) as [Reg SP Price Markup], Cast(0.0 as money) as [Reg SP Price Margin], Cast(0.0 as money) as [Pkg Price Markup], Cast(0.0 as money) as [Pkg Price Margin], Cast(0.0 as money) as [SP Markup], Cast(0.0 as money) as [SP Margin], Cast('' as nvarchar(50)) as MainDepartment, Cast('' as nvarchar(50)) as SubDepartment, Cast('' as nvarchar(50)) as SubSubDepartment, (case ItemStoreview.PrefOrderBy when 0 then 'Pieces' when 1 then 'Dozens' when 2 then 'Cases' when 3 then 'Lb' else '' end) as PrefOrderBy, dbo.SupplierView.Name  AS SupplierName, dbo.ItemMainView.CustomInteger1, (case ItemStoreview.PrefSaleBy when 0 then 'Pieces' when 1 then 'Dozens' when 2 then 'Cases' when 3 then 'Lb' else '' end) as PrefSaleBy
 --,--STUFF ( (SELECT DISTINCT  ',' + ig.ItemGroupName, 1, 1, ''))
 --ItemGroupName
 FROM --o.DepartmentStore RIGHT OUTER JOIN
  dbo.ItemStore
  INNER JOIN dbo.ItemMain ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID
  INNER JOIN dbo.Store ON dbo.ItemStore.StoreNo = dbo.Store.StoreID 
  INNER JOIN  dbo.ItemToGroup ON  ITEMTOGROUP.ItemStoreID = ItemStore.ItemStoreID
  INNER JOIN dbo.ItemGroup ON ItemToGroup.ItemGroupID = ItemGroup.ItemGroupID
--  INNER JOIN (
--	select DISTINCT
--	 itemstoreid 
--	 ,STUFF((
	
--		SELECT N',' + CAST(ItemGroupName AS VARCHAR(500))
--		 FROM
--								dbo.ItemToGroup AS itg 
--								INNER JOIN dbo.ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
--	WHERE ITG.ItemStoreID = A1.ItemStoreID
--	FOR XML PATH(''), TYPE ).value('.', 'varchar(max)'), 1, 1, '')  AS Groups

--FROM DBO.iTEMTOGROUP A1

--	) as groups on   groups.ItemStoreID = ItemStore.ItemStoreID AND itemstore.Status > 0 





	--select   STUFF ((
	--SELECT DISTINCT  ',' + ig.ItemGroupName
 --                          FROM
	--							dbo.ItemToGroup AS itg 
	--							INNER JOIN dbo.ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
 --                           WHERE     -.ItemStoreID = ItemStore.ItemStoreID AND 
	--							itg.Status > 0 FOR XML PATH(''), TYPE ).value('.', 'varchar(max)')
	--							, 1, 1, '') AS Groups                            


 -- ) Groups ON ItemStore.ItemStoreID = Groups.ItemStoreID
  
 --LEFT OUTER JOIN dbo.MixAndMatchView ON dbo.MixAndMatchView.MixAndMatchID = dbo.ItemStoreView.MixAndMatchID
 --LEFT OUTER JOIN dbo.Manufacturers ON dbo.ItemMainView.ManufacturerID = dbo.Manufacturers.ManufacturerID
 --left OUTER JOIN dbo.ItemHeadSupplierView ON dbo.ItemHeadSupplierView.ItemSupplyID = dbo.ItemStoreView.MainSupplierID
 --LEFT OUTER JOIN dbo.SupplierView ON dbo.SupplierView.SupplierID = dbo.ItemHeadSupplierView.SupplierNo

 --N dbo.DepartmentStore.DepartmentStoreID = dbo.ItemStoreView.DepartmentID AND dbo.DepartmentStore.Status >0





--ALTER unique clustered index uc_itemid on groupview (itemid)
GO