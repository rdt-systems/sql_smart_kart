SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetItemForLables]
(
	@User uniqueidentifier = null,
	@QtyType int =1,-- 1 = amount of @Qty, 2 = onHand Qty, 3 = Qty Enterd
	@qty int =null,
	@Date datetime =null,
	@StoreID Uniqueidentifier = NULL
)
as

IF @User = '00000000-0000-0000-0000-000000000000' SET @StoreID = NULL

SELECT DISTINCT 
                         TOP (100) PERCENT  ItemStore.ItemStoreID, ItemMain.Name, ItemMain.BarcodeNumber, (CASE WHEN ISNULL(ItemMain.Description,'') <> '' THEN ItemMain.Description ELSE ItemMain.Name END) AS Description, 
                         ItemMain.ModalNumber AS ItemCode, CASE WHEN ISNULL(CASE WHEN (CASE When ISNULL(ItemStore.SaleType,0) = 0 THEN 0 WHEN ISNULL(ItemStore.SaleType,0) <> 3 
                         THEN (Case When ItemStore.AssignDate =1 And dbo.GetDay(ISNULL(ItemStore.SaleEndDate, GETDATE())) > = dbo.GetDay(GETDATE()) And dbo.GetDay(ISNULL(ItemStore.SaleStartDate, GETDATE())) < = dbo.GetDay(GETDATE())
                          THEN 1 WHEN ItemStore.AssignDate = 0 THEN 1 ELSE 0 END) WHEN ISNULL(ItemStore.SaleType,0) = 3 THEN 
                          (Case When MixAndMatchView.AssignDate =1 And dbo.GetDay(ISNULL(MixAndMatchView.EndDate, GETDATE())) > = dbo.GetDay(GETDATE())  And dbo.GetDay(ISNULL(MixAndMatchView.StartDate, GETDATE())) < = dbo.GetDay(GETDATE()) 
						 THEN 1 WHEN MixAndMatchView.AssignDate = 0 THEN 1 ELSE 0 END) ELSE 0 END) = 0
						 THEN '' 
						 WHEN ItemStore.SaleType IN (1, 5, 12) AND (CASE WHEN ItemStore.AssignDate = 1 AND 
                         dbo.GetDay(ISNULL(ItemStore.SaleEndDate, GETDATE())) >= dbo.getday(GETDATE()) AND dbo.GetDay(ISNULL(ItemStore.SaleStartDate, GETDATE())) <= dbo.getday(GETDATE())  THEN 1 
						 WHEN ISNULL(ItemStore.AssignDate, 0) = 0 THEN 1 
						WHEN MixAndMatchView.AssignDate = 1 AND 
                         ISNULL(MixAndMatchView.EndDate, GETDATE()) <= GETDATE()  THEN 0 WHEN ISNULL(MixAndMatchView.AssignDate, 0) = 0 THEN 1 ELSE 0 END) = 1 THEN 
						 CASE WHEN ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0 
						 THEN '$' + CONVERT(nvarchar, IsNull(ItemStore.SalePrice, 0), 110) ELSE '$' + CONVERT(nvarchar, IsNull(ItemStore.SalePrice, 0), 110) END 
						 WHEN ItemStore.SaleType = 3 AND (CASE WHEN MixAndMatchView.AssignDate = 1 AND ISNULL(dbo.getday(MixAndMatchView.EndDate), dbo.getday(GETDATE())) >= dbo.Getday(GETDATE()) 
						 and ISNULL(dbo.getday(MixAndMatchView.StartDate), dbo.getday(GETDATE())) <= dbo.Getday(GETDATE())
                         THEN 1 WHEN ISNULL(MixAndMatchView.AssignDate, 0) = 0 THEN 1 ELSE 0 END) = 1 THEN CASE WHEN (ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0) THEN  CONVERT(nvarchar, 
                         IsNull(MixAndMatchView.Qty, 0)) + ' @ $' + CONVERT(nvarchar, IsNull(MixAndMatchView.Amount, 0), 110) + '' ELSE CONVERT(nvarchar, IsNull(MixAndMatchView.Qty, 0)) + ' For $' + CONVERT(nvarchar, 
                         IsNull(MixAndMatchView.Amount, 0), 110) + ' Lb.' END WHEN ItemStore.SaleType IN (2, 4, 6, 11, 13, 18) AND (CASE WHEN ItemStore.AssignDate = 1 AND dbo.GetDay(ISNULL(ItemStore.SaleEndDate, 
                         GETDATE())) >= dbo.getday(GETDATE()) THEN 1 WHEN ISNULL(ItemStore.AssignDate, 0) = 0 THEN 1 WHEN MixAndMatchView.AssignDate = 1 AND ISNULL(MixAndMatchView.EndDate, GETDATE()) 
                         <= GETDATE() THEN 0 WHEN ISNULL(MixAndMatchView.AssignDate, 0) = 0 THEN 1 ELSE 0 END) = 1 THEN CASE WHEN  (ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0) AND ISNULL(ItemStore.SpecialBuy, 0) = ISNULL(ItemMain.CaseQty,0)
                         THEN 'Case Special For $' + CONVERT(nvarchar, IsNull(ItemStore.SpecialPrice, 0), 110) + '' ELSE CASE WHEN  (ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0) 
                         THEN CONVERT(nvarchar, IsNull(ItemStore.SpecialBuy, 0)) + ' @ $' + CONVERT(nvarchar, IsNull(ItemStore.SpecialPrice, 0), 110) + '' ELSE  CONVERT(nvarchar, 
                         IsNull(ItemStore.SpecialBuy, 0)) + ' @ $' + CONVERT(nvarchar, IsNull(ItemStore.SalePrice, 0), 110) END END END,'') =  '' THEN 
						 CASE WHEN ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0 THEN '$' + CONVERT(nvarchar(100),ItemStore.Price) ELSE '$' + CONVERT(nvarchar(100),ItemStore.Price) + ' Lb.' END
						 ELSE ISNULL(CASE WHEN (CASE When ISNULL(ItemStore.SaleType,0) = 0 THEN 0 WHEN ISNULL(ItemStore.SaleType,0) <> 3 
                         THEN (Case When ItemStore.AssignDate =1 And dbo.GetDay(ISNULL(ItemStore.SaleEndDate, GETDATE())) > = dbo.GetDay(GETDATE()) And dbo.GetDay(ISNULL(ItemStore.SaleStartDate, GETDATE())) < = dbo.GetDay(GETDATE())
                          THEN 1 WHEN ItemStore.AssignDate = 0 THEN 1 ELSE 0 END) WHEN ISNULL(ItemStore.SaleType,0) = 3 THEN 
                          (Case When MixAndMatchView.AssignDate =1 And dbo.GetDay(ISNULL(MixAndMatchView.EndDate, GETDATE())) > = dbo.GetDay(GETDATE())  And dbo.GetDay(ISNULL(MixAndMatchView.StartDate, GETDATE())) < = dbo.GetDay(GETDATE()) 
						 THEN 1 WHEN MixAndMatchView.AssignDate = 0 THEN 1 ELSE 0 END) ELSE 0 END) = 0
						 THEN '' 
						 WHEN ItemStore.SaleType IN (1, 5, 12) AND (CASE WHEN ItemStore.AssignDate = 1 AND 
                         dbo.GetDay(ISNULL(ItemStore.SaleEndDate, GETDATE())) >= dbo.getday(GETDATE()) AND dbo.GetDay(ISNULL(ItemStore.SaleStartDate, GETDATE())) <= dbo.getday(GETDATE())  THEN 1 
						 WHEN ISNULL(ItemStore.AssignDate, 0) = 0 THEN 1 
						WHEN MixAndMatchView.AssignDate = 1 AND 
                         ISNULL(MixAndMatchView.EndDate, GETDATE()) <= GETDATE()  THEN 0 WHEN ISNULL(MixAndMatchView.AssignDate, 0) = 0 THEN 1 ELSE 0 END) = 1 THEN 
						 CASE WHEN ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0 
						 THEN '$' + CONVERT(nvarchar, IsNull(ItemStore.SalePrice, 0), 110) ELSE '$' + CONVERT(nvarchar, IsNull(ItemStore.SalePrice, 0), 110) END 
						 WHEN ItemStore.SaleType = 3 AND (CASE WHEN MixAndMatchView.AssignDate = 1 AND ISNULL(dbo.getday(MixAndMatchView.EndDate), dbo.getday(GETDATE())) >= dbo.Getday(GETDATE()) 
						 and ISNULL(dbo.getday(MixAndMatchView.StartDate), dbo.getday(GETDATE())) <= dbo.Getday(GETDATE())
                         THEN 1 WHEN ISNULL(MixAndMatchView.AssignDate, 0) = 0 THEN 1 ELSE 0 END) = 1 THEN CASE WHEN (ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0) THEN  CONVERT(nvarchar, 
                         IsNull(MixAndMatchView.Qty, 0)) + ' @ $' + CONVERT(nvarchar, IsNull(MixAndMatchView.Amount, 0), 110) + '' ELSE CONVERT(nvarchar, IsNull(MixAndMatchView.Qty, 0)) + ' @ $' + CONVERT(nvarchar, 
                         IsNull(MixAndMatchView.Amount, 0), 110) + ' Lb.' END WHEN ItemStore.SaleType IN (2, 4, 6, 11, 13, 18) AND (CASE WHEN ItemStore.AssignDate = 1 AND dbo.GetDay(ISNULL(ItemStore.SaleEndDate, 
                         GETDATE())) >= dbo.getday(GETDATE()) THEN 1 WHEN ISNULL(ItemStore.AssignDate, 0) = 0 THEN 1 WHEN MixAndMatchView.AssignDate = 1 AND ISNULL(MixAndMatchView.EndDate, GETDATE()) 
                         <= GETDATE() THEN 0 WHEN ISNULL(MixAndMatchView.AssignDate, 0) = 0 THEN 1 ELSE 0 END) = 1 THEN CASE WHEN  (ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0)  AND ISNULL(ItemStore.SpecialBuy, 0) = ISNULL(ItemMain.CaseQty,0)
                         THEN 'Case Special For $' + CONVERT(nvarchar, IsNull(ItemStore.SpecialPrice, 0), 110) + '' ELSE CASE WHEN  (ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0) 
                         THEN CONVERT(nvarchar, IsNull(ItemStore.SpecialBuy, 0)) + ' @ $' + CONVERT(nvarchar, IsNull(ItemStore.SpecialPrice, 0), 110) + '' ELSE CONVERT(nvarchar, 
                         IsNull(ItemStore.SpecialBuy, 0)) + ' $ $' + CONVERT(nvarchar, IsNull(ItemStore.SalePrice, 0), 110) END END END,'') END AS [SP Price], ItemStore.Cost, DepartmentStore.Name AS Department, (CASE WHEN ItemMain.Matrix1 IS NOT NULL 
                         THEN ItemMain.Matrix1 ELSE RIGHT(ItemMain.Size, CHARINDEX(' ', REVERSE(ItemMain.Size))) END) COLLATE SQL_Latin1_General_CP1_CI_AS AS Meaasure, ItemMain.Meaasure AS MeaasureType, 
                         ItemStore.ListPrice, (CASE WHEN ISNULL(ItemStore.RegSalePrice, 0) >0 THEN ('Now! $' + CONVERT(nvarchar, ISNULL(ItemStore.RegSalePrice, 0))) ELSE '' END) COLLATE SQL_Latin1_General_CP1_CI_AS AS AlwaysSpecial, (CASE WHEN ISNULL(CasePrice,0) >0 THEN ('$' + CONVERT(nvarchar, 
                         ISNULL(ItemStore.CasePrice, 0)) + 'A Case') ELSE '' END) COLLATE SQL_Latin1_General_CP1_CI_AS AS CasePrice, (CASE WHEN ISNULL(ItemStore.PkgQty, 0) > 0 AND ISNULL(ItemStore.PkgPrice, 0) 
                         > 0 THEN 'Now! ' + CONVERT(Nvarchar, ISNULL(ItemStore.PkgQty, 0)) + ' For $' + CONVERT(Nvarchar, ISNULL(ItemStore.PkgPrice, 0)) ELSE '' END) COLLATE SQL_Latin1_General_CP1_CI_AS AS RegPkgPrice, 
                         (CASE WHEN ISNULL(ItemStore.CaseSpecial, 0) > 0 THEN '$' + CONVERT(nvarchar, ISNULL(ItemStore.CaseSpecial, 0)) + ' For a Case' ELSE ' ' END) COLLATE SQL_Latin1_General_CP1_CI_AS AS CaseSpecial,
                          (CASE WHEN ManufacturersView.ManufacturerName IS NULL THEN STUFF
                             ((SELECT DISTINCT ',' + ig.ItemGroupName
                                 FROM            ItemToGroup AS itg INNER JOIN
                                                          ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
                                 WHERE        itg.ItemStoreID = ItemStore.ItemStoreID AND itg.Status > 0 FOR XML PATH(''), TYPE ).value('.', 'varchar(max)'), 1, 1, '') ELSE ManufacturersView.ManufacturerName END) COLLATE SQL_Latin1_General_CP1_CI_AS AS
                          Brand, (CASE WHEN ItemMain.Matrix2 IS NOT NULL THEN ItemMain.Matrix2 ELSE ItemMain.Size END) AS Size, 
                         
                         CASE WHEN ItemStore.SaleType = 3 THEN MixAndMatchView.StartDate ELSE ItemStore.SaleStartDate END AS SaleBegins, 
                         (CASE WHEN IsNull(ItemStore.AssignDate, 0) = 0 THEN NULL 
                         ELSE (CASE WHEN ItemStore.SaleType = 3 THEN MixAndMatchView.EndDate ELSE ItemStore.SaleEndDate END) END) AS SaleEnds, (CASE WHEN ISNUll(ItemStore.MinForSale, 0) > 0 THEN 'With Purchase of $' + CONVERT(nvarchar, 
                         ItemStore.MinForSale, 110) + '  Non Sale Items' ELSE '' END) COLLATE SQL_Latin1_General_CP1_CI_AS AS MinTotalSale, ItemMain.Units, (CASE WHEN ISNULL(ItemStore.SaleMax, 0) > 0 THEN 'Limit ' + CONVERT(nvarchar, 
                         ItemStore.SaleMax, 110) + ' Per Customer' ELSE '' END) COLLATE SQL_Latin1_General_CP1_CI_AS AS SaleMaxQty, ItemMain.CaseQty AS CsQty, ItemStore.Price, 
