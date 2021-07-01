SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[tempitemview]
AS
SELECT    distinct dbo.ItemMain.ItemID, ItemMain.Name, dbo.ItemMain.ModalNumber, dbo.ItemMain.LinkNo, dbo.ItemMain.BarcodeNumber, 
                      dbo.ItemStore.StoreNo, dbo.ItemStore.IsTaxable, dbo.ItemStore.IsDiscount, dbo.ItemStore.IsFoodStampable, dbo.ItemStore.IsWIC, 
                      dbo.ItemStore.Cost, dbo.ItemStore.Price, dbo.ItemMain.CaseQty, dbo.ItemMain.PriceByCase, dbo.ItemMain.StyleNo, 
                      dbo.ItemMain.CostByCase, dbo.ItemMain.CaseBarcodeNumber, dbo.ItemStore.OnHand, CAST(CASE WHEN ISNULL(ItemMain.CaseQty, 1) > 0 AND 
                      (ISNULL(dbo.ItemStore.OnHand, 1) <> 0) THEN ISNULL(dbo.ItemStore.OnHand, 1) / ISNULL(ItemMain.CaseQty, 1) 
                      ELSE dbo.ItemStore.OnHand END AS decimal(20, 2)) AS CsOnHand, dbo.ItemStore.BinLocation, dbo.ItemStore.Status, dbo.ItemStore.DateCreated, 
                      dbo.ItemStore.DateModified AS ItemStoreDateModified, dbo.ItemMain.DateModified AS MainDateModified, 
                      (CASE WHEN ItemMain.CostByCase = 1 THEN ItemStore.Cost ELSE ItemStore.Cost * ItemMain.CaseQty END) AS [Cs Cost], 
                      (CASE WHEN ItemMain.CostByCase = 1 AND ItemMain.CaseQty <> 0 THEN ItemStore.Cost / ItemMain.CaseQty ELSE ItemStore.Cost END) 
                      AS [Pc Cost], dbo.ItemMain.Status AS MainStatus, dbo.ItemStore.ItemStoreID, dbo.DepartmentStore.Name AS Department, dbo.ItemMain.Matrix1, 
                      dbo.ItemMain.Matrix2, dbo.ItemMain.Matrix3, dbo.ItemMain.Matrix4, dbo.ItemMain.Matrix5, dbo.ItemMain.Matrix6, 
                      dbo.Supplier.Name AS SupplierName, ItemMain.ManufacturerPartNo, 
					  --SP Price
					  (CASE WHEN (ItemStore.SaleType IN (1, 5, 12)) 
                      THEN CASE WHEN ISNULL(ItemStore.AssignDate, 0) > 0 THEN CASE WHEN (dbo.GetDay(ItemStore.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) 
                      THEN '1 @ ' + CONVERT(nvarchar, ItemStore.SalePrice, 110) END ELSE '1 @ ' + CONVERT(nvarchar, ItemStore.SalePrice, 110) 
                      END WHEN (ItemStore.SaleType IN (2, 6, 13)) AND ((ISNULL(ItemStore.AssignDate, 0) > 0) AND (dbo.GetDay(ItemStore.SaleEndDate) 
                      >= dbo.GetDay(dbo.GetLocalDATE())) OR
                      (ISNULL(ItemStore.AssignDate, 0) = 0)) THEN CONVERT(nvarchar, ItemStore.SpecialBuy, 110) + ' @ ' + CONVERT(nvarchar, ItemStore.SpecialPrice, 110) 
                      WHEN ItemStore.SaleType = 3 THEN 'MIX ' + MixAndMatchView.Name + ' ' + CONVERT(nvarchar, MixAndMatchView.Qty, 110) + ' @ ' + CONVERT(nvarchar, 
                      MixAndMatchView.Amount, 110) WHEN (ItemStore.SaleType IN (4, 11, 18)) AND ((ISNULL(ItemStore.AssignDate, 0) > 0) AND 
                      (dbo.GetDay(ItemStore.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                      (ISNULL(ItemStore.AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(nvarchar, ItemStore.SalePrice, 110) + ' , ' + CONVERT(nvarchar, ItemStore.SpecialBuy, 
                      110) + ' @ ' + CONVERT(nvarchar, ItemStore.SpecialPrice, 110) END) AS [SP Price],
					   ItemHeadSupplier.ItemCode AS [Supplier Item Code], 
                      Groups1.DateModified AS GroupDateModified, 
					  --SP From / SP To
					  (CASE WHEN (ItemStore.SaleType > 0 AND ItemStore.SaleType <> 3) AND 
                      ItemStore.AssignDate = 1 THEN ItemStore.SaleStartDate WHEN ItemStore.SaleType = 3 THEN MixAndMatchView.StartDate END) AS [SP From], 
                      (CASE WHEN (ItemStore.SaleType > 0 AND ItemStore.SaleType <> 3) AND 
                      ItemStore.AssignDate = 1 THEN ItemStore.SaleEndDate WHEN ItemStore.SaleType = 3 THEN MixAndMatchView.EndDate END) AS [SP To], 
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
					  (CASE WHEN ItemMain.CostByCase = ItemMain.PriceByCase AND ItemStore.Cost <> 0 THEN (ItemStore.Price - ItemStore.Cost) 
                      / ItemStore.Cost * 100 WHEN ItemMain.CostByCase = 1 AND ItemStore.Cost <> 0 AND ItemMain.CaseQty <> 0 AND 
                      (ItemStore.Cost / ItemMain.CaseQty) <> 0 THEN (ItemStore.Price - (ItemStore.Cost / ItemMain.CaseQty)) 
                      / (ItemStore.Cost / ItemMain.CaseQty) * 100 WHEN ItemMain.CostByCase = 0 AND ItemStore.Cost <> 0 AND 
                      ItemMain.CaseQty <> 0 THEN ((ItemStore.Price / ItemMain.CaseQty) - ItemStore.Cost) / (ItemStore.Cost) * 100 END) AS Markup, 
                      --Margin
					  (CASE WHEN ItemMain.CostByCase = ItemMain.PriceByCase AND ItemStore.Price <> 0 THEN (ItemStore.Price - ItemStore.Cost) 
                      / ItemStore.Price * 100 WHEN ItemMain.CostByCase = 1 AND ItemStore.Price <> 0 AND 
                      ItemMain.CaseQty <> 0 THEN (ItemStore.Price - (ItemStore.Cost / ItemMain.CaseQty)) / (ItemStore.Price) 
                      * 100 WHEN ItemMain.CostByCase = 0 AND ItemStore.Price <> 0 AND ItemMain.CaseQty <> 0 THEN ((ItemStore.Price / ItemMain.CaseQty) 
                      - ItemStore.Cost) / (ItemStore.Price / ItemMain.CaseQty) * 100 END) AS Margin,
					  
					   ISNULL(dbo.ItemStore.MTDDollar, 0) AS MTD, 
                      ISNULL(dbo.ItemStore.MTDQty, 0) AS [MTD Pc Qty], 
                      (CASE WHEN dbo.ItemMain.CaseQty <> 0 THEN dbo.ItemStore.MTDQty / dbo.ItemMain.CaseQty END) AS [MTD Cs Qty], 
                      ISNULL(dbo.ItemStore.YTDDollar, 0) AS YTD, ISNULL(dbo.ItemStore.YTDQty, 0) AS [YTD Pc Qty], 
                      (CASE WHEN dbo.ItemMain.CaseQty <> 0 THEN dbo.ItemStore.YTDQty / dbo.ItemMain.CaseQty END) AS [YTD Cs Qty], 
                      ISNULL(dbo.ItemStore.PTDDollar, 0) AS PTD, ISNULL(dbo.ItemStore.PTDQty, 0) AS [PTD Pc Qty], ItemMain.MatrixTableNo, 
                      (CASE WHEN dbo.ItemMain.CaseQty <> 0 THEN dbo.ItemStore.PTDQty / dbo.ItemMain.CaseQty END) AS [PTD Cs Qty], dbo.ItemStore.ItemNo, 
                      dbo.Manufacturers.ManufacturerName AS Brand, 
                      (CASE WHEN ((ItemStore.OnHand + ItemStore.OnOrder - ItemStore.OnWorkOrder + ItemStore.OnTransferOrder) < ItemStore.ReorderPoint) AND 
                      (ItemMain.ItemType <> 3) AND (ItemMain.ItemType <> 5) THEN 1 ELSE 0 END) AS ToReorder, dbo.ItemMain.Size, 
                      dbo.DepartmentStore.DateModified AS DepartmentDateModified, dbo.ItemMain.ItemType, dbo.ItemStore.DepartmentID, 
                     null AS ItemTypeName, null AS BarcodeType, dbo.ItemStore.OnOrder, 
                      dbo.ItemStore.AVGCost, (CASE WHEN ISNULL(ItemStore.RegCost, 0) > 0 THEN ItemStore.RegCost ELSE (CASE WHEN (ItemMain.CostByCase = 1 OR
                      ItemMain.CostByCase = 0) THEN ItemStore.Cost ELSE ItemStore.Cost * ItemMain.CaseQty END) END) AS RegCost, dbo.ItemStore.ReorderPoint, 
                      ItemHeadSupplier.SupplierNo AS MainSupplierID, dbo.ItemStore.RestockLevel, dbo.ItemStore.CasePrice, dbo.ItemMain.CustomerCode, 
                      dbo.ItemStore.OnTransferOrder, STUFF
                          ((SELECT DISTINCT ',' + ig.ItemGroupName
                              FROM         ItemToGroup AS itg INNER JOIN
                                                    ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
                              WHERE     itg.ItemStoreID = ItemStore.ItemStoreID AND itg.Status > 0 FOR XML PATH(''), TYPE ).value('.', 'varchar(max)'), 1, 1, '') AS Groups, STUFF
                          ((SELECT DISTINCT ',' + ia.BarcodeNumber
                              FROM         ItemAlias AS ia
                              WHERE     ia.ItemNO = ItemStore.ItemNo AND ia.Status > 0 FOR XML PATH(''), TYPE ).value('.', 'varchar(max)'), 1, 1, '') AS ItemAlias, 
                     null
                       AS ParentCode, ItemStore.SalePrice AS RegSPPrice, ItemStore.CaseSpecial AS CaseSPPrice, 
					   (CONVERT(nvarchar, ItemStore.PkgQty, 110) + '@ ' + CONVERT(nvarchar, ISNULL(ItemStore.PkgPrice, 0), 110)) AS RegPkgPrice, 
					  --Reg SP Price Markup
					   IsNull((CASE WHEN ISNULL(ItemStore.SalePrice, 0) = 0 OR
                      ISNULL(ItemStore.Cost, 0) = 0 THEN 0 WHEN ItemMain.CostByCase = ItemMain.PriceByCase AND 
                      ItemStore.Cost <> 0 THEN (ISNULL(ItemStore.SalePrice, 0) - ItemStore.Cost) / ItemStore.Cost * 100 WHEN ItemMain.CostByCase = 1 AND 
                      ItemStore.Cost <> 0 AND ItemMain.CaseQty <> 0 AND (ItemStore.Cost / ItemMain.CaseQty) <> 0 THEN (ISNULL(ItemStore.SalePrice, 0) 
                      - (ItemStore.Cost / ItemMain.CaseQty)) / (ItemStore.Cost / ItemMain.CaseQty) * 100 WHEN ItemMain.CostByCase = 0 AND 
                      ItemStore.Cost <> 0 AND ItemMain.CaseQty <> 0 THEN ((ISNULL(ItemStore.SalePrice, 0) / ItemMain.CaseQty) - ItemStore.Cost) 
                      / (ItemStore.Cost) * 100 END), 0) AS [Reg SP Price Markup],
					  --Reg SP Price Margin
					   IsNull((CASE WHEN ItemMain.CostByCase = ItemMain.PriceByCase AND 
                      ISNULL(ItemStore.SalePrice, 0) <> 0 THEN (ISNULL(ItemStore.SalePrice, 0) - ItemStore.Cost) 
                      / ItemStore.SalePrice * 100 WHEN ItemMain.CostByCase = 1 AND ISNULL(ItemStore.SalePrice, 0) <> 0 AND 
                      ItemMain.CaseQty <> 0 THEN (ISNULL(ItemStore.SalePrice, 0) - (ItemStore.Cost / ItemMain.CaseQty)) / (ISNULL(ItemStore.SalePrice, 0)) 
                      * 100 WHEN ItemMain.CostByCase = 0 AND ISNULL(ItemStore.SalePrice, 0) <> 0 AND 
                      ItemMain.CaseQty <> 0 THEN ((ISNULL(ItemStore.SalePrice, 0) / ItemMain.CaseQty) - ItemStore.Cost) / (ISNULL(ItemStore.SalePrice, 0) 
                      / ItemMain.CaseQty) * 100 END), 0) AS [Reg SP Price Margin],
					  --Pkg Price Markup
					   (CASE WHEN (ISNULL(ItemStore.PkgPrice, 0) = 0 OR
                      ISNULL(ItemStore.PkgQty, 0) = 0) THEN 0 WHEN ItemMain.CostByCase = ItemMain.PriceByCase AND 
                      ItemStore.Cost <> 0 THEN ((ISNULL(ItemStore.PkgPrice, 0) / ISNULL(ItemStore.PkgQty, 0)) - ItemStore.Cost) 
                      / ItemStore.Cost * 100 WHEN ItemMain.CostByCase = 1 AND ItemStore.Cost <> 0 AND ItemMain.CaseQty <> 0 AND 
                      (ItemStore.Cost / ItemMain.CaseQty) <> 0 THEN ((ISNULL(ItemStore.PkgPrice, 0) / ISNULL(ItemStore.PkgQty, 0)) 
                      - (ItemStore.Cost / ItemMain.CaseQty)) / (ItemStore.Cost / ItemMain.CaseQty) * 100 WHEN ItemMain.CostByCase = 0 AND 
                      ItemStore.Cost <> 0 AND ItemMain.CaseQty <> 0 THEN (((ISNULL(ItemStore.PkgPrice, 0) / ISNULL(ItemStore.PkgQty, 0)) / ItemMain.CaseQty) 
                      - ItemStore.Cost) / (ItemStore.Cost) * 100 END) AS [Pkg Price Markup],
					  --Pkg Price Margin
					   (CASE WHEN (ISNULL(ItemStore.PkgPrice, 0) = 0 OR
                      ISNULL(ItemStore.PkgQty, 0) = 0) THEN 0 WHEN ItemMain.CostByCase = ItemMain.PriceByCase AND (ISNULL(ItemStore.PkgPrice, 0) 
                      / ISNULL(ItemStore.PkgQty, 0)) <> 0 THEN ((ISNULL(ItemStore.PkgPrice, 0) / ISNULL(ItemStore.PkgQty, 0)) - ItemStore.Cost) 
                      / (ISNULL(ItemStore.PkgPrice, 0) / ISNULL(ItemStore.PkgQty, 0)) * 100 WHEN ItemMain.CostByCase = 1 AND (ISNULL(ItemStore.PkgPrice, 0) 
                      / ISNULL(ItemStore.PkgQty, 0)) <> 0 AND ItemMain.CaseQty <> 0 THEN ((ISNULL(ItemStore.PkgPrice, 0) / ISNULL(ItemStore.PkgQty, 0)) 
                      - (ItemStore.Cost / ItemMain.CaseQty)) / (ISNULL(ItemStore.PkgPrice, 0) / ISNULL(ItemStore.PkgQty, 0)) 
                      * 100 WHEN ItemMain.CostByCase = 0 AND (ISNULL(ItemStore.PkgPrice, 0) / ISNULL(ItemStore.PkgQty, 0)) <> 0 AND 
                      ItemMain.CaseQty <> 0 THEN (((ISNULL(ItemStore.PkgPrice, 0) / ISNULL(ItemStore.PkgQty, 0)) / ItemMain.CaseQty) - ItemStore.Cost) 
                      / ((ISNULL(ItemStore.PkgPrice, 0) / ISNULL(ItemStore.PkgQty, 0)) / ItemMain.CaseQty) * 100 END) AS [Pkg Price Margin], 
					  --SP Markup
                      ISNULL((CASE WHEN ItemStore.SaleType IN (1, 5, 12) THEN 
					  (IsNull((CASE WHEN ISNULL(ItemStore.SalePrice, 0) = 0 OR ISNULL(ItemStore.Cost, 0) = 0 
					  THEN 0 WHEN ItemMain.CostByCase = ItemMain.PriceByCase AND ISNULL(ItemStore.Cost, 0) 
                      <> 0 THEN (ISNULL(ItemStore.SalePrice, 0) - ISNULL(ItemStore.Cost, 0)) / ISNULL(ItemStore.Cost, 0) * 100 WHEN ItemMain.CostByCase = 1 AND 
                      ISNULL(ItemStore.Cost, 0) <> 0 AND ISNULL(ItemMain.CaseQty, 0) <> 0 AND ISNULL((ItemStore.Cost / ItemMain.CaseQty), 0) 
                      <> 0 THEN (ISNULL(ItemStore.SalePrice, 0) - (ISNULL(ItemStore.Cost, 0) / ISNULL(ItemMain.CaseQty, 0))) / (ItemStore.Cost / ItemMain.CaseQty) 
                      * 100 WHEN ItemMain.CostByCase = 0 AND ItemStore.Cost <> 0 AND ItemMain.CaseQty <> 0 THEN ((ISNULL(ItemStore.SalePrice, 0) 
                      / ItemMain.CaseQty) - ItemStore.Cost) / (ItemStore.Cost) * 100 END), 0)) 
					  WHEN ItemStore.SaleType IN (2, 6, 13, 3, 11, 18) THEN (CASE WHEN (ISNULL(ItemStore.SpecialPrice, 0) = 0 OR
                      ISNULL(ItemStore.SpecialBuy, 0) = 0) THEN 0 WHEN ItemMain.CostByCase = ItemMain.PriceByCase AND ISNULL(ItemStore.Cost, 0) 
                      <> 0 THEN ((ISNULL(ItemStore.SpecialPrice, 0) / ISNULL(ItemStore.SpecialBuy, 0)) - ISNULL(ItemStore.Cost, 0)) / ISNULL(ItemStore.Cost, 0) 
                      * 100 WHEN ItemMain.CostByCase = 1 AND ISNULL(ItemStore.Cost, 0) <> 0 AND ISNULL(ItemMain.CaseQty, 0) <> 0 AND 
                      ISNULL((ItemStore.Cost / ItemMain.CaseQty), 0) <> 0 THEN ((ISNULL(ItemStore.SpecialPrice, 0) / ISNULL(ItemStore.SpecialBuy, 0)) 
                      - ISNULL((ItemStore.Cost / ItemMain.CaseQty), 0)) / ISNULL((ItemStore.Cost / ItemMain.CaseQty), 0) * 100 WHEN ItemMain.CostByCase = 0 AND 
                      ItemStore.Cost <> 0 AND ItemMain.CaseQty <> 0 THEN (((ISNULL(ItemStore.SpecialPrice, 0) / ISNULL(ItemStore.SpecialBuy, 0)) 
                      / ItemMain.CaseQty) - ItemStore.Cost) / (ItemStore.Cost) * 100 END) ELSE 0 END), 0) AS [SP Markup], 
					  --SP Margin
					  (CASE WHEN ItemStore.SaleType IN (1, 5, 12) 
                      THEN (IsNull((CASE WHEN ItemMain.CostByCase = ItemMain.PriceByCase AND ISNULL(ItemStore.SalePrice, 0) 
                      <> 0 THEN (ISNULL(ItemStore.SalePrice, 0) - ItemStore.Cost) / ItemStore.SalePrice * 100 WHEN ItemMain.CostByCase = 1 AND 
                      ISNULL(ItemStore.SalePrice, 0) <> 0 AND ItemMain.CaseQty <> 0 THEN (ISNULL(ItemStore.SalePrice, 0) - (ItemStore.Cost / ItemMain.CaseQty)) 
                      / (ISNULL(ItemStore.SalePrice, 0)) * 100 WHEN ItemMain.CostByCase = 0 AND ISNULL(ItemStore.SalePrice, 0) <> 0 AND 
                      ItemMain.CaseQty <> 0 THEN ((ISNULL(ItemStore.SalePrice, 0) / ItemMain.CaseQty) - ItemStore.Cost) / (ISNULL(ItemStore.SalePrice, 0) 
                      / ItemMain.CaseQty) * 100 END), 0)) WHEN ItemStore.SaleType IN (2, 6, 13, 3, 11, 18) THEN ((CASE WHEN (ISNULL(ItemStore.SpecialPrice, 0) = 0 OR
                      ISNULL(ItemStore.SpecialBuy, 0) = 0) THEN 0 WHEN ItemMain.CostByCase = ItemMain.PriceByCase AND (ISNULL(ItemStore.SpecialPrice, 0) 
                      / ISNULL(ItemStore.SpecialBuy, 0)) <> 0 THEN ((ISNULL(ItemStore.SpecialPrice, 0) / ISNULL(ItemStore.SpecialBuy, 0)) - ItemStore.Cost) 
                      / (ISNULL(ItemStore.SpecialPrice, 0) / ISNULL(ItemStore.SpecialBuy, 0)) * 100 WHEN ItemMain.CostByCase = 1 AND 
                      (ISNULL(ItemStore.SpecialPrice, 0) / ISNULL(ItemStore.SpecialBuy, 0)) <> 0 AND ItemMain.CaseQty <> 0 THEN ((ISNULL(ItemStore.SpecialPrice, 0) 
                      / ISNULL(ItemStore.SpecialBuy, 0)) - (ItemStore.Cost / ItemMain.CaseQty)) / (ISNULL(ItemStore.SpecialPrice, 0) / ISNULL(ItemStore.SpecialBuy, 
                      0)) * 100 WHEN ItemMain.CostByCase = 0 AND (ISNULL(ItemStore.SpecialPrice, 0) / ISNULL(ItemStore.SpecialBuy, 0)) <> 0 AND 
                      ItemMain.CaseQty <> 0 THEN (((ISNULL(ItemStore.SpecialPrice, 0) / ISNULL(ItemStore.SpecialBuy, 0)) / ItemMain.CaseQty) - ItemStore.Cost) 
                      / ((ISNULL(ItemStore.SpecialPrice, 0) / ISNULL(ItemStore.SpecialBuy, 0)) / ItemMain.CaseQty) * 100 END)) ELSE 0 END) AS [SP Margin], 

					

                      null AS MainDepartment, null AS SubDepartment, null AS SubSubDepartment
FROM         dbo.DepartmentStore RIGHT OUTER JOIN
                      dbo.Supplier INNER JOIN
					  (SELECT     dbo.ItemSupply.*
FROM         dbo.ItemSupply
WHERE     (IsMainSupplier = 1) AND (Status <> - 1)) as ItemHeadSupplier
 ON dbo.Supplier.SupplierID = ItemHeadSupplier.SupplierNo RIGHT OUTER JOIN
                      dbo.ItemStore INNER JOIN
                      dbo.ItemMain ON dbo.ItemStore.ItemNo = dbo.ItemMain.ItemID LEFT OUTER JOIN
					  dbo.ItemSpecialView ON dbo.ItemStore.ItemStoreID = dbo.ItemSpecialView.ItemStoreID LEFT OUTER JOIN
                      dbo.Manufacturers ON dbo.ItemMain.ManufacturerID = dbo.Manufacturers.ManufacturerID ON 
                      ItemHeadSupplier.ItemSupplyID = dbo.ItemStore.MainSupplierID ON 
                      dbo.DepartmentStore.DepartmentStoreID = dbo.ItemStore.DepartmentID AND dbo.DepartmentStore.Status >0  LEFT OUTER JOIN
       --                   (SELECT     DepartmentStore.DepartmentStoreID, DepartmentStore.Name AS DepartmentName,
							--		Case When(tDepartment_3.Name Is Not Null ) 
							--		Then tDepartment_2.Name When (tDepartment_3.Name Is Null And tDepartment_2.Name is NOt null) Then tDepartment_1.Name 
							--		Else DepartmentStore.Name END As Sub1 ,

							--		Case When(tDepartment_3.Name Is Null AND tDepartment_2.Name Is Not Null) Then DepartmentStore.Name  
							--		When  (tDepartment_3.Name Is Not Null AND tDepartment_2.Name Is Not Null) Then tDepartment_1.Name  
							--		END As Sub2,
							--	  /*return the first non null value.*/	COALESCE(tDepartment_3.Name, tDepartment_2.Name, tDepartment_1.Name, DepartmentStore.Name) AS Sub3
                                                   
       --                     FROM          DepartmentStore LEFT OUTER JOIN
       --                                            DepartmentStore AS tDepartment_2 RIGHT OUTER JOIN
       --                                            DepartmentStore AS tDepartment_1 ON tDepartment_2.DepartmentStoreID = tDepartment_1.ParentDepartmentID LEFT JOIN
       --                                            DepartmentStore AS tDepartment_3 ON tDepartment_2.ParentDepartmentID = tDepartment_3.DepartmentStoreID ON 
       --                                            DepartmentStore.ParentDepartmentID = tDepartment_1.DepartmentStoreID
							--					   Where DepartmentStore.Status >0 ) AS Main ON 
       --               dbo.ItemStore.DepartmentID = Main.DepartmentStoreID LEFT OUTER JOIN
					  --dbo.MatrixTableView ON dbo.ItemMain.MatrixTableNo = dbo.MatrixTableView.MatrixTableID LEFT OUTER JOIN
       --               --dbo.UOM ON dbo.ItemMain.Unit = dbo.UOM.UOMID LEFT OUTER JOIN
       --               --dbo.SysItemTypeView ON dbo.ItemMain.ItemType = dbo.SysItemTypeView.SystemValueNo LEFT OUTER JOIN
       --               --dbo.SysProfitCalculationTypeView ON dbo.ItemStore.ProfitCalculation = dbo.SysProfitCalculationTypeView.SystemValueNo LEFT OUTER JOIN
       --               --dbo.SysCommissionTypeView ON dbo.ItemStore.CommissionType = dbo.SysCommissionTypeView.SystemValueNo LEFT OUTER JOIN
       --               --dbo.SysBarcodeTypeView ON dbo.ItemMain.BarcodeType = dbo.SysBarcodeTypeView.SystemValueNo LEFT OUTER JOIN
                      dbo.MixAndMatchView ON dbo.MixAndMatchView.MixAndMatchID = dbo.ItemStore.MixAndMatchID LEFT OUTER JOIN
                      --    (SELECT DISTINCT ItemStore.ItemNo AS ItemID, Supplier.Name AS SupplierName, ItemStore.StoreNo, ItemSupply.ItemCode AS [Supplier Item Code]
                      --      FROM          ItemStore INNER JOIN
                      --                             ItemSupply ON ItemStore.ItemStoreID = ItemSupply.ItemStoreNo AND ItemStore.MainSupplierID = ItemSupply.ItemSupplyID INNER JOIN
                      --                             Supplier ON ItemSupply.SupplierNo = Supplier.SupplierID
                      --      WHERE      (ItemSupply.Status > 0)) AS ParentInfo ON dbo.ItemStore.StoreNo = ParentInfo.StoreNo AND 
                      --dbo.ItemMain.LinkNo = ParentInfo.ItemID LEFT OUTER JOIN
                          (SELECT     ItemStoreID, MAX(DateModified) AS DateModified
                            FROM          dbo.ItemToGroup
                            GROUP BY ItemStoreID) AS Groups1 ON Groups1.ItemStoreID = dbo.ItemStore.ItemStoreID
GO