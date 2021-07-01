SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[GenOrderView]
AS
SELECT TOP 100 PERCENT
	ItemMain.Name AS ItemName, 
	ItemMain.ModalNumber, 
	ItemMain.BarcodeNumber, 
	GenPurchaseOrderView.ToOrder,
	CAST(GenPurchaseOrderView.ReorderQty AS float) AS Reorder, 
	ISNULL(GenPurchaseOrderView.UOMType, isnull(ItemStoreView.PrefOrderBy,case when costbycase =2 then 2 else 0 end )) AS UOMType, 
	GenPurchaseOrderView.GenPurchaseOrderID, 
	isnull(GenPurchaseOrderView.Status,1) as Status, 
	GenPurchaseOrderView.SortOrder, 
	ItemMain.CaseQty, 
    Supplier_1.SupplierNo AS VenderCode, 
	DepartmentStore.Name AS Department, 
	(CASE WHEN ItemMain.CostByCase = 1 THEN ItemStoreView.Cost ELSE ItemStoreView.Cost * ItemMain.CaseQty END) AS CsCost, 
	(CASE WHEN ItemMain.CostByCase = 1 AND ItemMain.CaseQty <> 0 THEN ItemStoreView.Cost / ItemMain.CaseQty ELSE ItemStoreView.Cost END) AS PcCost, 
    GenPurchaseOrderView.DateCreated AS DateModified,
	ItemMain.ItemID, 
	GenPurchaseOrderView.UserModified, 
	ItemStoreView.ItemStoreID, 
	ItemStoreView.StoreNo AS StoreID, 
	ItemStoreView.OnHand, 
    ItemSupply.ItemCode AS SupplierItemCode, 
	ItemStoreView.OnOrder, 
	ItemMain.ItemType, 
	Store.StoreName, 
	ItemStoreView.MainSupplierID, 
	ItemMain.ManufacturerID, 
	ItemStoreView.DepartmentID,
	ItemStoreView.ReorderPoint, 
	ItemStoreView.RestockLevel,
    COALESCE (Supplier.Name, Supplier_1.Name) AS SupplierName, 
	COALESCE (GenPurchaseOrderView.Supplier, Supplier.SupplierID) AS SupplierNo,				 
	ISNULL(Qty3, 0) AS Qty3, 
	ISNULL(Qty7, 0) AS Qty7, 
	ISNULL(Qty14, 0) AS Qty14, 
	ISNULL(Qty30, 0) AS Qty30,
	ISNULL(Qty60, 0) AS Qty60,
	ISNULL(Qty90, 0) AS Qty90, 
	ISNULL(Qty180, 0) AS Qty180, 
    LastReceived.LastDate AS LastReceived, 
	ISNULL(OnTransfer.TransferQty, 0) AS TransferQty, 
	ISNULL(ItemStoreView.MTDQty, 0) AS MTD, 
	ISNULL(ItemStoreView.YTDQty, 0) AS YTD, 
                         ISNULL(ItemStoreView.PTDQty, 0) AS PTD, ItemMain.CustomerCode AS CustomerCode, 
								 CONVERT(nvarchar(500),
	                STUFF((SELECT DISTINCT ',' + ig.ItemGroupName
                              FROM         dbo.ItemToGroup AS itg INNER JOIN
                                                    dbo.ItemGroup ig ON itg.ItemGroupID = ig.ItemGroupID
                              WHERE     itg.ItemStoreID = ItemStoreView.ItemStoreID AND itg.Status > 0
							FOR xml PATH ('')), 1, 1, '')) AS Groups
FROM            ItemMain
--View 
INNER JOIN
                         ItemStoreView ON ItemMain.ItemID = ItemStoreView.ItemNo 
INNER JOIN
                         Store ON ItemStoreView.StoreNo = Store.StoreID 

LEFT OUTER JOIN
                        Supplier 
						 INNER JOIN
                         ItemSupply ON Supplier.SupplierID = ItemSupply.SupplierNo ON ItemStoreView.ItemStoreID = ItemSupply.ItemStoreNo AND ItemStoreView.MainSupplierID = ItemSupply.ItemSupplyID 