--Test
(CASE When ISNULL(ItemStore.SaleType,0) = 0 THEN 0 WHEN ISNULL(ItemStore.SaleType,0) <> 3 
                         THEN (Case When ItemStore.AssignDate =1 And dbo.GetDay(ISNULL(ItemStore.SaleEndDate, dbo.GetLocalDATE())) > = dbo.GetDay(dbo.GetLocalDATE())
                          THEN 1 WHEN ItemStore.AssignDate = 0 THEN 1 ELSE 0 END) WHEN ISNULL(ItemStore.SaleType,0) = 3 THEN 
                          (Case When MixAndMatchView.AssignDate =1 And dbo.GetDay(ISNULL(MixAndMatchView.EndDate, dbo.GetLocalDATE())) > = dbo.GetDay(dbo.GetLocalDATE()) 
    THEN 1 WHEN MixAndMatchView.AssignDate = 0 THEN 1 ELSE 0 END) ELSE 0 END) AS Test,
--End Test                         
                         
                         (CASE WHEN (CASE When ISNULL(ItemStore.SaleType,0) = 0 THEN 0 WHEN ISNULL(ItemStore.SaleType,0) <> 3 
                         THEN (Case When ItemStore.AssignDate =1 And dbo.GetDay(ISNULL(ItemStore.SaleEndDate, dbo.GetLocalDATE())) > = dbo.GetDay(dbo.GetLocalDATE())
                          THEN 1 WHEN ItemStore.AssignDate = 0 THEN 1 ELSE 0 END) WHEN ISNULL(ItemStore.SaleType,0) = 3 THEN 
                          (Case When MixAndMatchView.AssignDate =1 And dbo.GetDay(ISNULL(MixAndMatchView.EndDate, dbo.GetLocalDATE())) > = dbo.GetDay(dbo.GetLocalDATE()) 
    THEN 1 WHEN MixAndMatchView.AssignDate = 0 THEN 1 ELSE 0 END) ELSE 0 END) = 0
						 THEN '' 
						 WHEN ItemStore.SaleType IN (1, 5, 12) AND (CASE WHEN ItemStore.AssignDate = 1 AND 
                         dbo.GetDay(ISNULL(ItemStore.SaleEndDate, dbo.GetLocalDATE())) >= dbo.getday(dbo.GetLocalDATE()) THEN 1 WHEN ISNULL(ItemStore.AssignDate, 0) = 0 THEN 1 
         WHEN MixAndMatchView.AssignDate = 1 AND 
                         ISNULL(MixAndMatchView.EndDate, dbo.GetLocalDATE()) <= dbo.GetLocalDATE() THEN 0 WHEN ISNULL(MixAndMatchView.AssignDate, 0) = 0 THEN 1 ELSE 0 END) = 1 THEN 
						 CASE WHEN ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0 
						 THEN 'Now!  $' + CONVERT(nvarchar, IsNull(ItemStore.SalePrice, 0), 110) ELSE 'Now!  $' + CONVERT(nvarchar, IsNull(ItemStore.SalePrice, 0), 110) + ' Lb.' END 
						 WHEN ItemStore.SaleType = 3 AND (CASE WHEN MixAndMatchView.AssignDate = 1 AND ISNULL(dbo.getday(MixAndMatchView.EndDate), dbo.getday(dbo.GetLocalDATE())) >= dbo.Getday(dbo.GetLocalDATE()) 
                         THEN 1 WHEN ISNULL(MixAndMatchView.AssignDate, 0) = 0 THEN 1 ELSE 0 END) = 1 THEN CASE WHEN (ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0) THEN 'Now! ' + CONVERT(nvarchar, 
                         IsNull(MixAndMatchView.Qty, 0)) + ' For $' + CONVERT(nvarchar, IsNull(MixAndMatchView.Amount, 0), 110) + '' ELSE 'Now!  ' + CONVERT(nvarchar, IsNull(MixAndMatchView.Qty, 0)) + ' For $' + CONVERT(nvarchar, 
                         IsNull(MixAndMatchView.Amount, 0), 110) + ' Lb.' END WHEN ItemStore.SaleType IN (2, 4, 6, 11, 13, 18) AND (CASE WHEN ItemStore.AssignDate = 1 AND dbo.GetDay(ISNULL(ItemStore.SaleEndDate, 
                         dbo.GetLocalDATE())) >= dbo.getday(dbo.GetLocalDATE()) THEN 1 WHEN ISNULL(ItemStore.AssignDate, 0) = 0 THEN 1 WHEN MixAndMatchView.AssignDate = 1 AND ISNULL(MixAndMatchView.EndDate, dbo.GetLocalDATE()) 
                         <= dbo.GetLocalDATE() THEN 0 WHEN ISNULL(MixAndMatchView.AssignDate, 0) = 0 THEN 1 ELSE 0 END) = 1 THEN CASE WHEN  (ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0) 
                         THEN 'Now! ' + CONVERT(nvarchar, IsNull(ItemStore.SpecialBuy, 0)) + ' For $' + CONVERT(nvarchar, IsNull(ItemStore.SpecialPrice, 0), 110) + '' ELSE 'Now!  ' + CONVERT(nvarchar, 
                         IsNull(ItemStore.SpecialBuy, 0)) + ' For $' + CONVERT(nvarchar, IsNull(ItemStore.SalePrice, 0), 110) + ' Lb.' END END)
						   COLLATE SQL_Latin1_General_CP1_CI_AS AS DisplaySpecial,
						   --Future Specials 
						 (CASE WHEN IsNull(ItemSpecialView.SaleType, 0) = 0 OR
                         (CASE WHEN ItemSpecialView.AssignDate = 1 AND dbo.GetDay(ISNULL(ItemSpecialView.SaleEndDate, dbo.GetLocalDATE())) <= dbo.getday(dbo.GetLocalDATE()) THEN 0 WHEN ISNULL(ItemSpecialView.AssignDate, 0) 
                         = 0 THEN 1 WHEN ItemSpecialView.AssignDate = 1 AND dbo.GetDay(ISNULL(ItemSpecialView.SaleEndDate, dbo.GetLocalDATE())) >= dbo.getday(dbo.GetLocalDATE()) THEN 1 ELSE 0 END) 
                         = 0 THEN '' WHEN ItemSpecialView.SaleType IN (1, 5, 12) AND (CASE WHEN ItemSpecialView.AssignDate = 1 AND dbo.GetDay(ISNULL(ItemSpecialView.SaleEndDate, dbo.GetLocalDATE())) <= dbo.getday(dbo.GetLocalDATE()) 
                         THEN 0 WHEN ISNULL(ItemSpecialView.AssignDate, 0) = 0 THEN 1 WHEN ItemSpecialView.AssignDate = 1 AND dbo.GetDay(ISNULL(ItemSpecialView.SaleEndDate, dbo.GetLocalDATE())) >= dbo.getday(dbo.GetLocalDATE()) 
                         THEN 1 ELSE 0 END) = 1 THEN CASE WHEN ISNULL(Itemtype, 0) = 0 AND ISNULL(barcodetype, 0) = 0 THEN 'Now!  $' + CONVERT(nvarchar, IsNull(ItemSpecialView.SalePrice, 0), 110) 
                         ELSE 'Now!  $' + CONVERT(nvarchar, IsNull(ItemSpecialView.SalePrice, 0), 110) + ' lb.' END WHEN ItemSpecialView.SaleType IN (2, 4, 6, 11, 13, 18) AND (CASE WHEN ItemSpecialView.AssignDate = 1 AND 
                         dbo.GetDay(ISNULL(ItemSpecialView.SaleEndDate, dbo.GetLocalDATE())) <= dbo.getday(dbo.GetLocalDATE()) THEN 0 WHEN ISNULL(ItemSpecialView.AssignDate, 0) = 0 THEN 1 WHEN ItemSpecialView.AssignDate = 1 AND 
                         dbo.GetDay(ISNULL(ItemSpecialView.SaleEndDate, dbo.GetLocalDATE())) >= dbo.getday(dbo.GetLocalDATE()) THEN 1 ELSE 0 END) = 1 THEN CASE WHEN (ISNULL(Itemtype, 0) <> 4 AND ISNULL(barcodetype, 0) = 0) 
                         THEN 'Now! ' + CONVERT(nvarchar, IsNull(ItemSpecialView.SpecialBuy, 0)) + ' For $' + CONVERT(nvarchar, IsNull(ItemSpecialView.SpecialPrice, 0), 110) + '' ELSE 'Now!  ' + CONVERT(nvarchar, 
                         IsNull(ItemSpecialView.SpecialBuy, 0)) + ' For $' + CONVERT(nvarchar, IsNull(ItemSpecialView.SalePrice, 0), 110) + ' Lb.' END END) COLLATE SQL_Latin1_General_CP1_CI_AS AS DisplayFutureSpecial, 
                         ItemSpecialView.SaleStartDate AS FutureSaleStartDate, ItemSpecialView.SaleEndDate AS FutureSaleEndDate, (CASE WHEN ISNULL(ItemSpecialView.SaleMax, 0) > 0 THEN 'Limit ' + CONVERT(nvarchar, 
                         ItemSpecialView.SaleMax, 110) + ' Per Customer' ELSE '' END) COLLATE SQL_Latin1_General_CP1_CI_AS AS FutureSaleMaxQty, (CASE WHEN ISNULL(ItemSpecialView.MinForSale, 0) > 0 THEN 'With Purchase of $' + CONVERT(nvarchar, 
                         ItemSpecialView.MinForSale, 110) + '  Non Sale Items' ELSE '' END) COLLATE SQL_Latin1_General_CP1_CI_AS AS FutureMinTotalSale,


						 --Finish
						   (CASE WHEN ISNULL(SpecialsMemberOnly, 0) 
                         = 1 THEN '* Card Member Only' ELSE '' END) COLLATE SQL_Latin1_General_CP1_CI_AS AS DisplayMember, (CASE WHEN ISNULL(barcodetype, 0) = 0 THEN '$' + CONVERT(nvarchar, 
                         IsNull(Price, 0), 110) + ' Each' ELSE '$' + CONVERT(nvarchar, IsNull(Price, 0), 110) + ' Lb.' END) AS DisplayPrice, (CASE WHEN ISNULL(barcodetype, 0) = 0 THEN 'Reg. $' + CONVERT(nvarchar, 
                         IsNull(Price, 0), 110) + ' Each' ELSE 'Reg. $' + CONVERT(nvarchar, IsNull(Price, 0), 110) + ' Lb.' END) COLLATE SQL_Latin1_General_CP1_CI_AS AS DisplayPriceReg, (CASE WHEN (IsNull(Price, 0) > 0 AND 
                         IsNull(Units, 0) > 0) THEN Price / Units ELSE NULL END) AS DisplayMeaasure, (CASE WHEN (IsNull(Price, 0) > 0 AND IsNull(Units, 0) > 0) AND (IsNull(Meaasure, 0) > 0) THEN [dbo].[ConvertMessures](Meaasure, 
                         Units, Price) ELSE '' END) AS ConvertUnitPrice, (CASE WHEN LEN(BarcodeNumber) = 12 THEN LEFT(BarcodeNumber, 11) ELSE BarcodeNumber END) AS UPCA, (CASE WHEN isnull(IsTaxable, 0) 
                         = 1 THEN '+Tax' ELSE '' END) AS PlusTax, ParentInfo.[Supplier Item Code] AS ParentCode, ItemMain.CustomerCode AS CompanyCode, ItemMain.StyleNo, Case When ISNULL(ItemStore.CasePrice,0) >0 THEN 'Reg. $' + CONVERT(nvarchar, 
                         IsNull(CasePrice, 0), 110) + ' a Case' Else '' END as RegCasePrice, CASE WHEN ISNULL(ItemStore.IsWIC,0) = 1 THEN 'WIC' ELSE cast(ItemMain.ExtraInfo2 AS NVARCHAR(max)) END as ExtraInfo2, 	
						 CASE when ISNULL(cast(ItemMain.ExtraInfo as nvarchar(max)),'') = '' Then ItemStore.BinLocation ELSE  cast(ItemMain.ExtraInfo as nvarchar(max)) END as ExtraInfo,
						 itemmain.[PicturePath]
