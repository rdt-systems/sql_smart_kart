SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ReceveHistoryView]
AS
SELECT        ReceiveOrder.SupplierNo, ReceiveOrder.ReceiveOrderDate, ReceiveEntryView.ItemStoreNo, ReceiveEntryView.UOMQty, ItemMainAndStoreView.Matrix1, ItemMainAndStoreView.Matrix2, 
                         ItemMainAndStoreView.Name AS ItemName, ItemMainAndStoreView.BarcodeNumber, ReceiveEntryView.UOMType, ReceiveEntryView.Qty, ReceiveEntryView.ExtPrice, Supplier.Name AS SupplierName, 
                         ISNULL(ItemMain.Name, ItemMainAndStoreView.Name) AS ParentName, ReceiveEntryView.PcCost, ReceiveEntryView.CaseCost, ReceiveEntryView.CaseQty, ItemMainAndStoreView.Department, 
                         ItemMainAndStoreView.Groups, ReceiveOrder.ReceiveOrderDate AS StartSaleTime, ReceiveOrder.StoreID, ItemMainAndStoreView.StoreNo, ItemMainAndStoreView.OnHand, ItemMainAndStoreView.StoreName, 
                         ItemMainAndStoreView.ItemID, ItemMainAndStoreView.DepartmentID, ItemMainAndStoreView.OnOrder
FROM            ReceiveEntryView INNER JOIN
                         ReceiveOrder ON ReceiveEntryView.ReceiveNo = ReceiveOrder.ReceiveID INNER JOIN
                         ItemMainAndStoreView ON ReceiveEntryView.ItemStoreNo = ItemMainAndStoreView.ItemStoreID INNER JOIN
                         Supplier ON ReceiveOrder.SupplierNo = Supplier.SupplierID  LEFT OUTER JOIN
                         ItemMain ON ItemMainAndStoreView.LinkNo = ItemMain.ItemID
WHERE        (ReceiveEntryView.Status > - 1) AND (ReceiveOrder.Status > - 1)
GO