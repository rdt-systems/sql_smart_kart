SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[Sp_rptOpenPO]
(@Filter nvarchar(4000))
AS

DECLARE @MySelect nvarchar(4000)

SET @MySelect ='SELECT        ISNULL(PurchaseOrderEntryView.ReceivedQty, 0) AS ReceivedQty, PurchaseOrderEntryView.QtyOrdered, PurchaseOrderEntryView.ItemName, PurchaseOrderEntryView.UPC, 
                         PurchaseOrderEntryView.ModalNumber, PurchaseOrdersView.PurchaseOrderDate, PurchaseOrdersView.POStatus, PurchaseOrdersView.StoreName, Supplier.Name AS SupplierName, Supplier.SupplierNo, 
                         ItemMainAndStoreView.Brand, ItemMainAndStoreView.Groups, ItemMainAndStoreView.Department, PurchaseOrdersView.PoNo, ItemMainAndStoreView.DepartmentID, Supplier.SupplierID, 
                         ItemMainAndStoreView.StoreNo, ItemMainAndStoreView.Price * PurchaseOrderEntryView.QtyOrdered AS TotalPrice, PurchaseOrderEntryView.ExtPrice AS TotalCost, PurchaseOrdersView.[User]
FROM            PurchaseOrderEntryView INNER JOIN
                         PurchaseOrdersView ON PurchaseOrderEntryView.PurchaseOrderNo = PurchaseOrdersView.PurchaseOrderId INNER JOIN
                         ItemMainAndStoreView ON PurchaseOrderEntryView.ItemNo = ItemMainAndStoreView.ItemStoreID LEFT OUTER JOIN
                         Supplier ON PurchaseOrdersView.SupplierNo = Supplier.SupplierID
WHERE        (PurchaseOrderEntryView.QtyOrdered > ISNULL(PurchaseOrderEntryView.ReceivedQty, 0))'


print (@MySelect + @Filter )
Execute (@MySelect + @Filter )
GO