Into #ItemlableView
FROM            ItemMain INNER JOIN
                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo LEFT OUTER JOIN
                         ItemSpecialView ON ItemStore.ItemStoreID = ItemSpecialView.ItemStoreID LEFT OUTER JOIN
                         DepartmentStore ON ItemStore.DepartmentID = DepartmentStore.DepartmentStoreID LEFT OUTER JOIN
                         ManufacturersView ON ItemMain.ManufacturerID = ManufacturersView.ManufacturerID LEFT OUTER JOIN
                         MixAndMatchView ON ItemStore.MixAndMatchID = MixAndMatchView.MixAndMatchID LEFT OUTER JOIN
                             (SELECT DISTINCT ItemID, SupplierName, StoreNo, [Supplier Item Code], Name
                               FROM            ItemMainAndStoreView AS ItemMainAndStoreView_1) AS ParentInfo ON ItemMain.LinkNo = ParentInfo.ItemID AND ItemStore.StoreNo = ParentInfo.StoreNo
WHERE       ItemStore.ItemStoreID In(SELECT     PrintLabels.ItemStoreID from PrintLabels where Status >0 AND (StoreID = @StoreID OR @StoreID IS NULL) AND (UserCreated =@User or @User is null))

BEGIN
  IF @QtyType =3 
  BEGIN
    IF @User is null 
    BEGIN

			WITH CTE ( Number) as
