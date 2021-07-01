SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SP_ItemsQuery]
(
@DateModified DATETIME=NULL,
@storeID UNIQUEIDENTIFIER
)
AS 

--Update ItemStore Set DateModified = dbo.GetLocalDate() Where DateModified > = dbo.GetLocalDate()

SELECT        ItemMain.ItemID, ItemMain.Name, ItemMain.Description, ItemMain.ModalNumber, ItemMain.ParentID, ItemMain.LinkNo, ItemMain.BarcodeNumber, ItemMain.ItemType, ItemMain.IsSerial, ItemStore.StoreNo, ItemStore.IsTaxable, ItemMain.PicturePath,
                         ItemStore.IsDiscount, ItemStore.IsFoodStampable, ItemStore.IsWIC, ItemStore.ListPrice, (CASE WHEN dbo.ItemMain.PriceByCase = 1 AND dbo.ItemStore.PrefSaleBy = 0 AND 
                         dbo.ItemMain.CaseQty <> 0 THEN dbo.ItemStore.Price / dbo.ItemMain.CaseQty WHEN dbo.ItemMain.PriceByCase = 0 AND 
                         dbo.ItemStore.PrefSaleBy = 2 THEN dbo.ItemStore.Price * dbo.ItemMain.CaseQty ELSE dbo.ItemStore.Price END) AS Price, (CASE WHEN dbo.ItemMain.PriceByCase = 1 AND dbo.ItemStore.PrefSaleBy = 0 AND 
                         dbo.ItemMain.CaseQty <> 0 THEN dbo.ItemStore.Price / dbo.ItemMain.CaseQty WHEN dbo.ItemMain.PriceByCase = 0 AND 
                         dbo.ItemStore.PrefSaleBy = 2 THEN dbo.ItemStore.PriceA * dbo.ItemMain.CaseQty ELSE dbo.ItemStore.PriceA END) AS PriceA, (CASE WHEN dbo.ItemMain.PriceByCase = 1 AND dbo.ItemStore.PrefSaleBy = 0 AND 
                         dbo.ItemMain.CaseQty <> 0 THEN dbo.ItemStore.Price / dbo.ItemMain.CaseQty WHEN dbo.ItemMain.PriceByCase = 0 AND 
                         dbo.ItemStore.PrefSaleBy = 2 THEN dbo.ItemStore.PriceB * dbo.ItemMain.CaseQty ELSE dbo.ItemStore.PriceB END) AS PriceB, (CASE WHEN dbo.ItemMain.PriceByCase = 1 AND dbo.ItemStore.PrefSaleBy = 0 AND 
                         dbo.ItemMain.CaseQty <> 0 THEN dbo.ItemStore.Price / dbo.ItemMain.CaseQty WHEN dbo.ItemMain.PriceByCase = 0 AND 
                         dbo.ItemStore.PrefSaleBy = 2 THEN dbo.ItemStore.PriceC * dbo.ItemMain.CaseQty ELSE dbo.ItemStore.PriceC END) AS PriceC, (CASE WHEN dbo.ItemMain.PriceByCase = 1 AND dbo.ItemStore.PrefSaleBy = 0 AND 
                         dbo.ItemMain.CaseQty <> 0 THEN dbo.ItemStore.Price / dbo.ItemMain.CaseQty WHEN dbo.ItemMain.PriceByCase = 0 AND 
                         dbo.ItemStore.PrefSaleBy = 2 THEN dbo.ItemStore.PriceD * dbo.ItemMain.CaseQty ELSE dbo.ItemStore.PriceD END) AS PriceD, (CASE WHEN dbo.ItemMain.CaseQty IS NULL 
                         THEN 1 WHEN dbo.ItemMain.CaseQty = 0 THEN 1 ELSE dbo.ItemMain.CaseQty END) AS CaseQty, (CASE WHEN ISNULL(dbo.ItemMain.CostByCase, 1) = 1 THEN Cost ELSE COST END) AS Cost, ItemMain.CaseDescription, 
                         ItemMain.CaseBarcodeNumber, ItemStore.OnOrder, ItemStore.OnTransferOrder, ItemStore.OnHand, ItemStore.BinLocation, ItemStore.DaysForReturn, ItemStore.Status, ItemStore.DateCreated, 
                         ItemStore.DateModified AS ItemStoreDateModified, ItemMain.DateModified AS MainDateModified, ItemMain.Status AS MainStatus, ItemStore.ItemStoreID, DepartmentStore.Name AS Department, 
                         DepartmentStore.DateModified AS DepartmentDateModified, ItemStore.DepartmentID, ItemMain.Matrix1, ItemMain.Matrix2, DATEADD(DAY, DATEDIFF(DAY, 0, ItemStore.SpecialBuyToDate), 0) AS SpecialBuyToDate, DATEADD(DAY,
                          DATEDIFF(DAY, 0, ItemStore.SpecialBuyFromDate), 0) AS SpecialBuyFromDate, ItemStore.SpecialPrice, ItemStore.SpecialBuy, ItemStore.SalePrice, DATEADD(DAY, DATEDIFF(DAY, 0, ItemStore.SaleStartDate), 0) AS SaleStartDate, 
                         DATEADD(DAY, DATEDIFF(DAY, 0, ItemStore.SaleEndDate), 0) AS SaleEndDate, ItemStore.SaleMin, ItemStore.SaleMax, ItemStore.MinForSale, ItemStore.SaleType, ItemStore.PrefSaleBy, ItemStore.PrefOrderBy, 
                         ItemStore.AssignDate, ItemStore.MixAndMatchID, CASE WHEN ItemMain.BarcodeType = 1 THEN 'With Weight' ELSE 'Standard' END AS BarcodeType, ItemMain.ManufacturerID, ItemMain.ManufacturerPartNo, ItemMain.PriceByCase, ItemMain.CostByCase, 
                         (CASE WHEN (ItemStore.SaleType IN (1, 5, 12)) THEN CASE WHEN ISNULL(ItemStore.AssignDate, 0) > 0 THEN CASE WHEN (dbo.GetDay(ItemStore.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) 
                         THEN '1 @ ' + CONVERT(NVARCHAR, ItemStore.SalePrice, 110) END ELSE '1 @ ' + CONVERT(NVARCHAR, ItemStore.SalePrice, 110) END WHEN (ItemStore.SaleType IN (2, 6, 13)) AND ((ISNULL(ItemStore.AssignDate, 0) > 0) AND 
                         (dbo.GetDay(ItemStore.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                         (ISNULL(ItemStore.AssignDate, 0) = 0)) THEN CONVERT(NVARCHAR, ItemStore.SpecialBuy, 110) + ' @ ' + CONVERT(NVARCHAR, ItemStore.SpecialPrice, 110) WHEN (ItemStore.SaleType IN (4, 11, 18)) AND 
                         ((ISNULL(ItemStore.AssignDate, 0) > 0) AND (dbo.GetDay(ItemStore.SaleEndDate) >= dbo.GetDay(dbo.GetLocalDATE())) OR
                         (ISNULL(ItemStore.AssignDate, 0) = 0)) THEN '1 @ ' + CONVERT(NVARCHAR, ItemStore.SalePrice, 110) + ' , ' + CONVERT(NVARCHAR, ItemStore.SpecialBuy, 110) + ' @ ' + CONVERT(NVARCHAR, ItemStore.SpecialPrice, 110) END) 
                         AS SPPrice,
                             (SELECT        IM.BarcodeNumber
                               FROM            dbo.ItemMain AS IM WITH (NOLOCK) INNER JOIN
                                                         dbo.ItemStore AS ST WITH (NOLOCK)  ON ST.ItemNo = IM.ItemID
                               WHERE        (ST.ItemStoreID = ItemStore.ExtraCharge1)) AS ExtraCharge1,
                             (SELECT        IM.BarcodeNumber
                               FROM            dbo.ItemMain AS IM WITH (NOLOCK) INNER JOIN
                                                         dbo.ItemStore AS ST WITH (NOLOCK)  ON ST.ItemNo = IM.ItemID
                               WHERE        (ST.ItemStoreID = ItemStore.ExtraCharge2)) AS ExtraCharge2,
                             (SELECT        IM.BarcodeNumber
                               FROM            dbo.ItemMain AS IM WITH (NOLOCK) INNER JOIN
                                                         dbo.ItemStore AS ST WITH (NOLOCK)  ON ST.ItemNo = IM.ItemID
                               WHERE        (ST.ItemStoreID = ItemStore.ExtraCharge3)) AS ExtraCharge3, ISNULL(ItemStore.AVGCost, (CASE WHEN ItemMain.CostByCase = 1 AND 
                         ItemMain.CaseQty <> 0 THEN ItemStore.Cost / ItemMain.CaseQty ELSE ItemStore.Cost END)) AS AvgCost, ItemStore.SpecialsMemberOnly, ItemStore.CasePrice, ItemStore.PkgQty, ItemStore.PkgPrice, ItemMain.Size, 
                         ItemMain.CaseBarCode, Manufacturers.ManufacturerName AS Brand, ISNULL(ItemStore.Tare, 0) AS Tare, ItemStore.TaxID, ItemMain.Units, LoyaltyGroup.Points, ItemMain.CustomInteger1, ItemStore.LoyaltyGroupFromDate, ItemStore.LoyaltyGroupToDate, 
                         ItemMain.Meaasure, ItemMain.NoScanMsg, ItemStore.RegSalePrice, ItemStore.CaseSpecial, ItemMain.StyleNo, SumInventory.AllOnHand - ItemStore.OnHand AS AllStoreOnHand, 0 AS Reserved, 
						  AliasTable.BarcodeNumber AS AliasBarcode,ISNULL(AliasTable.AliasCount,0)AS AliasCount , ItemMain.PkgCode,
                         (CASE WHEN OnHand > 0 THEN 1 WHEN (ItemStore.OnTransferOrder > 0 OR
                         SumInventory.AllOnHand > 0) THEN 2 WHEN SumInventory.AllOnOrder > 0 THEN 3 ELSE 0 END) AS LightStatus,
					--	 ISNULL(Ordr.Qty, 0) + ISNULL(Alocat.Qty, 0) - ISNULL(Rqusted.Qty, 0) - Cap.Cap 
					0 AS AvailForPreOrder,
					--	 ISNULL(Rqusted.TheDate,ISNULL(Alocat.TheDate,ISNULL(Ordr.TheDate,ItemStore.DateModified))) AS PreOrderDateModified,
						 ItemStore.DateModified AS MinDateModified
FROM            dbo.DepartmentStore WITH (NOLOCK) RIGHT OUTER JOIN
                         dbo.ItemStore WITH (NOLOCK)  INNER JOIN
                         dbo.ItemMain WITH (NOLOCK)  ON ItemStore.ItemNo = ItemMain.ItemID LEFT OUTER JOIN
                         dbo.LoyaltyGroup WITH (NOLOCK)  ON ItemStore.LoyaltyGroupID = LoyaltyGroup.LoyaltyGroupID LEFT OUTER JOIN
                         dbo.Manufacturers WITH (NOLOCK)  ON ItemMain.ManufacturerID = Manufacturers.ManufacturerID 
						 --LEFT OUTER JOIN
               --              (SELECT        StoreID, 0 AS Cap
               --                FROM            dbo.SetUpValues WITH (NOLOCK)  
               --                WHERE         (StoreID <> '00000000-0000-0000-0000-000000000000')) AS Cap ON ItemStore.StoreNo = Cap.StoreID LEFT OUTER JOIN
               --              (SELECT ItemStore.ItemNo ItemID, Ordr.* FROM dbo.ItemStore WITH (NOLOCK)  INNER JOIN (SELECT        PO.ItemNo AS ItemStoreID, SUM(PO.QtyOrdered) AS Qty, MAX(PO.DateModified) AS TheDate
               --                FROM            dbo.PurchaseOrderEntry AS PO WITH (NOLOCK)  INNER JOIN
               --                                          dbo.PurchaseOrders AS P WITH (NOLOCK)  ON PO.PurchaseOrderNo = P.PurchaseOrderId INNER JOIN
               --                                          dbo.PreSaleStoreIDs AS R WITH (NOLOCK)  ON P.StoreNo = R.StoreID AND P.StoreNo = R.PreSaleID
               --                WHERE        (P.Status > 0) AND (PO.Status > 0) AND (ISNULL(P.POStatus, 0) <> 2)
               --                GROUP BY PO.ItemNo) AS Ordr ON ItemStore.ItemStoreID = Ordr.ItemStoreID) AS Ordr ON ItemStore.ItemNo = Ordr.ItemID LEFT OUTER JOIN
               --        (SELECT ItemStore.ItemNo AS ItemID, Alocat.*    FROM ItemStore WITH (NOLOCK)  INNER JOIN (SELECT        A.ItemStoreID, SUM(A.QTY) AS Qty, MAX(A.DateModified) AS TheDate
               --                FROM            dbo.AllocateItems AS A WITH (NOLOCK)  INNER JOIN
               --                                          dbo.PreSaleStoreIDs AS R WITH (NOLOCK)  ON A.StoreID = R.StoreID AND A.StoreID = R.PreSaleID LEFT OUTER JOIN TransferEntry E 
														 --ON A.TransferEntryID = E.TransferEntryID LEFT OUTER JOIN ReceiveTransferEntry T ON 
														 --E.TransferEntryID = T.TransferEntryID 
               --                WHERE        (A.Status > 0) AND ISNULL(T.Status,2) >0 AND ISNULL(E.Status,2) >0  AND (ISNULL(T.Qty,0) < A.QTY) 
               --                GROUP BY A.ItemStoreID) AS Alocat ON ItemStore.ItemStoreID = Alocat.ItemStoreID ) AS Alocat ON ItemStore.ItemNo  = Alocat.ItemID  LEFT OUTER JOIN
               --              (SELECT        E.ItemId, SUM(E.Qty) AS Qty, MAX(E.DateModified) AS TheDate
               --                FROM            dbo.RequestTransferEntry AS E INNER JOIN
               --                                          dbo.RequestTransfer AS R ON E.RequestTransferID = R.RequestTransferID
               --                WHERE        (E.Status > 0) AND (R.Status > 0) AND (ISNULL(R.RequestStatus, 0) < 2)
               --                GROUP BY E.ItemId) AS Rqusted ON ItemStore.ItemNo = Rqusted.ItemId
						 LEFT OUTER JOIN
                          (SELECT  AliasCount,      ItemNo, BarcodeNumber
                               FROM            (SELECT ROW_NUMBER() OVER (PARTITION BY ItemNo
      ORDER BY ItemNo ) AS AliasCount,       ItemNo, BarcodeNumber
                                                         FROM            dbo.ItemAlias WITH (NOLOCK)
                                                         WHERE        (Status > 0)) AS f) AS AliasTable ON ItemMain.ItemID = AliasTable.ItemNo
						  ON DepartmentStore.DepartmentStoreID = ItemStore.DepartmentID LEFT OUTER JOIN
                             (SELECT        ItemNo, SUM(OnHand) AS AllOnHand, SUM(OnOrder) AS AllOnOrder
                               FROM            dbo.ItemStore AS ItemStore_1 WITH (NOLOCK)
                               WHERE        (Status > 0)
                               GROUP BY ItemNo) AS SumInventory ON ItemStore.ItemNo = SumInventory.ItemNo
WHERE       -- (ItemStore.Status > 0) AND (ItemMain.Status > 0)AND 
([StoreNo]= @storeID)  AND (ItemStore.DateModified  > @DateModified OR ItemMain.DateModified > @DateModified)
--OR 
-- ISNULL(Rqusted.TheDate,ISNULL(Alocat.TheDate,ISNULL(Ordr.TheDate,ItemStore.DateModified))) > @DateModified)
GO