LEFT OUTER JOIN
                         DepartmentStore ON ItemStoreView.DepartmentID = DepartmentStore.DepartmentStoreID 
LEFT OUTER JOIN
                         GenPurchaseOrderView ON ItemStoreView.ItemStoreID = GenPurchaseOrderView.ItemNo 
						 LEFT OUTER JOIN
                         Supplier AS Supplier_1 ON GenPurchaseOrderView.Supplier = Supplier_1.SupplierID 
--LEFT OUTER JOIN TransactionEntryQty ON ItemStoreView.ItemStoreID = TransactionEntryQty.ItemStoreID



LEFT OUTER JOIN (
select --top 1
itemstoreid,--,qty
SUM(CASE WHEN StartSaleTime > DATEADD(DAY, - 3, dbo.GetLocalDATE()) THEN Qty END) AS Qty3,
SUM(CASE WHEN StartSaleTime > DATEADD(DAY, - 7, dbo.GetLocalDATE()) THEN Qty END) AS Qty7,
SUM(CASE WHEN StartSaleTime > DATEADD(DAY, - 14, dbo.GetLocalDATE()) THEN Qty END) AS Qty14,
SUM(CASE WHEN StartSaleTime > DATEADD(DAY, - 30, dbo.GetLocalDATE()) THEN Qty END) AS Qty30,
SUM(CASE WHEN StartSaleTime > DATEADD(DAY, - 60, dbo.GetLocalDATE()) THEN Qty END) AS Qty60,
SUM(CASE WHEN StartSaleTime > DATEADD(DAY, - 90, dbo.GetLocalDATE()) THEN Qty END) AS Qty90,
SUM(CASE WHEN StartSaleTime > DATEADD(DAY, - 180, dbo.GetLocalDATE()) THEN Qty END) AS Qty180
from TransactionEntryQty 
where StartSaleTime >--between   DATEADD(DAY, - 3, dbo.GetLocalDATE()) AND
 DATEADD(DAY, - 180, dbo.GetLocalDATE()) 
group by [itemstoreid]

)  TransactionEntryQty ON ItemStoreView.ItemStoreID = TransactionEntryQty.ItemStoreID
                             --(SELECT        SUM(TransactionEntry_1.Qty) AS Qty3, TransactionEntry_1.ItemStoreID
                             --  FROM            TransactionEntry AS TransactionEntry_1 INNER JOIN
                             --                            [Transaction] AS Transaction_1 ON TransactionEntry_1.TransactionID = Transaction_1.TransactionID
--                               WHERE        (TransactionEntry_1.Status > 0) AND (Transaction_1.Status > 0) AND (dbo.GetDay(Transaction_1.StartSaleTime) > DATEADD(DAY, - 3, dbo.GetLocalDATE()))
--                               GROUP BY TransactionEntry_1.ItemStoreID) AS Last3Days ON ItemStoreView.ItemStoreID = Last3Days.ItemStoreID

 LEFT OUTER JOIN
                             (SELECT        ToItemStoreID, ISNULL(SUM(Qty), 0) - ISNULL(SUM(ReceiveQty), 0) AS TransferQty
                               FROM            TransferEntryView
                               GROUP BY ToItemStoreID) AS OnTransfer ON ItemStoreView.ItemStoreID = OnTransfer.ToItemStoreID
 LEFT OUTER JOIN
                             (SELECT        ReceiveEntry.ItemStoreNo, MAX(ReceiveOrderView.BillDate) AS LastDate
                               FROM            ReceiveEntry INNER JOIN
                                                         ReceiveOrderView ON ReceiveEntry.ReceiveNo = ReceiveOrderView.ReceiveID
                               WHERE        (ReceiveEntry.Status > 0) AND (ReceiveOrderView.Status > 0)
                               GROUP BY ReceiveEntry.ItemStoreNo) AS LastReceived ON ItemStoreView.ItemStoreID = LastReceived.ItemStoreNo 
							   --LEFT OUTER JOIN