(
      SELECT 1
      UNION ALL
      SELECT Number + 1
      FROM CTE
      WHERE Number < 100
)

      SELECT    *  FROM  #ItemlableView AS IL INNER JOIN (SELECT     PrintLabels.ItemStoreID, Qtylbl.number
	  FROM PrintLabels INNER JOIN    (SELECT     number     FROM        CTE
      WHERE      (number > 0)) AS Qtylbl ON PrintLabels.Qty >= Qtylbl.number AND PrintLabels.Tag =1 AND PrintLabels.Status >0 
	  AND (PrintLabels.StoreID = @StoreID OR @StoreID IS NULL)) AS PrintQty ON IL.ItemStoreID = PrintQty.ItemStoreID
	  Order by ISNULL(StyleNo,Name), Meaasure,Size   OPTION ( MAXRECURSION 0)
    END
    ELSE
    BEGIN

	WITH CTE ( Number) as
(
      SELECT 1
      UNION ALL
      SELECT Number + 1
      FROM CTE
      WHERE Number < 100
)
      SELECT     * FROM  #ItemlableView AS IL INNER JOIN (SELECT     PrintLabels.ItemStoreID, Qtylbl.number
	  FROM PrintLabels INNER JOIN    (SELECT     number     FROM          CTE
      WHERE      (number > 0)) AS Qtylbl ON PrintLabels.Qty >= Qtylbl.number AND PrintLabels.Tag =1  AND PrintLabels.Status >0 
	  AND (PrintLabels.StoreID = @StoreID OR @StoreID IS NULL)
            AND PrintLabels.UserCreated =@User) AS PrintQty ON IL.ItemStoreID = PrintQty.ItemStoreID
			Order by ISNULL(StyleNo,Name), Meaasure,Size   OPTION ( MAXRECURSION 0)
    END
  END

  ELSE IF @QtyType= 2
  BEGIN
    IF @User is null 
    BEGIN
		WITH CTE ( Number) as
