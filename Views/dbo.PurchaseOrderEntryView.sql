SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO




CREATE VIEW [dbo].[PurchaseOrderEntryView]
AS

	SELECT      ItemMainAndStoreList.DepartmentID,  PurchaseOrderEntry.PurchaseOrderEntryId, PurchaseOrderEntry.PurchaseOrderNo, PurchaseOrderEntry.ItemNo, PurchaseOrderEntry.QtyOrdered, PurchaseOrderEntry.PricePerUnit, PurchaseOrderEntry.UOMQty, 
                         PurchaseOrderEntry.UOMType, ISNULL(PurchaseOrderEntry.ExtPrice, 0) AS ExtPrice, PurchaseOrderEntry.IsSpecialPrice, ItemMainAndStoreList.LinkNo, PurchaseOrderEntry.Note, PurchaseOrderEntry.SortOrder, 
                         PurchaseOrderEntry.Status, PurchaseOrderEntry.DateCreated, PurchaseOrderEntry.UserCreated, PurchaseOrderEntry.DateModified, PurchaseOrderEntry.UserModified, 
                         PurchaseOrderEntry.QtyOrdered * PurchaseOrderEntry.PricePerUnit / CASE WHEN dbo.PurchaseOrderEntry.UOMQty <> 0 THEN dbo.PurchaseOrderEntry.UOMQty ELSE 1 END AS UOMPrice, 
                        CASE WHEN dbo.PurchaseOrders.POStatus = 2 THEN 0 ELSE (CASE WHEN QtyOrdered > isnull(ReceivedQty, 0) THEN QtyOrdered - isnull(ReceivedQty, 0) ELSE 0 END) END AS OrderDeficit, 
                         ItemMainAndStoreList.Name AS ItemName, ItemMainAndStoreList.BarcodeNumber AS UPC, ItemMainAndStoreList.ModalNumber, ISNULL(ItemMainAndStoreList.CaseQty, 1) AS CaseQty, 
                         ISNULL(ItemMainAndStoreList.CaseQty, 1) * ISNULL(PurchaseOrderEntry.PricePerUnit, 0) AS CaseCost, ItemMainAndStoreList.ItemID, ItemSupply.ItemCode,
						 ItemMainAndStoreList.ParentCode, PurchaseOrderEntry.Discount, PurchaseOrderEntry.DiscountType,
                         ItemMainAndStoreList.Matrix1, ItemMainAndStoreList.Matrix2, 
						 ParentMain.name as ParentName,
						 (CASE WHEN PurchaseOrderEntry.UOMType = 2 AND IsNull(Receives.ReceivedQty, 0)   > 0 THEN Receives.ReceivedQty / ISNULL(dbo.ItemMainAndStoreList.CaseQty, 1) ELSE IsNull(Receives.ReceivedQty, 0) END) AS ReceivedQty,
						  ItemMainAndStoreList.StyleNo, 
                         ItemMainAndStoreList.[Supplier Item Code], PurchaseOrderEntry.CostBeforeDis, PurchaseOrderEntry.EstimateCost, PurchaseOrderEntry.NetCost, PurchaseOrderEntry.SpecialCost, ItemMainAndStoreList.Brand, 
                         ItemMainAndStoreList.SubSubDepartment AS SubDepart2, PurchaseOrderEntry.NetCost * PurchaseOrderEntry.QtyOrdered AS TotalDiscount, ItemMainAndStoreList.ItemStoreID, 
                         ItemMainAndStoreList.Size
FROM           PurchaseOrders INNER JOIN
                         PurchaseOrderEntry  on  PurchaseOrderEntry.PurchaseOrderNo = PurchaseOrders.PurchaseOrderId
                        INNER JOIN ItemMainAndStoreList ON PurchaseOrderEntry.ItemNo = ItemMainAndStoreList.ItemStoreID 
						 left OUTER JOIN ItemSupply ON  PurchaseOrderEntry.ItemNo =  ItemSupply.ItemStoreNo and PurchaseOrders.SupplierNo = ItemSupply.SupplierNo 
						 left outer  JOIN itemmain ParentMain on ParentMain.ItemID=ItemMainAndStoreList.LinkNo
						 left outer  JOIN ItemStore ParentStore on ParentStore.itemno=ParentMain.itemId and ParentStore.StoreNo=ItemMainAndStoreList.StoreNo 
						 left OUTER JOIN ItemSupply as ParentItemSupply ON  ParentStore.ItemStoreID = ItemSupply.ItemStoreNo AND ParentStore.MainSupplierID = ItemSupply.ItemSupplyID
						left outer join  (SELECT     SUM(CASE WHEN UOMType <> 0 AND CaseQty > 1 THEN   Qty * CaseQty ELSE Qty END) AS ReceivedQty, PurchaseOrderEntryNo
                          FROM            ReceiveEntry
                          WHERE        (Status > 0)
                          GROUP BY PurchaseOrderEntryNo) AS Receives
						 ON Receives.PurchaseOrderEntryNo = PurchaseOrderEntry.PurchaseOrderEntryId 