--                             (SELECT        SUM(TransactionEntry_3.Qty) AS Qty90, TransactionEntry_3.ItemStoreID
--                               FROM            TransactionEntry AS TransactionEntry_3 INNER JOIN
--                                                         [Transaction] AS Transaction_3 ON TransactionEntry_3.TransactionID = Transaction_3.TransactionID
--                               WHERE        (TransactionEntry_3.Status > 0) AND (Transaction_3.Status > 0) AND (dbo.GetDay(Transaction_3.StartSaleTime) > DATEADD(DAY, - 90, dbo.GetLocalDATE()))
--                               GROUP BY TransactionEntry_3.ItemStoreID) AS Last90Days ON ItemStoreView.ItemStoreID = Last90Days.ItemStoreID LEFT OUTER JOIN
--                             (SELECT        SUM(TransactionEntry_4.Qty) AS Qty180, TransactionEntry_4.ItemStoreID
--                               FROM            TransactionEntry AS TransactionEntry_4 INNER JOIN
--                                                         [Transaction] AS Transaction_4 ON TransactionEntry_4.TransactionID = Transaction_4.TransactionID
--                               WHERE        (TransactionEntry_4.Status > 0) AND (Transaction_4.Status > 0) AND (dbo.GetDay(Transaction_4.StartSaleTime) > DATEADD(DAY, - 180, dbo.GetLocalDATE()))
--                               GROUP BY TransactionEntry_4.ItemStoreID) AS last180Days ON ItemStoreView.ItemStoreID = last180Days.ItemStoreID LEFT OUTER JOIN
--                             (SELECT        SUM(TransactionEntry_2.Qty) AS Qty30, TransactionEntry_2.ItemStoreID
--                               FROM            TransactionEntry AS TransactionEntry_2 INNER JOIN
--                                                         [Transaction] AS Transaction_2 ON TransactionEntry_2.TransactionID = Transaction_2.TransactionID
--                               WHERE        (TransactionEntry_2.Status > 0) AND (Transaction_2.Status > 0) AND (dbo.GetDay(Transaction_2.StartSaleTime) > DATEADD(DAY, - 30, dbo.GetLocalDATE()))
--                               GROUP BY TransactionEntry_2.ItemStoreID) AS Last30Days ON ItemStoreView.ItemStoreID = Last30Days.ItemStoreID LEFT OUTER JOIN
--                             (SELECT        SUM(TransactionEntry_1.Qty) AS Qty14, TransactionEntry_1.ItemStoreID
--                               FROM            TransactionEntry AS TransactionEntry_1 INNER JOIN
--                                                         [Transaction] AS Transaction_1 ON TransactionEntry_1.TransactionID = Transaction_1.TransactionID
--                               WHERE        (TransactionEntry_1.Status > 0) AND (Transaction_1.Status > 0) AND (dbo.GetDay(Transaction_1.StartSaleTime) > DATEADD(DAY, - 14, dbo.GetLocalDATE()))
--                               GROUP BY TransactionEntry_1.ItemStoreID) AS Last14Days ON ItemStoreView.ItemStoreID = Last14Days.ItemStoreID LEFT OUTER JOIN
--                             (SELECT        SUM(TransactionEntry.Qty) AS Qty7, TransactionEntry.ItemStoreID
--                               FROM            TransactionEntry INNER JOIN
--                                                         [Transaction] ON TransactionEntry.TransactionID = [Transaction].TransactionID
--                               WHERE        (TransactionEntry.Status > 0) AND ([Transaction].Status > 0) AND (dbo.GetDay([Transaction].StartSaleTime) > DATEADD(DAY, - 7, dbo.GetLocalDATE()))
--                               GROUP BY TransactionEntry.ItemStoreID) AS Last7Days ON ItemStoreView.ItemStoreID = Last7Days.ItemStoreID
WHERE        (ItemStoreView.Status > 0) AND (ItemMain.Status > 0)
ORDER BY GenPurchaseOrderView.SortOrder
--group by ItemMain.ItemID, storeid
GO