(
      SELECT 1
      UNION ALL
      SELECT Number + 1
      FROM CTE
      WHERE Number < 100
)
      SELECT  *  FROM            ItemlableView AS IL INNER JOIN
(SELECT        PrintLabels.ItemStoreID, Qtylbl.number, ItemStore.OnHand
FROM            PrintLabels INNER JOIN ItemStore ON PrintLabels.ItemStoreID = ItemStore.ItemStoreID INNER JOIN
(SELECT        number FROM           CTE  WHERE        (number > 0)) AS Qtylbl ON ItemStore.OnHand >= Qtylbl.number AND PrintLabels.Tag = 1
 AND PrintLabels.Status >0 AND (PrintLabels.StoreID = @StoreID OR @StoreID IS NULL)) AS PrintQty 
ON IL.ItemStoreID = PrintQty.ItemStoreID
Order by ISNULL(StyleNo,Name), Meaasure,Size   OPTION ( MAXRECURSION 0)
    END
    ELSE
    BEGIN
			WITH CTE ( Number) as
(
      SELECT 1
      UNION ALL
      SELECT Number + 1
      FROM CTE
      WHERE Number < 100
)
          SELECT     * FROM  ItemlableView AS IL INNER JOIN (SELECT     PrintLabels.ItemStoreID, Qtylbl.number, ItemStore.OnHand
			FROM   PrintLabels INNER JOIN  ItemStore ON PrintLabels.ItemStoreID = ItemStore.ItemStoreID INNER JOIN
                          (SELECT     number         FROM         CTE
                            WHERE      (number > 0)) AS Qtylbl ON ItemStore.OnHand >= Qtylbl.number   AND PrintLabels.Status >0 
	  AND (PrintLabels.StoreID = @StoreID OR @StoreID IS NULL)
							AND PrintLabels.UserCreated =@User AND PrintLabels.Tag =1) AS PrintQty 
                            ON IL.ItemStoreID = PrintQty.ItemStoreID 
							Order by ISNULL(StyleNo,Name), Meaasure,Size   OPTION ( MAXRECURSION 0)
    END    
  END

  ELSE IF @QtyType= 1
  BEGIN
    IF @User is null 
    BEGIN
				WITH CTE ( Number) as
