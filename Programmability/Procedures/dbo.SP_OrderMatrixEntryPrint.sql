SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_OrderMatrixEntryPrint](@ID uniqueidentifier, @MySort nvarchar(100))
AS 

IF @MySort = 'Sort'
Set @MySort = 'PurchaseOrderEntryView.SortOrder'

IF @MySort = 'SortOrder'
Set @MySort = 'PurchaseOrderEntryView.SortOrder'

If @MySort = 'ItemName'
Set @MySort = 'Name'

Declare @MySelect nvarchar(4000)
Set @MySelect = '
SELECT    DISTINCT    ItemMainAndStoreView.Name, ItemMainAndStoreView.LinkNo, ItemMainAndStoreView.BarcodeNumber, ItemMainAndStoreView.ModalNumber, PurchaseOrderEntryView.UOMQty, SysUOMTypeView.SystemValueName AS UOM, 
                         PurchaseOrderEntryView.UOMPrice, PurchaseOrderEntryView.ExtPrice AS TotalPrice, PurchaseOrderEntryView.PurchaseOrderNo, PurchaseOrderEntryView.Note, PurchaseOrderEntryView.Status, PurchaseOrderEntryView.SortOrder, ItemMainAndStoreView.CaseQty,
                         ItemMainAndStoreView.Brand, ItemMainAndStoreView.Size, ISNULL(ItemSupply.ItemCode,'''') AS SupllyCode, (CASE WHEN IsNull(ItemSupply.ItemCode, '''') 
                         = '''' THEN ParentInfo.[Supplier Item Code] ELSE ItemSupply.ItemCode END) AS ParentSupplerCode, ParentInfo.ParentName, ItemMainAndStoreView.Matrix1, ItemMainAndStoreView.Matrix2
FROM            PurchaseOrderEntryView INNER JOIN
                         ItemMainAndStoreView ON PurchaseOrderEntryView.ItemNo = ItemMainAndStoreView.ItemStoreID INNER JOIN
                         PurchaseOrders ON PurchaseOrderEntryView.PurchaseOrderNo = PurchaseOrders.PurchaseOrderId INNER JOIN
                         SysUOMTypeView ON PurchaseOrderEntryView.UOMType = SysUOMTypeView.SystemValueNo LEFT OUTER JOIN
                             (SELECT DISTINCT ItemID, SupplierName, StoreNo, [Supplier Item Code], Name AS ParentName, BarcodeNumber AS ParentID
                               FROM            ItemMainAndStoreView AS ItemMainAndStoreView_1) AS ParentInfo ON ItemMainAndStoreView.StoreNo = ParentInfo.StoreNo AND ItemMainAndStoreView.LinkNo = ParentInfo.ItemID LEFT OUTER JOIN
                         ItemSupply ON PurchaseOrders.SupplierNo = ItemSupply.SupplierNo AND PurchaseOrderEntryView.ItemNo = ItemSupply.ItemStoreNo
WHERE        (PurchaseOrderEntryView.PurchaseOrderNo =''' +CONVERT(varchar(100), @ID) + ''') AND (ItemMainAndStoreView.ItemType <> ''2'') AND (PurchaseOrderEntryView.Status > 0) ORDER BY '

Print (@MySelect + @MySort)
Exec (@MySelect + @MySort)
GO