WHERE        (ISNULL(ItemSupply.Status, 0) > 0)

--SELECT        PurchaseOrderEntry.PurchaseOrderEntryId, PurchaseOrderEntry.PurchaseOrderNo, PurchaseOrderEntry.ItemNo, PurchaseOrderEntry.QtyOrdered, PurchaseOrderEntry.PricePerUnit, PurchaseOrderEntry.UOMQty, 
--                         PurchaseOrderEntry.UOMType, ISNULL(PurchaseOrderEntry.ExtPrice, 0) AS ExtPrice, PurchaseOrderEntry.IsSpecialPrice, ItemMainAndStoreList.LinkNo, PurchaseOrderEntry.Note, PurchaseOrderEntry.SortOrder, 
--                         PurchaseOrderEntry.Status, PurchaseOrderEntry.DateCreated, PurchaseOrderEntry.UserCreated, PurchaseOrderEntry.DateModified, PurchaseOrderEntry.UserModified, 
--                         PurchaseOrderEntry.QtyOrdered * PurchaseOrderEntry.PricePerUnit / CASE WHEN dbo.PurchaseOrderEntry.UOMQty <> 0 THEN dbo.PurchaseOrderEntry.UOMQty ELSE 1 END AS UOMPrice, 
--                         CASE WHEN dbo.PurchaseOrders.POStatus = 2 THEN 0 ELSE (CASE WHEN QtyOrdered > isnull(ReceivedQty, 0) THEN QtyOrdered - isnull(ReceivedQty, 0) ELSE 0 END) END AS OrderDeficit, 
--                         ItemMainAndStoreList.Name AS ItemName, ItemMainAndStoreList.BarcodeNumber AS UPC, ItemMainAndStoreList.ModalNumber, ISNULL(ItemMainAndStoreList.CaseQty, 1) AS CaseQty, 
--                         ISNULL(ItemMainAndStoreList.CaseQty, 1) * ISNULL(PurchaseOrderEntry.PricePerUnit, 0) AS CaseCost, ItemMainAndStoreList.ItemID, ItemSupply.ItemCode, ParentInfo.[Supplier Item Code] AS ParentCode, 
--                         ItemMainAndStoreList.Matrix1, ItemMainAndStoreList.Matrix2, ParentInfo.ParentName, (CASE WHEN PurchaseOrderEntry.UOMType = 2 AND IsNull(Receives.ReceivedQty, 0) 
--                         > 0 THEN Receives.ReceivedQty / ISNULL(dbo.ItemMainAndStoreList.CaseQty, 1) ELSE IsNull(Receives.ReceivedQty, 0) END) AS ReceivedQty, ItemMainAndStoreList.StyleNo, 
--                         ItemMainAndStoreList.[Supplier Item Code], PurchaseOrderEntry.CostBeforeDis, PurchaseOrderEntry.EstimateCost, PurchaseOrderEntry.NetCost, PurchaseOrderEntry.SpecialCost, ItemMainAndStoreList.Brand, 
--                         ItemMainAndStoreList.SubSubDepartment AS SubDepart2, PurchaseOrderEntry.NetCost * PurchaseOrderEntry.QtyOrdered AS TotalDiscount, ItemMainAndStoreList.ItemStoreID, 
--                         ItemMainAndStoreList.Size
--FROM            (SELECT     SUM(CASE WHEN UOMType <> 0 AND CaseQty > 1 THEN   Qty * CaseQty ELSE Qty END) AS ReceivedQty, PurchaseOrderEntryNo
--                          FROM            ReceiveEntry
--                          WHERE        (Status > 0)
--                          GROUP BY PurchaseOrderEntryNo) AS Receives RIGHT OUTER JOIN
--                         ItemSupply RIGHT OUTER JOIN
--                             (SELECT DISTINCT ItemID, SupplierName, StoreNo, [Supplier Item Code], Name AS ParentName
--                               FROM            ItemMainAndStoreList AS ItemMainAndStoreList_1) AS ParentInfo RIGHT OUTER JOIN
--                         PurchaseOrderEntry INNER JOIN
--                         ItemMainAndStoreList ON PurchaseOrderEntry.ItemNo = ItemMainAndStoreList.ItemStoreID ON ParentInfo.ItemID = ItemMainAndStoreList.LinkNo AND ParentInfo.StoreNo = ItemMainAndStoreList.StoreNo ON 
--                         ItemSupply.ItemStoreNo = PurchaseOrderEntry.ItemNo ON Receives.PurchaseOrderEntryNo = PurchaseOrderEntry.PurchaseOrderEntryId RIGHT OUTER JOIN
--                         PurchaseOrders ON ItemSupply.SupplierNo = PurchaseOrders.SupplierNo AND PurchaseOrderEntry.PurchaseOrderNo = PurchaseOrders.PurchaseOrderId
--WHERE        (ISNULL(ItemSupply.Status, 0) > 0)
GO