(
      SELECT 1
      UNION ALL
      SELECT Number + 1
      FROM CTE
      WHERE Number < 100
)
      SELECT     * FROM  #ItemlableView AS IL INNER JOIN (SELECT     PrintLabels.ItemStoreID, @Qty As Qty
	  FROM PrintLabels INNER JOIN    (SELECT     number     FROM         CTE
      WHERE      (number > 0)) AS Qtylbl ON @Qty >= Qtylbl.number AND PrintLabels.Tag =1 and Status>0   AND PrintLabels.Status >0 
	  AND (PrintLabels.StoreID = @StoreID OR @StoreID IS NULL)) AS PrintQty ON IL.ItemStoreID = PrintQty.ItemStoreID
	  Order by ISNULL(StyleNo,Name), Meaasure,Size   OPTION ( MAXRECURSION 0)
    END
    ELSE
    BEGIN 
					WITH CTE ( Number) as
(
      SELECT 1
      UNION ALL
      SELECT Number + 1
      FROM CTE
      WHERE Number < 100
)
	  SELECT     PrintLabels.ItemStoreID, @Qty As Qty Into #PrintQty
	  FROM PrintLabels INNER JOIN    (SELECT     number     FROM         CTE
      WHERE      (number > 0)) AS Qtylbl ON @Qty >= Qtylbl.number AND PrintLabels.UserCreated =@User AND PrintLabels.Tag =1 and Status>0
	    AND PrintLabels.Status >0 
	  AND (PrintLabels.StoreID = @StoreID OR @StoreID IS NULL)

	   SELECT     * FROM  #ItemlableView AS IL INNER JOIN #PrintQty AS PrintQty ON IL.ItemStoreID = PrintQty.ItemStoreID   
	   Order by ISNULL(StyleNo,Name), Meaasure,Size   OPTION ( MAXRECURSION 0)
	   drop table #PrintQty 

   --   SELECT     * FROM  ItemlableView AS IL INNER JOIN (SELECT     PrintLabels.ItemStoreID, @Qty As Qty
	  --FROM PrintLabels INNER JOIN    (SELECT     number     FROM          master.dbo.spt_values
   --   WHERE      (type = 'P') AND (number > 0)) AS Qtylbl ON @Qty >= Qtylbl.number AND PrintLabels.UserCreated =@User AND PrintLabels.Tag =1 and Status>0) AS PrintQty ON IL.ItemStoreID = PrintQty.ItemStoreID

    END  
  END
END
drop table   #ItemlableView
GO