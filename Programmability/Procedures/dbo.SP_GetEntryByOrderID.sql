SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_GetEntryByOrderID]
(@Filter nvarchar(4000))

as
declare @MySelect varchar(MAX)
Set @MySelect = ' SELECT        PurchaseOrderEntryView.ItemName AS Name, PurchaseOrderEntryView.UPC AS BarcodeNumber, PurchaseOrderEntryView.ModalNumber, PurchaseOrderEntryView.OrderDeficit AS Qty, 
                         PurchaseOrderEntryView.UOMPrice, SysUOMTypeView.SystemValueName AS UOM, PurchaseOrderEntryView.ExtPrice, PurchaseOrderEntryView.PurchaseOrderEntryId AS ID, PurchaseOrders.TermsNo, 
                         ISNULL(PurchaseOrderEntryView.CaseQty, 1) AS CaseQty, PurchaseOrderEntryView.Discount, PurchaseOrderEntryView.PurchaseOrderNo AS PONO, PurchaseOrderEntryView.ItemNo AS ItemStoreID, PurchaseOrderEntryView.ParentCode, 
                         ISNULL(PurchaseOrderEntryView.ItemCode, '''') AS ItemCode,PurchaseOrderEntryView.[Supplier Item Code] AS SupplierItemCode, PurchaseOrderEntryView.Matrix1 as Color, PurchaseOrderEntryView.Matrix2 as Size
FROM            PurchaseOrderEntryView INNER JOIN
                         PurchaseOrders ON PurchaseOrders.PurchaseOrderId = PurchaseOrderEntryView.PurchaseOrderNo INNER JOIN
                         SysUOMTypeView ON PurchaseOrderEntryView.UOMType = SysUOMTypeView.SystemValueNo
WHERE        (PurchaseOrderEntryView.OrderDeficit > 0) AND (PurchaseOrderEntryView.Status > 0)  '

--set @MySelect= 'SELECT        ItemMainAndStoreGrid.Name, ItemMainAndStoreGrid.BarcodeNumber, ItemMainAndStoreGrid.ModalNumber, PurchaseOrderEntryView.OrderDeficit AS Qty, 
--                         PurchaseOrderEntryView.UOMPrice, SysUOMTypeView.SystemValueName AS UOM, PurchaseOrderEntryView.ExtPrice, 
--                         PurchaseOrderEntryView.PurchaseOrderEntryId AS ID, PurchaseOrders.TermsNo, ISNULL(ItemMainAndStoreGrid.CaseQty, 1) AS CaseQty, 
--                         PurchaseOrderEntryView.PurchaseOrderNo AS PONO, ItemMainAndStoreGrid.ItemStoreID, ParentInfo.[Supplier Item Code]As ParenCode, 
--                         IsNull(PurchaseOrderEntryView.ItemCode,'''')As ItemCode
--FROM            PurchaseOrderEntryView INNER JOIN
--                         PurchaseOrders ON PurchaseOrders.PurchaseOrderId = PurchaseOrderEntryView.PurchaseOrderNo INNER JOIN
--                         SysUOMTypeView ON PurchaseOrderEntryView.UOMType = SysUOMTypeView.SystemValueNo INNER JOIN
--                         ItemMainAndStoreGrid ON PurchaseOrderEntryView.ItemNo = ItemMainAndStoreGrid.ItemStoreID LEFT OUTER JOIN
--                             (SELECT DISTINCT ItemID, SupplierName, StoreNo, [Supplier Item Code]
--                               FROM            ItemMainAndStoreGrid AS ItemMainAndStoreGrid_1) AS ParentInfo ON ItemMainAndStoreGrid.LinkNo = ParentInfo.ItemID AND 
--                         ItemMainAndStoreGrid.StoreNo = ParentInfo.StoreNo
--WHERE        (PurchaseOrderEntryView.OrderDeficit > 0) AND (PurchaseOrderEntryView.Status > 0)'

print(@MySelect + @Filter +' ORDER BY PurchaseOrderEntryView.SortOrder')
Execute (@MySelect + @Filter +' ORDER BY PurchaseOrderEntryView.SortOrder')
GO