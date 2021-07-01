SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO








CREATE VIEW [dbo].[GenOrderViewAllStore]
AS
SELECT        top 100 PERCENT  GenOrderView.ItemName, GenOrderView.BarcodeNumber, GenOrderView.ModalNumber, GenOrderView.ToOrder, GenOrderView.ReorderPoint, GenOrderView.RestockLevel, GenOrderView.Reorder, GenOrderView.UOMType, GenOrderView.GenPurchaseOrderID, GenOrderView.Status, 
                         GenOrderView.SortOrder, GenOrderView.CaseQty, GenOrderView.VenderCode, GenOrderView.Department, GenOrderView.PcCost, GenOrderView.CsCost, GenOrderView.DateModified, GenOrderView.ItemID, 
                         GenOrderView.UserModified, GenOrderView.ItemStoreID, GenOrderView.StoreID, GenOrderView.SupplierItemCode, GenOrderView.ItemType, GenOrderView.StoreName, GenOrderView.MainSupplierID, 
                         GenOrderView.DepartmentID, GenOrderView.ManufacturerID, GenOrderView.SupplierName, GenOrderView.SupplierNo, GenOrderView.LastReceived, GenOrderView.MTD, GenOrderView.YTD, GenOrderView.PTD, 
                         GenOrderView.CustomerCode, GenOrderView.Groups, SumAllStore.Qty3, SumAllStore.Qty7, SumAllStore.Qty14, SumAllStore.Qty30,SumAllStore.Qty60, SumAllStore.Qty90, SumAllStore.Qty180, SumAllStore.TransferQty, 
                         SumAllStore.OnHand, SumAllStore.OnOrder
FROM            GenOrderView INNER JOIN
                         Store ON GenOrderView.StoreID = Store.StoreID INNER JOIN
                             (SELECT        ItemID, SUM(Qty3) AS Qty3, SUM(Qty7) AS Qty7, SUM(Qty14) AS Qty14, SUM(Qty30) AS Qty30,SUM(Qty60) AS Qty60,  SUM(Qty90) AS Qty90, SUM(Qty180) AS Qty180, SUM(OnHand) AS OnHand, SUM(OnOrder) AS OnOrder, 
                                                         SUM(TransferQty) AS TransferQty
                               FROM            GenOrderView AS GenOrderView_1
                               GROUP BY ItemID) AS SumAllStore ON GenOrderView.ItemID = SumAllStore.ItemID
WHERE        (Store.IsMainStore = 1)
GO