SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_OrderMatrixParents](@ID uniqueidentifier)
AS 

SELECT        itemmainandstoreviewParent.ItemID, itemmainandstoreviewParent.Name, itemmainandstoreviewParent.StyleNo, itemmainandstoreviewParent.Brand, itemmainandstoreviewParent.ListPrice, 
                         itemmainandstoreviewParent.Price, itemmainandstoreviewParent.Cost, itemmainandstoreviewParent.NetCost, itemmainandstoreviewParent.SpecialCost, ItemsLookupValues.ValueName AS ExtName, 
                         SUM(PurchaseOrderEntryView.UOMQty) AS count, SUM(PurchaseOrderEntryView.UOMQty) * itemmainandstoreviewParent.NetCost AS TotalCost, MIN(PurchaseOrderEntryView.SortOrder) AS SortOrder, 
                         DepartmentStore.Name AS DepartmentName
FROM            PurchaseOrderEntryView INNER JOIN
                         ItemStore ON ItemStore.ItemStoreID = PurchaseOrderEntryView.ItemNo INNER JOIN
                         ItemMain ON ItemStore.ItemNo = ItemMain.ItemID INNER JOIN
                             (SELECT        ItemMain.ItemID, ItemMain.Name,  ItemMain.StyleNo, ItemStore.ListPrice, ItemStore.Price, ItemStore.Cost, ItemStore.NetCost, ItemStore.SpecialCost, ItemStore.StoreNo, 
                         Manufacturers.ManufacturerName AS Brand
FROM            ItemMain INNER JOIN
                         ItemStore ON ItemMain.ItemID = ItemStore.ItemNo LEFT OUTER JOIN
                         Manufacturers ON ItemMain.ManufacturerID = Manufacturers.ManufacturerID
WHERE        (ItemMain.ItemType = 2)) AS itemmainandstoreviewParent ON itemmainandstoreviewParent.ItemID = ItemMain.LinkNo AND 
                         ItemStore.StoreNo = itemmainandstoreviewParent.StoreNo LEFT OUTER JOIN
                         ItemsLookupValues ON ItemsLookupValues.ValueID = ItemMain.ExtName LEFT OUTER JOIN
                         DepartmentStore ON DepartmentStore.DepartmentStoreID = ItemStore.DepartmentID
WHERE        (PurchaseOrderEntryView.PurchaseOrderNo = @ID)
GROUP BY itemmainandstoreviewParent.ItemID, itemmainandstoreviewParent.Name, itemmainandstoreviewParent.StyleNo,  itemmainandstoreviewParent.Brand, itemmainandstoreviewParent.Price, 
                         itemmainandstoreviewParent.Cost, itemmainandstoreviewParent.NetCost, itemmainandstoreviewParent.ListPrice, itemmainandstoreviewParent.SpecialCost, ItemsLookupValues.ValueName, 
                         DepartmentStore.Name
ORDER BY MIN(SortOrder)
GO